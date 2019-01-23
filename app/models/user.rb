class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates_presence_of :username
  validates_uniqueness_of :username, :case_sensitive => false

  after_create :add_default_role, :add_default_image, :add_default_channels

  mount_uploader :image, ImageUploader
  
  # answer
  has_many :answers, dependent: :destroy, :foreign_key => "author_id"

  # post
  has_many :posts, dependent: :destroy, :foreign_key => "author_id"

  # custom question
  has_many :custom_questions, dependent: :destroy, :foreign_key => "author_id"

  # friend requests
  has_many :received_requests, :class_name => "FriendRequest", :foreign_key => "requestee_id", dependent: :destroy
  has_many :requesters, through: :received_requests, dependent: :destroy

  has_many :made_requests, :class_name => "FriendRequest", :foreign_key => "requester_id", dependent: :destroy
  has_many :requestees, through: :made_requests, dependent: :destroy
 
  # friendship
  has_many :friendships, :class_name => "Friendship", :foreign_key => "user_id", dependent: :destroy
  has_many :friends, :through => :friendships, dependent: :destroy

  # assignment
  has_many :received_assignments, :class_name => "Assignment", :foreign_key => "assignee_id", dependent: :destroy
  has_many :assigners, :through => :received_assignments, dependent: :destroy

  has_many :made_assignments, :class_name => "Assignment", :foreign_key => "assigner_id", dependent: :destroy
  has_many :assignees, :through => :made_assignments, dependent: :destroy

  # highlight
  # has_many :highlights, dependent: :destroy

  # highlight
  has_many :likes, dependent: :destroy

  # comment
  has_many :comments, dependent: :destroy, :foreign_key => "author_id"

  # tmi
  has_many :tmis, dependent: :destroy, :foreign_key => "author_id"

  # notification
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy 

  # drawers
  has_many :drawers, dependent: :destroy

  # query
  has_many :queries, dependent: :destroy
  has_many :user_queries, dependent: :destroy

  # channel
  has_many :channels, dependent: :destroy
  has_many :passive_friendships, :class_name => "Friendship", :foreign_key => "friend_id", dependent: :destroy
  has_many :belonging_channels, through: :passive_friendships, :source => :channels


  # reference: http://railscasts.com/episodes/163-self-referential-association
  
  # BETA: email confirmation 잠깐 해지해놓음!! 베타 이전에 이 부분 다시 주석처리해야 email confirmation 제대로 됨
  protected
  def confirmation_required?
    false
  end

  private
  # 첫 유저만 admin role으로 등록되고 나머지는 newuser role로 등록됨. (Rolify 문서 참조)
  # 실제 서비스할 때(?) 1번 유저 admin으로 미리 등록하는거 잊지 말기 (혹은 모델 코드를 변경하거나)
  def add_default_role
    if (self.id == 1)
      self.add_role :admin 
    else
      self.add_role :newuser
    end
  end

  def add_default_image
    random = rand(1..6)
    self.image = Rails.root.join("app/assets/images/icons/profile" + random.to_s + ".png").open
    self.save!
  end

  def add_default_channels
    # 나만보기와 익명피드는 아무도 friend로 들어갈 수 없는 채널임.
    # 이것은 백이 아니라 프론트에서 막을 것임 (콘솔에서는 가능하지만, UI상 그렇게 할 수 있는 버튼이 없기 때문에 실제 서비스에서는 불가능할 예정)
    Channel.create(name: "익명피드", user: self)
    Channel.create(name: "나만보기", user: self)
    Channel.create(name: "일촌", user: self)
    Channel.create(name: "이촌", user: self)
    Channel.create(name: "삼촌", user: self)
    # Channel.create(name: "전체공개", user: self)
  end
end

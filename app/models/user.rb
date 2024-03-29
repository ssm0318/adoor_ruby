# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_token_authenticatable

  rolify
  
  extend FriendlyId
  friendly_id :username, use: :slugged

  def slug=(value)
    if value.present?
      write_attribute(:slug, value)
    end
  end

  def should_generate_new_friendly_id?
    slug.blank? || username_changed?
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable

  # validates_presence_of :username
  # validates_uniqueness_of :username, :case_sensitive => false

  # validates :username, format: { 
  #   with: /\A[^.][a-zA-Z0-9._\s].*[^.]$\z/i, 
  #   message: "사용자 이름에는 알파벳, 숫자, 밑줄(_) 및 마침표(.)만 사용할 수 있습니다.\n첫 글자와 마지막 글자는 마침표(.)가 될 수 없습니다." }, 
  #   length: { in: 3..20 
  # }

  after_create :add_default_role, :add_default_image, :add_default_channels

  mount_uploader :image, ImageUploader

  # visit
  has_many :visits, dependent: :destroy, class_name: "Ahoy::Visit"
  
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

  # notification
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy 

  # drawers
  has_many :drawers, dependent: :destroy

  # query
  has_many :queries, dependent: :destroy
  has_many :user_queries, dependent: :destroy

  # tag
  has_many :tags, dependent: :destroy, :foreign_key => "author_id"

  # channel
  has_many :channels, dependent: :destroy
  has_many :passive_friendships, :class_name => "Friendship", :foreign_key => "friend_id", dependent: :destroy
  has_many :belonging_channels, through: :passive_friendships, :source => :channels, dependent: :destroy

  has_many :identities, dependent: :destroy

  # reference: http://railscasts.com/episodes/163-self-referential-association
  
  # 카카오 로그인
  def self.find_for_oauth(auth, signed_in_resource = nil)
    # user하고 identity가 nil이 아닐 경우
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user

    if user.nil?
      email = auth.info.email
      user = User.where(:email => email).first

      # 이미 존재하는 이메일이 아니라면
      unless self.where(email: auth.info.email).exists?
        if user.nil?
          if auth.provider == "kakao"
            # https://github.com/shaynekang/omniauth-kakao 참고
            # user = User.create(email: auth.info.email, password: Devise.friendly_token[0,20])
            user = User.create(password: Devise.friendly_token[0,20])
            puts '====================================================='
            puts user.errors.full_messages
            puts '====================================================='
          end
        end
      end
    end 

    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_required?
    false
    # true
  end
  
  protected
  def confirmation_required?
    if Rails.env.development?
      false
      # true
    elsif Rails.env.production?
      # true
      false
    end
  end

  private
  # 첫 유저만 admin role으로 등록되고 나머지는 newuser role로 등록됨. (Rolify 문서 참조)
  # 실제 서비스할 때(?) 1번 유저 admin으로 미리 등록하는거 잊지 말기 (혹은 모델 코드를 변경하거나)
  def add_default_role
    if (self.id <= 5)
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
    Channel.create(name: "나", user: self)
    Channel.create(name: "일촌", user: self)
    Channel.create(name: "이촌", user: self)
    Channel.create(name: "삼촌", user: self)
    # Channel.create(name: "전체공개", user: self)
  end
end

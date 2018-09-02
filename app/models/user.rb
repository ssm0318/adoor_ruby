class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :add_default_role

  # question
  has_many :questions, dependent: :destroy

  # answer
  has_many :answers, dependent: :destroy

  # friend requests
  has_many :received_requests, :class_name => "FriendRequest", :foreign_key => "requestee_id", dependent: :destroy
  has_many :requesters, through: :received_requests, dependent: :destroy

  has_many :made_requests, :class_name => "FriendRequest", :foreign_key => "requester_id", dependent: :destroy
  has_many :requestees, through: :made_requests, dependent: :destroy

  # friendship
  has_many :friendships, dependent: :destroy
  has_many :friends, :through => :friendships, dependent: :destroy

  # assignment
  has_many :received_assignments, :class_name => "Assignment", :foreign_key => "assignee_id", dependent: :destroy
  has_many :assigners, :through => :received_assignments, dependent: :destroy

  has_many :made_assignments, :class_name => "Assignment", :foreign_key => "assigner_id", dependent: :destroy
  has_many :assignees, :through => :made_assignments, dependent: :destroy

  # highlight
  has_many :highlights, dependent: :destroy

  # comment
  has_many :comments, dependent: :destroy

  # tmi
  has_many :tmis, dependent: :destroy

  # notification
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  # star
  has_many :stars, dependent: :destroy

  # reference: http://railscasts.com/episodes/163-self-referential-association

  def add_default_role
    if (self.id == 1)
      self.add_role :admin
    end
  end
end

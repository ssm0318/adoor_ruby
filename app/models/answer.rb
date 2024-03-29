class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :question
  # has_many   :highlights, dependent: :destroy
  has_many   :comments, dependent: :destroy, as: :target
  has_many   :likes, dependent: :destroy, as: :target
  has_many   :drawers, dependent: :destroy, as: :target
  has_many   :entrances, as: :target, dependent: :destroy
  has_many   :channels, -> { order(id: :asc) }, through: :entrances
  has_and_belongs_to_many :tags, dependent: :destroy, as: :target

  scope :anonymous, ->(id) { where.not(author: User.find(id).friends).where.not(author: User.find(id)) }
  scope :named, ->(id) { where(author: User.find(id).friends).or(where(author: User.find(id))) }

  # 이 id의 유저가 answer의 채널에 독자로 있어서 (친구 권한으로) 볼 수 있는 answer들
  # 예: 2번 유저의 answer들 중 4번 유저가 볼 수 있는 answer 찾기 -> Answer.where(author_id: 2).accessible(4)
  scope :accessible, ->(id) { joins(:channels).where(channels: { id: User.find(id).belonging_channels.ids }).distinct }
  ## 혹시 includes로 바꿔야하게 된다면 - for future Yuri: eager_load보다 includes.references가 낫다는 글
  ## http://blog.ifyouseewendy.com/blog/2015/11/11/preload-eager_load-includes-references-joins/

  # 이 id의 channel에 속한 answer들 구하기
  # 예: Answer.channel(3) 하면 3번 채널에 속한 answer들 나옴
  scope :channel, ->(id) { joins(:channels).where(channels: { id: id }).distinct }
  scope :search_tag, ->(tag) { joins(:tags).where('tags.content LIKE ? ', "%#{tag}%").distinct }

  scope :channel_name, ->(name) { joins(:channels).where(channels: { name: name }).distinct }

  # after_update :change_notifications
  after_destroy :destroy_notifications

  private

  def destroy_notifications
    Notification.where(target: self).destroy_all
  end
end

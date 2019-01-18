class Post < ApplicationRecord
    belongs_to :author, class_name: 'User'
    has_many   :comments, dependent: :destroy, as: :target
    has_many   :likes, dependent: :destroy, as: :target
    has_many   :entrances, as: :target, dependent: :destroy
    has_many   :channels, through: :entrances
    has_many   :drawers, dependent: :destroy, as: :target
    has_and_belongs_to_many :tags, dependent: :destroy, as: :target

    scope :anonymous, -> (id) { where.not(author: User.find(id).friends).where.not(author: User.find(id)) }
    scope :named, -> (id) { where(author: User.find(id).friends).or(where(author:User.find(id))) }

    # 이 id의 유저가 answer의 채널에 독자로 있어서 (친구 권한으로) 볼 수 있는 answer들
    # 예: 2번 유저의 answer들 중 4번 유저가 볼 수 있는 answer 찾기 -> Answer.where(author_id: 2).accessible(4)
    scope :accessible, -> (id) { joins(:channels).where(channels: {id: User.find(id).belonging_channels.ids}) }
    
    # 이 id의 channel에 속한 answer들 구하기
    # 예: Answer.channel(3) 하면 3번 채널에 속한 answer들 나옴
    scope :channel, -> (id) { includes(:channels).references(:channels).where(channels: {id: id}) }

    scope :search_tag, -> (tag) { joins(:tags).where("tags.content LIKE ? ", "%#{tag}%").distinct }
end
  
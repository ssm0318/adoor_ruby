class Query < ApplicationRecord
    belongs_to :user

    scope :popular_search, -> (num) { select('content, count(content) as freq').order('freq desc').group('content').take(num) }
end

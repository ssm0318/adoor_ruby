class Announcement < ApplicationRecord
    has_many   :comments, dependent: :destroy, as: :target

    scope :unpublished, -> { where(published_at: nil) }
    scope :published, -> { where.not(published_at: nil) }

    after_destroy :destroy_notifications

    def destroy_notifications
        Notification.where(target: self).destroy_all
    end
end

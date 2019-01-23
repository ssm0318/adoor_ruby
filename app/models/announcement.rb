class Announcement < ApplicationRecord
    has_and_belongs_to_many :users, dependent: :destroy
    after_create :add_all_users

    private
    def add_all_users
        self.users << User.all
    end
end

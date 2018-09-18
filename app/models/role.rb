class Role < ApplicationRecord
    
    # Rolify model의 디폴트 코드임. 무시 ㄱㄱ
    has_and_belongs_to_many :users, :join_table => :users_roles


    belongs_to :resource,
               :polymorphic => true,
               :optional => true


    validates :resource_type,
              :inclusion => { :in => Rolify.resource_types },
              :allow_nil => true

    scopify
end

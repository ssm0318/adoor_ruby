class RolifyCreateRoles < ActiveRecord::Migration[5.1]

  # 유저 모델에 역할을 부여한다. Cancancan Gem과 조합하면 역할에 따라 다른 권한을 부여할 수 있다. 
  # https://github.com/RolifyCommunity/rolify/wiki/Devise---CanCanCan---rolify-Tutorial <-- 참조
  
  def change
    create_table(:roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:users_roles, :id => false) do |t|
      t.references :user
      t.references :role
    end
    
    add_index(:roles, :name)
    add_index(:roles, [ :name, :resource_type, :resource_id ])
    add_index(:users_roles, [ :user_id, :role_id ])
  end
end

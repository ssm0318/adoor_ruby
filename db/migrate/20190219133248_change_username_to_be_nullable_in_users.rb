class ChangeUsernameToBeNullableInUsers < ActiveRecord::Migration[5.1]
  def change
    change_column_null :users, :username, true
  end
end

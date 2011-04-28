class RemoveTimestampFromAdmins < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :created_at
    remove_column :accounts, :updated_at
  end

  def self.down
   
  end
end

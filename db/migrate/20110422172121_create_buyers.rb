class CreateBuyers < ActiveRecord::Migration
  def self.up
    create_table :buyers do |t|

   
    end
  end

  def self.down
    drop_table :buyers
  end
end

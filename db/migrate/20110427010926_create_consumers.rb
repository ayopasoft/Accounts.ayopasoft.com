class CreateConsumers < ActiveRecord::Migration
  def self.up
    create_table :consumers do |t|

    end
  end

  def self.down
    drop_table :consumers
  end
end

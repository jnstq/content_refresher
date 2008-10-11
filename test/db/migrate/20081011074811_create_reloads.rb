class CreateReloads < ActiveRecord::Migration
  def self.up
    create_table :reloads do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :reloads
  end
end

class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.text :message
      t.integer :findentrepreneur_id

      t.timestamps
    end
  end
end

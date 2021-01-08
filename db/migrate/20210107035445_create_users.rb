# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, index: true, unique: true
      t.string :first_name
      t.string :last_name
      t.string :password

      t.timestamps
    end
  end
end

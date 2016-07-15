class Twitterapi < ActiveRecord::Migration
  def change

    create_table :users do |t|
      t.string :twitter_handles
    end

    create_table :tweets do |t|
      t.belongs_to :user, index: true
      t.string :content
    end

  end
end

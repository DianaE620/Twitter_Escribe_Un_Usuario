class User < ActiveRecord::Base
  # Remember to create a migration!
  has_many :tweets

  def self.tweets_update?(user)
    new_tweets = $client.user_timeline(user)
    old_tweets = User.find_by(twitter_handles: user).tweets.last

    if new_tweets[0].text == old_tweets.content
      true
    else
      false
    end

  end

end

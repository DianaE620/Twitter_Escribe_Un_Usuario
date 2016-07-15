get '/' do
  # La siguiente linea hace render de la vista 
  # que esta en app/views/index.erb

  erb :index
end

get '/tweet' do
  erb :new_tweet
end

post '/tweet' do
  new_tweet = params[:newTweet]

  $client.update(new_tweet)

  new_tweet

end

post '/fetch' do
  twitteruser = params[:tweet]

  begin
  user_name = $client.user(twitteruser).screen_name
  user_tweets = $client.user_timeline(twitteruser)

 if User.find_by(twitter_handles: user_name)
    usuario_twitter = User.find_by(twitter_handles: user_name)
    unless User.tweets_update?(user_name)
      for i in 0..9 do
        usuario_twitter.tweets << Tweet.find_or_create_by(content: user_tweets[i].text)
        break if i == usuario_twitter.tweets.count - 1
      end
    end
  else
    usuario_twitter = User.create(twitter_handles: user_name)
    for i in 0..9 do
      usuario_twitter.tweets << Tweet.find_or_create_by(content: user_tweets[i].text)
    end
  end  

  redirect to("/" + user_name)

  rescue
    @error = 1
    erb :index
  end

end

get '/:handle' do

  user_name = params[:handle]
  @user_tweets = User.find_by(twitter_handles: user_name).tweets.last(10)

  erb :tweets

end

post '/ajax/twitter' do 
  twitteruser = params[:tweet]
  user_name = $client.user(twitteruser).screen_name
  user_tweets = $client.user_timeline(twitteruser)

  if User.find_by(twitter_handles: user_name)
    usuario_twitter = User.find_by(twitter_handles: user_name)
    unless User.tweets_update?(user_name)
      for i in 0..9 do
        usuario_twitter.tweets << Tweet.find_or_create_by(content: user_tweets[i].text)
        break if i == usuario_twitter.tweets.count - 1
      end
    end
  else
    usuario_twitter = User.create(twitter_handles: user_name)
    for i in 0..9 do
      usuario_twitter.tweets << Tweet.create(content: user_tweets[i].text)
      break if i == user_tweets.count - 1
    end
  end 

  tweets_objects = User.find_by(twitter_handles: user_name).tweets.last(10)

  tweets = []
  tweets_objects.each do |t|
    tweets << "<li>" + t.content + "</li><br>"
  end

  tweets

end






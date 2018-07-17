class TweetsController < ApplicationController

  get '/tweets' do  #render tweet index page if logged in
    if logged_in?
      @user = current_user
      erb :'tweets/tweets'
    else
      redirect to "/login"
    end
  end

  get '/tweets/new' do #render new tweet form
    if logged_in?
      @user = current_user
      erb :'tweets/create_tweet'
    else
      redirect to "/login"
    end
  end

  post '/tweets/:userslug' do #post new tweet
    if !params[:tweet].empty?
      @user = User.find_by_slug(params[:userslug])
      @tweet = Tweet.create(content: params[:tweet], user_id: @user.id)
      redirect to "tweets/#{@tweet.id}"
    else
      redirect to "tweets/new"
    end
  end

   get '/tweets/:id' do  #if user owns tweet go to tweet page
     @tweet = Tweet.find_by(id: params[:id])
     binding.pry
     if @tweet.user_id == session[:user_id]
       erb :'/tweets/show_tweet'
     elsif logged_in? && @tweet.user_id != current_user.id #if logged in but doesn't owen tweet go to index
       redirect to "/tweets"
     else
       redirect to "/login"
     end
   end

  delete '/tweets/:id/delete' do #button only on tweet page, can't access unless logged in
    tweet = Tweet.find_by(id: params[:id])
    tweet.delete
    redirect to "/tweets"
  end

  get '/tweets/:id/edit' do # edit page, validates logged_in
    @tweet = Tweet.find_by(id: params[:id])
    if logged_in? && current_user.id == session[:user_id]
      erb :'tweets/edit_tweet'
    else
      redirect to "/login"
    end
  end

  patch '/tweets/:id' do

    tweet = Tweet.find_by(id: params[:id])

    if !params[:content].empty? #if the tweet is empty it deosn't allow the update
      tweet.update(content: params[:content])
      redirect to "/tweets/#{tweet.id}"
    else
      redirect to "/tweets/#{tweet.id}/edit"
    end
  end

end

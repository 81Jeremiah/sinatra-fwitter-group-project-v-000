class TweetsController < ApplicationController

  get '/tweets' do
    if logged_in?
      @user = current_user
      erb :'tweets/tweets'
    else
      redirect to "/login"
    end
  end

  get '/tweets/new' do
    if logged_in?
      @user = current_user
      erb :'tweets/create_tweet'
    else
      redirect to "/login"
    end
  end

  post '/tweets/:userslug' do
    if !params[:tweet].empty?
      @user = User.find_by_slug(params[:userslug])
      @tweet = Tweet.create(content: params[:tweet], user_id: @user.id)
      redirect to "tweets/#{@tweet.id}"
    else
      redirect to "tweets/new"
    end
  end

   get '/tweets/:id' do
     @tweet = Tweet.find_by(params[:id])
     if @tweet.user_id == session[:user_id]
       erb :'/tweets/show_tweet'
     else
       redirect to "/login"
     end
   end

  delete '/tweets/:id/delete' do
    tweet = Tweet.find_by(id: params[:id])
    tweet.delete
    redirect to "/tweets"
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find_by(id: params[:id])
    if logged_in? && current_user.id == session[:user_id]
      erb :'tweets/edit_tweet'
    else
      redirect to "/login"
    end
  end

  patch '/tweets/:id' do

    tweet = Tweet.find_by(id: params[:id])

    if !params[:content].empty?
      tweet.update(content: params[:content])
      redirect to "/tweets/#{tweet.id}"
    else
      redirect to "/tweets/#{tweet.id}/edit"
    end
  end

end

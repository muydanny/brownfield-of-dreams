class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def login
    client_id     = "36d16b999bf13e5ac1a0"
    client_secret = "5f632d26221ae9854c7f60f84cd253bdc8f5480a"
    code          = params[:code]
    response      = Faraday.post("https://github.com/login/oauth/access_token?client_id=#{client_id}&client_secret=#{client_secret}&code=#{code}")
    pairs = response.body.split("&")
    response_hash = {}
    pairs.each do |pair|
      key, value = pair.split("=")
      response_hash[key] = value
    end

    token = response_hash["access_token"]
    oauth_response = Faraday.get("https://api.github.com/user?access_token=#{token}")

    auth = JSON.parse(oauth_response.body)
    # user          = User.find_or_create_by(id: auth["id"])
    user          = User.find(session[:user_id])
    user.token    = "token #{token}"
    user.save!
    session[:user_id] = user.id
    redirect_to dashboard_path
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash[:error] = 'Looks like your email or password is invalid'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end

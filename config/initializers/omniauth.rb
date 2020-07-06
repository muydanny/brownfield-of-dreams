Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GIT_CLIENT_ID'], ENV['GIT_CLIENT_SECRET']
end

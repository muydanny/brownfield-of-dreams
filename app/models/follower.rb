class Follower
  
  attr_reader :login,
              :url
  def initialize(follower_data)
    @login = follower_data[:login]
    @url = follower_data[:html_url]
  end

  def exists_in_the_system?
    User.where(username: @login)
  end

end

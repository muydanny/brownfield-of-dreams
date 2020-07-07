class Following

  attr_reader :login,
              :url

  def initialize(following_data)
    @login = following_data[:login]
    @url = following_data[:html_url]
  end

  def user_exists?
    User.find_by(login: @login)
  end

end
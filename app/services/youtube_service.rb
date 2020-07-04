class YoutubeService

  def create_videos(tutorial)
    url = "/youtube/v3/playlistItems?playlistId=#{tutorial.playlist_id}"
    res = get_json(url, {part: "snippet"})  
  end
  
  # could go into a youtube poro
  def playlist_video_params(tutorial)
    videos_params = []
    create_videos(tutorial)[:items].each do |video|
      video_params = {} 
      video_params[:title] = video[:snippet][:title] 
      video_params[:description] = video[:snippet][:description]
      video_params[:thumbnail] = video[:snippet][:thumbnails][:default]
      videos_params << video_params
    end
    videos_params
  end

  def video_info(id)
    params = { part: 'snippet,contentDetails,statistics', id: id }

    get_json('youtube/v3/videos', params)
  end

  private

  def get_json(url, params)
    response = conn.get(url, params)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: 'https://www.googleapis.com') do |f|
      f.adapter Faraday.default_adapter
      f.params[:key] = ENV['YOUTUBE_API_KEY']
    end
  end
end

class YoutubeService
  def create_videos(tutorial, videos = [], nextPageToken = nil)
    url = "/youtube/v3/playlistItems?playlistId=#{tutorial.playlist_id}"
    params = { part: 'snippet', maxResults: 50 }

    params[:pageToken] = nextPageToken if nextPageToken

    res = get_json(url, params)
    videos << res[:items]

    if res[:nextPageToken]
      # using recursion
      create_videos(tutorial, videos, res[:nextPageToken])
    end
    ## return an array with   item objects
    videos.flatten
  end

  # could go into a youtube poro
  def playlist_video_params(tutorial)
    videos_params = []
    create_videos(tutorial).each do |video|
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

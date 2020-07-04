class Admin::TutorialsController < Admin::BaseController
  def edit
    @tutorial = Tutorial.find(params[:id])
  end

  def create 
    tutorial = Tutorial.create(new_tutorial_params)
    if tutorial.save
      create_videos(tutorial)
      # YoutubeService.new.playlist_video_params(tutorial)
      # YoutubeService.new.create_videos(tutorial)
      redirect_to admin_dashboard_path
      flash[:notice] = "Successfully created tutorial. #{view_context.link_to("View it here.", tutorial_path(tutorial.id))}"
    end
  end
  
  def new
    @tutorial = Tutorial.new 
  end

  def update
    tutorial = Tutorial.find(params[:id])
    flash[:success] = "#{tutorial.title} tagged!" if tutorial.update(tutorial_params)
    redirect_to edit_admin_tutorial_path(tutorial)
  end

  def destroy
    tutorial = Tutorial.find(params[:id])
    flash[:success] = "#{tutorial.title} tagged!" if tutorial.destroy
    redirect_to admin_dashboard_path
  end

  private

  def create_videos(tutorial)
    YoutubeService.new.playlist_video_params(tutorial).map do |video_param|
      tutorial.videos.create(video_param)
    end
  end

  def tutorial_params
    params.require(:tutorial).permit(:tag_list)
  end

  def new_tutorial_params
    params.require(:tutorial).permit(:title, :description, :thumbnail, :playlist_id)
  end
end

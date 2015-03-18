class UsersController < ControllerBase

  def index
    render_content('<h1>users</h1>index page!', 'text/html')
    # render :index
  end

  def show
    @id = params[:id]
    render :show
  end

end

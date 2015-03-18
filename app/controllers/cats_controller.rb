class CatsController < ControllerBase

  def index
    # debugger
    flash[:errors] = ["Yiling am best"]
    # flash.now[:errors] = ["Yiling so silly"]
    render :index
  end

end

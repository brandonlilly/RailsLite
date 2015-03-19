class CatsController < ControllerBase

  def index
    # debugger
    flash[:errors] = ["Yiling not am best", "Yiling so silly"]
    # flash.now[:errors] = ["Yiling so silly"]
    @cats = Cat.all
    # debugger
    render :index
  end

end

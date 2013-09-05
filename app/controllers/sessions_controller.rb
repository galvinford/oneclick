class SessionsController < Devise::SessionsController
  def show
    respond_to do |format|
      format.html
    end
  end

  def clear
    respond_to do |format|
      format.html
    end
  end

end

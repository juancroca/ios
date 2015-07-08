class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery
  helper_method :supervisor_signed_in?, :current_supervisor, :student_signed_in?, :current_student

  def authenticate_supervisor!
    permission_denied unless supervisor_signed_in?
  end

  def supervisor_signed_in?
    user_signed_in? && user_session["supervisor"]
  end

  def current_supervisor
    current_user if supervisor_signed_in?
  end

  def authenticate_student!
    permission_denied unless student_signed_in?
  end

  def student_signed_in?
    user_signed_in? && !user_session["supervisor"]
  end

  def current_student
    current_user if student_signed_in?
  end

  def authenticate_user!
    permission_denied unless user_signed_in?
  end

  private
  def permission_denied
    render :file => "public/401.html", :status => :unauthorized
  end

end

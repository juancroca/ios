class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery

  def authenticate_supervisor!
    redirect_to root_path unless supervisor_signed_in?
  end

  def supervisor_signed_in?
    user_signed_in? && user_session["supervisor"]
  end

  def current_supervisor
    current_user if supervisor_signed_in?
  end

  def authenticate_student!
    redirect_to root_path unless student_signed_in?
  end

  def student_signed_in?
    user_signed_in? && !user_session["supervisor"]
  end

  def current_student
    current_user if student_signed_in?
  end

end

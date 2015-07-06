class Users::RegistrationsController < Devise::RegistrationsController
  def create
    @user = User.find_or_create_by(email: params[:lis_person_contact_email_primary]) do |u|
      u.name = params[:lis_person_name_full]
      u.isis_id = params[:user_id]
    end
    sign_in(:user, @user) unless user_signed_in?
    user_session["supervisor"] = params[:roles].include? 'Instructor'
    if supervisor_signed_in?
      @course = Course.find_or_create_by(isis_id: params[:context_id]) do |c|
        c.name = params[:context_title]
      end
      session[:context_id] = params[:context_id]
      @course.supervisors << current_supervisor unless @course.supervisors.include? @user
      redirect_to edit_course_path(@course)
    end
    if student_signed_in?
      @course = Course.find_by(isis_id: params[:context_id])
      raise ActiveRecord::RecordNotFound unless @course
      session[:context_id] = params[:context_id]
      @registration = current_student.registrations.find_by(course_id: @course.id)
      if @registration
        return redirect_to course_path(@course) if @course.closed?
        redirect_to edit_course_registration_path(@course, @registration)
      else
        redirect_to new_course_registration_path(@course)
      end
    end
  end

  def require_no_authentication
    session[:init_ios] = true
    if session[:context_id] != params[:context_id]
      sign_out current_user if current_user
      super
    end
  end
end

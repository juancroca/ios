class Users::RegistrationsController < Devise::RegistrationsController
  def create
    user = User.find_or_create_by(email: params[:lis_person_contact_email_primary]) do |u|
      u.name = params[:lis_person_name_full]
      u.isis_id = params[:lis_person_name_full]
    end
    sign_in(:user, user) unless user_signed_in?
    user_session[:supervisor] = params[:roles].include? 'Instructor'
    if supervisor_signed_in?
      course = Course.find_or_create_by(isis_id: params[:context_id]) do |c|
        c.name = params[:context_title]
      end
      session[:context_id] = params[:context_id]
      course.supervisors << user unless course.supervisors.include? user
      redirect_to edit_course_path(course)
    end
    if student_signed_in?
      course.students << user unless course.students.include? user
      redirect_to course_path(course)
    end
  end

  def require_no_authentication
    session[:init_ios] = true
    super if session[:context_id] == params[:context_id]
  end
end

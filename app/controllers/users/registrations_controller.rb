class Users::RegistrationsController < Devise::RegistrationsController
  def create

    user = User.find_or_create_by(email: params[:lis_person_contact_email_primary]) do |u|
      u.name = params[:lis_person_name_full]
      u.isis_id = params[:lis_person_name_full]
    end
    sign_in(:user, user)
    course = Course.find_or_create_by(isis_id: params[:context_id]) do |c|
      c.name = params[:context_title]
    end

    if (params[:roles] === 'Instructor')
      course.supervisors << user
      redirect_to edit_course_path(course)
    else
      coruse.students << user
      redirect_to course_path(course)
    end
  end
end

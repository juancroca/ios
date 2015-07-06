module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @course = create(:course)
      @request.env["rack.session"]["context_id"] = @course.isis_id
      user = FactoryGirl.create(:user)
      sign_in user
    end
  end

  def login_student
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @course = create(:course)
      user = create(:student)
      @course.students << user
      sign_in :user, user
      @request.env["rack.session"]["context_id"] = @course.isis_id
      @request.env["rack.session"]["warden.user.user.session"] = {"supervisor" => false}
    end
  end

  def login_supervisor
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @course = create(:course)
      user = create(:supervisor)
      @course.supervisors << user
      sign_in :user, user
      @request.env["rack.session"]["context_id"] = @course.isis_id
      @request.env["rack.session"]["warden.user.user.session"] = {"supervisor" => true}
    end
  end
end

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  include Devise::TestHelpers
  let(:current_user){
    @controller.current_user
  }
  context "with valid params" do

    let(:valid_attributes) {{
      lis_person_contact_email_primary: "test@example.com",
      lis_person_name_full: "Example",
      user_id: 1234,
      context_id: 123,
      context_title: "test course"
    }}

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    context "with role instructor" do
      before :each do
        valid_attributes[:roles] = "Instructor"
      end

      context "with session" do
        login_supervisor
        it "should redirect to edit course" do
          post :create, valid_attributes
          expect(response).to redirect_to(course_path(assigns(:course)))
        end
      end

      context "without session" do
        it "creates a new Supervisor the first time" do
          expect {
            post :create, valid_attributes
          }.to change(User, :count).by(1)
        end

        it "creates a new Supervisor course the first time" do
          expect {
            post :create, valid_attributes
          }.to change(SupervisorCourse, :count).by(1)
        end

        it "does not creates a new Supervisor course any other time" do
          post :create, valid_attributes
          expect {
            post :create, valid_attributes
          }.to change(SupervisorCourse, :count).by(0)
        end

        it "load a Supervisor any other time" do
          post :create, valid_attributes
          expect {
            post :create, valid_attributes
          }.to change(User, :count).by(0)
        end

        it "creates a new Course the first time" do
          expect {
            post :create, valid_attributes
          }.to change(Course, :count).by(1)
        end

        it "load a Course any other time" do
          post :create, valid_attributes
          expect {
            post :create, valid_attributes
          }.to change(Course, :count).by(0)
        end

        it "assigns a newly created supervisor as @user" do
          post :create, valid_attributes
          expect(assigns(:user)).to be_a(User)
          expect(assigns(:user)).to be_persisted
        end

        it "assigns a newly created course as @course" do
          post :create, valid_attributes
          expect(assigns(:course)).to be_a(Course)
          expect(assigns(:course)).to be_persisted
        end

        it "newly created assigns with correct isis ids" do
          post :create, valid_attributes
          expect(assigns(:course).isis_id).to eq valid_attributes[:context_id]
          expect(assigns(:user).isis_id).to eq valid_attributes[:user_id]
        end

        it "adds supervisor role to user session" do
          expect(@request.env["rack.session"]["warden.user.user.session"]).to eq nil
          post :create, valid_attributes
          expect(@request.env["rack.session"]["warden.user.user.session"]["supervisor"]).to eq true
        end

        it "redirects to the created course" do
          post :create, valid_attributes
          expect(response).to redirect_to(course_path(assigns(:course)))
        end
      end
    end

    context "with role student" do
      before :each do
        valid_attributes[:roles] = "Student"
      end

      context "with session with course" do
        login_student
        it "should redirect to new registration" do
          course_id = @request.env["rack.session"]["context_id"]
          valid_attributes[:context_id] = course_id
          course = Course.find_by(isis_id: course_id)
          post :create, valid_attributes
          expect(response).to redirect_to(new_course_registration_path(course))
        end

        it "should redirect to edit registration when registration" do
          course_id = @request.env["rack.session"]["context_id"]
          valid_attributes[:context_id] = course_id
          course = Course.find_by(isis_id: course_id)
          create(:registration, {user_id: current_user.id, course_id: course.id})
          post :create, valid_attributes
          expect(response).to redirect_to(new_course_registration_path(course))
        end
      end

      context "without session" do
        context "without course" do
          it "throws a record not found error" do
            expect {post :create, valid_attributes}.to raise_exception(ActiveRecord::RecordNotFound)
          end
        end
        context "with course" do
          before do
            @course = create(:course, isis_id: valid_attributes[:context_id])
          end

          it "creates a new Student the first time" do
            expect {
              post :create, valid_attributes
            }.to change(User, :count).by(1)
          end

          it "load a Student any other time" do
            post :create, valid_attributes
            expect {
              post :create, valid_attributes
            }.to change(User, :count).by(0)
          end

          it "does not create a new Course" do
            expect {
              post :create, valid_attributes
            }.to change(Course, :count).by(0)
          end

          it "assigns a newly created student as @user" do
            post :create, valid_attributes
            expect(assigns(:user)).to be_a(User)
            expect(assigns(:user)).to be_persisted
          end

          it "assigns a course as @course" do
            post :create, valid_attributes
            expect(assigns(:course)).to be_a(Course)
            expect(assigns(:course)).to be_persisted
          end

          it "assigns with correct isis ids" do
            post :create, valid_attributes
            expect(assigns(:course).isis_id).to eq valid_attributes[:context_id]
            expect(assigns(:user).isis_id).to eq valid_attributes[:user_id]
          end
          context "with registration" do
            before do
              @user = create(:student, email: valid_attributes[:lis_person_contact_email_primary])
              @registration = create(:registration, {user_id: @user.id, course_id: @course.id})
            end

            it "assings registration if exits" do
              post :create, valid_attributes
              expect(assigns(:registration)).to be_a(Registration)
              expect(assigns(:registration)).to be_persisted
            end

            it "redirects to edit registration if exists" do
              post :create, valid_attributes
              expect(assigns(:registration)).to eq(@registration)
              expect(response).to redirect_to(edit_course_registration_path(@course, @registration))
            end
          end

          it "adds student role to user session" do
            expect(@request.env["rack.session"]["warden.user.user.session"]).to eq nil
            post :create, valid_attributes
            expect(@request.env["rack.session"]["warden.user.user.session"]["supervisor"]).to eq false
          end

          it "redirects to new registration if non exists" do
            post :create, valid_attributes
            expect(assigns(:registration)).to eq(nil)
            expect(response).to redirect_to(new_course_registration_path(@course))
          end

        end
      end
    end
  end
end

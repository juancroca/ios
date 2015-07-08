require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  include Devise::TestHelpers
  let(:current_user){
    @controller.current_user
  }

  let(:current_student){
    @controller.current_student
  }

  let(:current_supervisor){
    @controller.current_supervisor
  }

  let(:supervisor_course){
    current_user.supervising.create(attributes_for :course)
  }

  let(:student_course){
    current_user.attending.create(attributes_for(:course, :visible))
  }

  let(:course){
    create(:course, :visible)
  }

  let(:valid_attributes) {
    attributes_for(:registration)
  }

  let(:invalid_attributes) {
  }

  let(:registration){
    if(current_student)
      current_student.registrations.create(valid_attributes.merge({course_id: student_course.id}))
    elsif(current_supervisor)
      create(:user).registrations.create(valid_attributes.merge({course_id: supervisor_course.id}))
    else
      create(:registration)
    end
  }

  describe "GET #index" do
    context "with student session" do
      login_student
      it "renders 401" do
        get :index, {course_id: student_course}
        expect(response).to have_http_status(401)
      end
    end

    context "without session" do
      it "renders 401" do
        get :index, {course_id: course}
        expect(response).to have_http_status(401)
      end
    end

    context "with supervisor session" do
      login_supervisor
      it "assigns the requested registrations as @registrations" do
        registration
        get :index, {course_id: supervisor_course}
        expect(assigns(:registrations)).to eq([registration])
      end
    end
  end

  describe "GET #show" do
    context "with supervisor session" do
      login_supervisor
      it "renders 401" do
        get :show, {course_id: supervisor_course, id: registration}
        expect(response).to have_http_status(401)
      end
    end

    context "without session" do
      it "renders 401" do
        get :show, {course_id: course, id: create(:registration)}
        expect(response).to have_http_status(401)
      end
    end

    context "with student session" do
      login_student
      it "assigns the requested registration as @registration" do
        get :show, {course_id: student_course, id: registration}
        expect(assigns(:registration)).to eq(registration)
      end
    end
  end

  describe "GET #new" do
    context "with supervisor session" do
      login_supervisor
      it "renders 401" do
        get :new, {course_id: supervisor_course}
        expect(response).to have_http_status(401)
      end
    end

    context "without session" do
      it "renders 401" do
        get :new, {course_id: course}
        expect(response).to have_http_status(401)
      end
    end

    context "with student session" do
      login_student
      it "assigns a new registration as @registration" do
        get :new, {course_id: student_course}
        expect(assigns(:registration)).to be_a_new(Registration)
      end
    end
  end

  describe "GET #edit" do
    context "with supervisor session" do
      login_supervisor
      it "renders 401" do
        get :edit, {course_id: supervisor_course, id: registration}
        expect(response).to have_http_status(401)
      end
    end

    context "without session" do
      it "renders 401" do
        get :edit, {course_id: course, id: create(:registration)}
        expect(response).to have_http_status(401)
      end
    end

    context "with student session" do
      login_student
      it "assigns the requested registration as @registration" do
        get :edit, {course_id: student_course, id: registration}
        expect(assigns(:registration)).to eq(registration)
      end
    end
  end

  describe "POST #create" do
    context "with supervisor session" do
      login_supervisor
      it "renders 401" do
        post :create, {course_id: supervisor_course, registration: valid_attributes}
        expect(response).to have_http_status(401)
      end
    end

    context "without session" do
      it "renders 401" do
        post :create, {course_id: course, registration: valid_attributes}
        expect(response).to have_http_status(401)
      end
    end

    context "with student session" do
      login_student
      context "with valid params" do
        it "creates a new Registration" do
          expect {
            post :create, {course_id: course, registration: valid_attributes}
          }.to change(Registration, :count).by(1)
        end

        it "assigns a newly created registration as @registration" do
          post :create, {course_id: course, :registration => valid_attributes}
          expect(assigns(:registration)).to be_a(Registration)
          expect(assigns(:registration)).to be_persisted
        end

        it "redirects to the created registration" do
          post :create, {course_id: course, :registration => valid_attributes}
          expect(response).to redirect_to([course, Registration.last])
        end
      end

      # context "with invalid params" do
      #   it "assigns a newly created but unsaved registration as @registration" do
      #     post :create, {course_id: course, :registration => invalid_attributes}
      #     expect(assigns(:registration)).to be_a_new(Registration)
      #   end
      #
      #   it "re-renders the 'new' template" do
      #     post :create, {course_id: course, :registration => invalid_attributes}
      #     expect(response).to render_template("new")
      #   end
      # end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        valid_attributes.merge({friend_ids: ["1","2","3"]})
      }

      context "with supervisor session" do
        login_supervisor
        it "renders 401" do
          put :update, {course_id: course, id: registration, registration: valid_attributes}
          expect(response).to have_http_status(401)
        end
      end

      context "without session" do
        it "renders 401" do
          put :update, {course_id: course, id: registration, registration: {}}
          expect(response).to have_http_status(401)
        end
      end

      context "with student session" do
        login_student
        context "with valid params" do
          it "updates the requested registration" do
            put :update, {course_id: student_course, id: registration, registration: new_attributes}
            registration.reload
            expect(registration.friend_ids).to eq(["1","2","3"])
          end

          it "assigns the requested registration as @registration" do
            put :update, {course_id: student_course, id: registration, registration: valid_attributes}
            expect(assigns(:registration)).to eq(registration)
          end

          it "redirects to the registration" do
            put :update, {course_id: student_course, id: registration, registration: valid_attributes}
            expect(response).to redirect_to([student_course, registration])
          end
        end
        # context "with invalid params" do
        #   it "assigns the registration as @registration" do
        #     put :update, {course_id: student_course, id: registration, registration: invalid_attributes}
        #     expect(assigns(:registration)).to eq(registration)
        #   end
        #
        #   it "re-renders the 'edit' template" do
        #     put :update, {course_id: student_course, id: registration, registration: invalid_attributes}
        #     expect(response).to render_template("edit")
        #   end
        # end
      end
    end
  end

end

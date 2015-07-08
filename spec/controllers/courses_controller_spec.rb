require 'rails_helper'


RSpec.describe CoursesController, type: :controller do
  include Devise::TestHelpers
  let(:current_user){
    @controller.current_user
  }

  let(:valid_attributes) {
    attributes_for(:course)
  }

  let(:invalid_attributes) {
    {year: "abc"}
  }

  describe "GET #show" do
    context "with student session" do
      login_student
      it "assigns the requested course as @course" do
        get :show, {:id => @course.to_param}
        expect(assigns(:course)).to eq(@course)
      end

      it "assigns the student's course group as @group" do
        job = create(:job, course_id: @course.id, result_count: 0)
        create(:group, course_id: @course.id)
        job.results.create(attributes_for(:result, user_id: current_user.id))

        get :show, {:id => @course.to_param}
        expect(assigns(:group)).to eq(@course.jobs.last.groups.first)
      end
    end

    context "without session" do
      it "renders 401" do
        get :edit, {:id => create(:course).to_param}
        expect(response).to have_http_status(401)
      end
    end

    context "with supervisor session" do
      login_supervisor
      it "assigns the requested course as @course" do
        get :show, {:id => @course.to_param}
        expect(assigns(:course)).to eq(@course)
      end

      it "assigns the supervisor's course jobs as @jobs" do
        jobs = create_list(:job, 5, course_id: @course.id, completed: true, result_count: 5)

        get :show, {:id => @course.to_param}
        expect(assigns(:jobs)).to eq(@course.jobs.to_a)
      end
    end
  end

  describe "GET #edit" do
    context "with supervisor session" do
      login_supervisor
      it "assigns the requested course as @course" do
        get :edit, {:id => @course.to_param}
        expect(assigns(:course)).to eq(@course)
      end
    end

    context "with student session" do
      login_student
      it "renders 401" do
        get :edit, {:id => @course.to_param}
        expect(response).to have_http_status(401)
      end
    end

    context "without session" do
      it "renders 401" do
        get :edit, {:id => create(:course).to_param}
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "PUT #update" do
    context "with student session" do
      login_student
      it "renders 401" do
        put :update, {:id => @course.to_param, :course => valid_attributes}
        expect(response).to have_http_status(401)
      end
    end

    context "without session" do
      it "renders 401" do
        put :update, {:id => create(:course).to_param, :course => valid_attributes}
        expect(response).to have_http_status(401)
      end
    end
    context "with supervisor session" do
      login_supervisor
      context "with valid params" do
        let(:new_attributes) {
          {description: 'new_description'}
        }

        it "updates the requested course" do
          expect(@course.description).to be_nil
          put :update, {:id => @course.to_param, :course => new_attributes}
          @course.reload
          expect(@course.description).to eq "new_description"
        end

        it "assigns the requested course as @course" do
          put :update, {:id => @course.to_param, :course => valid_attributes}
          expect(assigns(:course)).to eq(@course)
        end

        it "redirects to the course" do
          put :update, {:id => @course.to_param, :course => valid_attributes}
          expect(response).to redirect_to(@course)
        end
      end

      context "with invalid params" do
        it "assigns the course as @course" do
          put :update, {:id => @course.to_param, :course => invalid_attributes}
          expect(assigns(:course)).to eq(@course)
        end

        it "re-renders the 'edit' template" do
          put :update, {:id => @course.to_param, :course => invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end
  end

end

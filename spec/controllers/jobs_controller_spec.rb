require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  include Devise::TestHelpers

  let(:course){
    create(:course, :with_associations, :visible, {registration_count: 4, groups_count: 2}).reload
  }

  let(:job){
    create(:job, course: course, result_count: 0)
  }
  let(:groupMap){
    {course.groups.first.id => course.students.ids.first(2), course.groups.last.id => course.students.ids.last(2)}
  }

  describe "GET #success" do
    it "assigns the requested course as @course" do
      post :success, {course_id: course.id, :id => job.id, groupMap: groupMap}
      expect(assigns(:course)).to eq(course)
    end

    it "assigns the requested job as @job" do
      post :success, {course_id: course.id, :id => job.id, groupMap: groupMap}
      expect(assigns(:job)).to eq(job)
    end

    it "creates the results for the jobs" do
      expect {
        post :success, {course_id: course.id, :id => job.id, groupMap: groupMap}
      }.to change(Result, :count).by(4)
    end
  end
end

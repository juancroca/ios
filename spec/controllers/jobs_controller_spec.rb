require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  include Devise::TestHelpers

  let(:course){
    create(:course, :with_associations, :visible, {registration_count: 4, groups_count: 2}).reload
  }

  let(:job){
    create(:job, course: course, result_count: 0)
  }

  let(:group_map){
    {course.groups.first.id => course.students.ids.first(2), course.groups.last.id => course.students.ids.last(2)}
  }

  let(:invalid_group_map){
    {course.groups.first.id => course.students.ids.first(2), course.groups.last.id => course.students.ids.first(2)}
  }

  describe "GET #success" do
    it "assigns the requested course as @course" do
      post :success, {course_id: course.id, :id => job.id, groupMap: group_map}
      expect(assigns(:course)).to eq(course)
    end

    it "assigns the requested job as @job" do
      post :success, {course_id: course.id, :id => job.id, groupMap: group_map}
      expect(assigns(:job)).to eq(job)
    end

    it "creates the results for the jobs" do
      expect {
        post :success, {course_id: course.id, :id => job.id, groupMap: group_map}
      }.to change(Result, :count).by(4)
    end

    it "fails to create results if malformed json" do
      expect {
        post :success, {course_id: course.id, :id => job.id, groupMap: invalid_group_map}
      }.to change(Result, :count).by(0)
    end
  end
end

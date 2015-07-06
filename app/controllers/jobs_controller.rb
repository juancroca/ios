class JobsController < ApplicationController

  before_filter :load_course
  before_filter :load_job

  def success
    params[:groupMap].each do |group_id, student_ids|
      group = Group.find(group_id)
      student_ids.each do |student_id|
        @job.results.create(user_id: student_id, group_id: group_id)
      end
    end
    @job.update(completed: true)
    head 200
  end

  def failure
    puts params
  end

  private
  def load_course
    @course = Course.visible.find(params[:course_id])
  end

  def load_job
    @job = Job.find(params[:id])
  end

end

class JobsController < ApplicationController
  before_filter :authenticate_supervisor!, only: [:edit]
  before_filter :load_course
  before_filter :load_job, except: [:create]

  def edit
    @job = @job.deep_clone include: :results
  end

  def create
    @job = @course.jobs.build(job_params)
    begin
      Job.transaction do
        if @job.save
          @job.update_groups
          redirect_to @course
        else
          render :edit
        end
      end
    rescue ActiveRecord::RecordNotUnique
      flash[:error] = "Users can be in two groups at the same time"
      render :edit
    end
  end

  def success
    begin
      @job.results.transaction do
        params[:groupMap].each do |group_id, student_ids|
          group = Group.find(group_id)
          student_ids.each do |student_id|
            @job.results.create!(user_id: student_id, group_id: group_id)
          end
        end
        head 200
      end
    rescue ActiveRecord::RecordInvalid
      head 500
    end
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

  def job_params
    params.require(:job).permit(results_attributes: [:user_id, :group_id])
  end

end

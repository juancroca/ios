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
          @job.reload
          @job.update_groups if @job.empty_result
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

  def update
    if @job.update(job_params)
      redirect_to @course
    else
      redirect_to @course, error: "Job not updated"
    end
  end

  def success
    begin
      @job.results.transaction do
        @job.results.destroy_all
        params[:groupMap].each do |group_id, student_ids|
          if group_id.to_i == -1
            group = @course.waiting_list
          else
            group = @course.groups.find(group_id)
          end
          student_ids.each do |student_id|
            @job.results.create!(user_id: student_id, group_id: group.id)
          end
        end
        @job.update(completed: true, selected: true)
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
    @course = Course.find(params[:course_id])
  end

  def load_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:selected, results_attributes: [:user_id, :group_id])
  end

end

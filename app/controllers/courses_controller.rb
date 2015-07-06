class CoursesController < ApplicationController
  before_filter :authenticate_supervisor!, only: [:edit, :update]
  before_filter :authenticate_user!, only: [:show]
  before_filter :load_supervisor_course, only: [:edit, :update, :start]
  before_filter :load_associations, only: [:edit]

  # Don't do CSRF checks for whatever is posted to the success and failure endpoints
  skip_before_filter :verify_authenticity_token, :except => [:success, :failure]

  def show
    if supervisor_signed_in?
      load_supervisor_course
      @jobs = @course.jobs.completed
    end

    if student_signed_in?
      load_student_course
      @group = @course.jobs.last.groups.joins(:students).where("results_groups_join.user_id" => current_student.id).first unless @course.jobs.empty?
    end

  end

  def edit
    # If this course is closed, then just show the results of the assignment
    #redirect_to course_path(@course) if @course.closed?
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Class was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def start
    job = @course.create_groups
    if job.started?
      redirect_to course_path(@course), flash: {error: "Starting assignment of students to groups. Please check back in a minute to see the results!"}
    else
      # ********if job.errors
      redirect_to course_path(@course), flash: {error: "Could not start assignment of students to groups. Please try again later."}
    end

  end

  private
  def load_supervisor_course
    @course = current_supervisor.supervising.find(params[:id])
    if @course.nil?
      return redirect_to root_path
    end
  end

  def load_student_course
    @course = current_student.attending.find_by_id(params[:id])
    if @course.nil?
      redirect_to root_path
    end
  end

  def load_associations
    @course.groups.build if @course.groups.empty?
    @course.study_fields = [""] if @course.study_fields.empty?
  end

  def course_params
    params.require(:course).permit(:name, :semester, :description, :year, :enrollment_deadline, study_fields: [], skill_ids: [],
                                    preferences: [:iterations, :groups, :prority, :friends, :diverse, :compulsory],
                                    groups_attributes: [:id, :name, :minsize, :maxsize, :description, :mandatory, :_destroy, skill_ids: []])
  end


end

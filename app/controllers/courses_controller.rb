class CoursesController < ApplicationController
  before_filter :authenticate_supervisor!, only: [:edit, :update]
  before_filter :load_supervisor_course, only: [:edit, :update, :show]
  before_filter :load_group, only: [:edit]

  def index
    @courses = current_user.supervising
  end

  def edit
  end

  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
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

  private
  def load_supervisor_course
    @course = current_supervisor.supervising.find(params[:id])
    if @course.nil?
      return redirect_to root_path
    end
  end

  def load_group
    @course.groups.build if @course.groups.empty?
  end

  def course_params
    params.require(:course).permit(:name, :semester, :description, :year, :enrollment_deadline, skill_ids: [],
                                    preferences: [:iterations, :groups, :prority, :friends, :diverse, :compulsory],
                                    groups_attributes: [:id, :name, :minsize, :maxsize, :description, :_destroy, skill_ids: []])
  end
end

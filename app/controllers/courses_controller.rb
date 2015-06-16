class CoursesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_supervisor_course, only: [:edit, :update, :show]
  before_filter :load_group, only: [:edit]

  def index
    @courses = current_user.supervising
  end

  def edit
  end

  def update
    if @course.update(course_params)
      redirect_to @course
    else
      load_group
      render :edit
    end
  end

  private
  def load_supervisor_course
    @course = current_user.supervising.find(params[:id])
    if @course.nil?
      return redirect_to root_path
    end
  end

  def load_group
    @course.groups.build if @course.groups.empty?
  end

  def course_params
    params.require(:course).permit(:name, :semester, :description, :year, :enrollment_deadline,
                                    groups_attributes: [:id, :name, :minsize, :maxsize, :description, :_destroy])
  end
end

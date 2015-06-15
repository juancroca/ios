class CoursesController < ApplicationController
  before_filter :load_supervisor_course, only: [:edit, :update, :show]
  def edit
  end

  def update
    if @course.update_attributes(course_params)
      redirect_to @course
    else
      render :edit
    end
  end

  private
  def load_supervisor_course
    @course = current_user.supervising.find(params[:id])
    if @course.nil?
      return redirect_to root_path
    else
      if @course.groups.empty?
        @course.groups.build
      end
    end
  end

  def course_params
    params.require(:course).permit(:name, :semester, :description, :year, :enrollment_deadline,
                                    groups_attributes: [:id, :name])
  end
end

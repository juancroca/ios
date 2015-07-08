class RegistrationsController < ApplicationController
  before_filter :authenticate_student!, only: [:edit, :update, :new, :create, :show]
  before_filter :authenticate_supervisor!, only: [:index]
  before_action :set_registration, only: [:show, :edit, :update]
  before_action :set_course, except:[:create, :edit]

  # GET /registrations
  # GET /registrations.json
  def index
    @registrations = @course.registrations.all
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
    redirect_to edit_course_registration_path(@course, @registration)
  end

  # GET /registrations/new
  def new
    @registration = current_student.registrations.build(course: @course)
    @registration.build_course_skill_scores
  end

  # GET /registrations/1/edit
  def edit
    @course = Course.visible.find(params[:course_id])
    render :result if @course.closed
  end

  # POST /registrations
  # POST /registrations.json
  def create
    @course = Course.visible.find(params[:course_id])
    @registration = current_student.registrations.build(registration_params)
    @registration.course = @course
    respond_to do |format|
      if @registration.save
        format.html { redirect_to [@course, @registration], notice: 'Registration was successfully created.' }
        format.json { render :show, status: :created, location: [@course, @registration] }
      else
        format.html { render :new }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
  def update
    respond_to do |format|
      if @registration.update(registration_params)
        format.html { redirect_to [@course, @registration], notice: 'Registration was successfully updated.' }
        format.json { render :show, status: :ok, location: [@course, @registration] }
      else
        format.html { render :edit }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @registration = current_student.registrations.find(params[:id])
    end

    def set_course
      if student_signed_in?
        @course = current_student.attending.visible.find(params[:course_id])
      end
      if supervisor_signed_in?
        @course = current_supervisor.supervising.find(params[:course_id])
      end
      return redirect_to closed_course_path(@course) if @course.try(:closed?)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_params
      params.require(:registration).permit(:study_field, friend_ids: [], groups: params[:registration].try(:[], :gorups).try(:keys),
                                      skill_scores_attributes: [:id, :score, :skill_id])
    end
end

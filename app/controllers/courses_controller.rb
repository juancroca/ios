class CoursesController < ApplicationController
  before_filter :authenticate_supervisor!, only: [:edit, :update]
  before_filter :load_supervisor_course, only: [:edit, :update, :show, :start]
  before_filter :load_group, only: [:edit]

  # Don't do CSRF checks for whatever is posted to the success and failure endpoints
  skip_before_filter :verify_authenticity_token, :except => [:success, :failure]

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

  def start
    hash = JSON.parse @course.to_builder.target!

    hash['endpoints'] = {
      success: "http://localhost:3000#{success_course_path(@course)}", 
      failure: "http://localhost:3000#{failure_course_path(@course)}"
    }
    hash['settings']['iterations'] = 50
    response = connection.post '/run', hash.to_json

    pp hash.to_json

    if response.status == 200
      @course.closed = true
      @course.save()

      redirect_to @course, flash: {error: "Starting assignment of students to groups. Please check back in a minute to see the results!"}
    else
      redirect_to @course, flash: {error: "Could not start assignment of students to groups. Please try again later."}
    end
  end

  def success
    print(params)

    head 200
  end

  def failure
    print(params)

    head 200
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

  def connection
    conn = Faraday.new(url: "http://#{ENV['SCALA_PORT_8080_TCP_ADDR']}:#{ENV['SCALA_PORT_8080_TCP_PORT']}") do |faraday|
      faraday.headers['Content-Type'] = 'application/json'
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      faraday.request  :json
    end
  end
end

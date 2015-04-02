class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @chapters = @course.chapters
    if (current_user)
      @user_course = current_user.courses.where(id: @course.id).first
    end
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_to_courses
    @course = Course.find(params[:course_id])
    respond_to do |format|
      if (current_user && !current_user.courses.where(id: @course.id).first)
        current_user.courses << @course
        format.json { render json: { success: true } }
      else
        format.json { render json: { success: false } }
      end
    end
  end

  def remove_from_courses
    @course = Course.find(params[:course_id])
    respond_to do |format|
      if (current_user && @user_course = current_user.courses.where(id: @course.id).first)
        current_user.courses.delete(@course.id)
        format.json { render json: { success: true } }
      else
        format.json { render json: { success: false } }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name, :desc, :logo_file_name, :logo_file_size, :logo_content_type, :logo_updated_at)
    end
end

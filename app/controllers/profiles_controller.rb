class ProfilesController < ApplicationController

  def show
    @user = current_user
    @courses = @user.courses
    @other_courses = Course.where('id NOT IN (?)', @courses.map { |c| c.id })
  end

  def edit
    @user = current_user
  end
end

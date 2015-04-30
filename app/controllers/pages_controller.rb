class PagesController < ApplicationController

  def home
    @courses = Course.limit(4)
  end

  def contact_us
  end

  def about_us
  end
end

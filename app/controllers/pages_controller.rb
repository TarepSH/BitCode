class PagesController < ApplicationController

  def home
    @courses = Course.limit(4)
  end

  def contentus
  end

  def aboutus
  end
end

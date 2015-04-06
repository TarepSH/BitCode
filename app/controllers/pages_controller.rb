class PagesController < ApplicationController

  def home
    @courses = Course.limit(4)
  end
end

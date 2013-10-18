class PagesController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :check_attr

  def home
  end
end

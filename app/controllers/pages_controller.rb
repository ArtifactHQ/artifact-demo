class PagesController < ApplicationController
  def home
  end

  def docs
    # Only allow in development
    raise ActionController::RoutingError, "Not Found" unless Rails.env.development?
  end
end

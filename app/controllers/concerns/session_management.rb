# frozen_string_literal: true

module SessionManagement
  extend ActiveSupport::Concern

  protected

  def current_user
    @current_user ||= session[:user_id]&.then { |user_id| User.find_by(id: user_id) }
  end
end

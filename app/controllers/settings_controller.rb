class SettingsController < ApplicationController
  before_action :logged_in_user
  before_action :get_current_user

  def new
  end

  def change_name
    render 'change_name'
  end

  def change_email
    render 'change_email'
  end

  def change_password
    render 'change_password'
  end

  private

    def get_current_user
      @user = current_user
    end
end

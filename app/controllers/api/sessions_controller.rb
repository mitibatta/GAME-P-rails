class Api::SessionsController < ApplicationController  
  before_action :set_user, only: :create
  def create
    @user.password = @user.password_digest
    if @user.email.blank? || @user.password.blank?
      response_bad_request
    elsif @user.authenticate(password_params[:password_digest])
      log_in @user
      response_success_login
    else
      response_unauthorized
    end
  end
  


  def destroy
    log_out
    response_success("ログアウト")
  end

  private
  def set_user
    @user = User.find_by(email_params)
    response_not_found(:user) if @user.blank?
  end
  def email_params
    params.require(:session).permit(:email)
  end
  def password_params
    params.require(:session).permit(:password_digest)
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
  end

end

class PasswordResetsController < ApplicationController
  before_action :catch_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = I18n.t('errors.messages.flash_send_email')
      redirect_to root_url
    else
      flash.now[:danger] = I18n.t('errors.messages.flash_not_send_email')
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = I18n.t('errors.messages.flash_success_password_reset')
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def catch_user
    @user = User.find_by(email: params[:email])
  end

  # 正しいユーザーを確認
  def valid_user
    unless @user && @user.activated? &&
           @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = I18n.t('errors.messages.flash_danger__password_reset_expired')
      redirect_to new_password_reset_url
    end
  end
end

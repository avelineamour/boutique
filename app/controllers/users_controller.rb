class UsersController < ApplicationController
  before_action :require_login
   skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    if signup_fields_present
    @user = User.create(user_params)
      if @user.save
      @user.cart = Cart.create(user_id: @user.id)
      redirect_to login_path
      else
        flash[:message] = "* Email is in use"
        redirect_to signup_path
      end
    else
    flash[:message] = "* Please fill out all fields"
    redirect_to signup_path
    end
  end

  def show
    @orders = current_user.orders.order('created_at DESC')
    @user = current_user
    respond_to do |format|
      format.html {render :show}
      format.json {render json: @orders}
    end
  end


end

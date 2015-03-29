class Api::V1::OrdersController < ApplicationController

  before_action :authenticate_with_token!, only: [:index, :show, :create, :update, :destroy]

  def index
    respond_with current_user.orders
  end

  def show
    order = current_user.orders.find_by(id: params[:id])
    if order
      respond_with order
    else
      render json: { errors: "record not found" }, status: 422
    end
  end

end

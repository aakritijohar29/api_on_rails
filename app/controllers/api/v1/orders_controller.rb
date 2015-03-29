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

  def create
    order = current_user.orders.build(order_params)
    if order.save
      render json: order, status: 201, location: [:api, current_user, order]
    else
      render json: { errors: order.errors }, status: 422
    end
  end

  private

    def order_params
      params.require(:order).permit(:product_ids => [])
    end

end
class Api::V1::OrdersController < ApplicationController

  before_action :authenticate_with_token!, only: [:index, :show, :create, :update, :destroy]

  def index
    orders = current_user.orders.page(params[:page]).per(params[:per_page])
    render json: orders, meta: pagination(orders, params[:per_page])
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
    order = current_user.orders.build
    order.build_placements_with_product_ids_and_quantities(params[:order][:product_ids_and_quantities])
    #calculates the total cost of the order based on the products
    order.set_total!
    if order.save
      order.reload # reload the object to display the product objects related
      OrderMailer.send_confirmation(order).deliver_now
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

class Api::V1::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :basic_auth

  def index
    products = Product.all
    render json: products
  end
  def create
    product = Product.new(products_params)
    if product.save
      render json: product , status: 201
    else
      render json: {errors: product.errors } , status: 422
    end
  end
  def update
     product = Product.find(params[:id])
   if product.update(products_params)
     render json: product , status: 200
   else
     render json: { errors: product.errors }, status: 422
   end
  end
  def destroy
    product = Product.find(params[:id])
    product.destroy

    head :no_content
  end
  def basic_auth
  authenticate_or_request_with_http_basic do |username, token|
    user = User.find_by_email(username)
    if user.auth_token == token
      sign_in user
    end
  end
  private
  def products_params
    params.require(:product).permit(:name , :price)
  end

end

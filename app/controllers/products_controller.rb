class ProductsController < ApplicationController
  before_action  :set_product, only: %i[show edit update destroy]
  before_action  :user_is_admin, only: %i[create edit update destroy]
  def index
      # @products = Product.all.paginate(page: params[:page], per_page: 5)
    redirect_to root_url
  end
  def show
    # @product = Product.find(params[:id])
  end
  def new
    @product = Product.new
  end
  
  def edit; end
  
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        product_save_success_response(format,'Product was successfully created.')
      else
        product_save_failure_response(format, :new)
      end
    end
  end
  def update
    respond_to do |format|
      if @product.update(product_params)
        product_save_success_response(format,'Product was successfully updated.')
      else
        product_save_failure_response(format, :edit)
      end
    end
  end
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
      flash[:info] = 'Product was successfully destroyed.'
    end
  end
  
  private
  def set_product 
    @product = Product.find(params[:id])
  end
  def product_save_success_response(format, message)
    format.html { redirect_to @product }
    format.json { render :show, status: :created, location: @product }
    flash[:info] = message
  end
  
  def product_save_failure_response(format, action)
    format.html { render action }
    format.json do
      render json: @product.errors,status: :unprocessable_entity
    end
  end
  def product_params
    params.require(:product).permit(:name, :description, :price, images: [])
  end
end

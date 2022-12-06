class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @current_user = current_user
    end
    fetch_products
  end
    
  def products; end
  def about; end
  def contact; end
  private
  def fetch_products
    @products = if params[:search]
                  Product.search(params[:search]).order('created_at ASC').paginate(page: params[:page], per_page: 5)
                else
                  Product.order('created_at ASC').paginate(page: params[:page], per_page: 5)
                end
  end
end

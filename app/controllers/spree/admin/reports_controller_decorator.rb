# add the sales tax report
Spree::Admin::ReportsController.add_available_report!(:product_sales, 'Product Sales Report')


Spree::Admin::ReportsController.class_eval do 
  before_action :product_sales_params, only: [:product_sales]

  def product_sales
    @search = Spree::Order.complete.ransack(params[:q])

    @orders = @search.result 

    line_items = @orders.map(&:line_items).flatten
    @products = line_items.map(&:product).group_by(&:id)
  end

  private
  def product_sales_params
    params[:q] = {} unless params[:q]

    if params[:q][:completed_at_gt].blank?
      params[:q][:completed_at_gt] = Time.zone.now.beginning_of_month
    else
      params[:q][:completed_at_gt] = Time.zone.parse(params[:q][:completed_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
    end

    if params[:q] && !params[:q][:completed_at_lt].blank?
      params[:q][:completed_at_lt] = Time.zone.parse(params[:q][:completed_at_lt]).end_of_day rescue ""
    else
      params[:q][:completed_at_lt] = Time.now.end_of_month
    end

    params[:q][:s] ||= "completed_at desc"
  end

end
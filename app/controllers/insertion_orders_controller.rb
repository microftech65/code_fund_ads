class InsertionOrdersController < ApplicationController
  def new
    @adate ||= session[:adate] ? Date.parse(session[:adate]) : 2.months.ago.beginning_of_month
    @bdate ||= session[:bdate] ? Date.parse(session[:bdate]) : @adate.end_of_month
    @audience = Audience.find(session[:audience_id] || Audience.blockchain.id)
    @region = Region.find(session[:region_id] || Region.usa_can.id)
    @total_budget = Money.new(session[:total_budget].to_i * 100, "USD")
    @total_budget = @audience.adjusted_total_budget(@adate, @bdate, region: @region, total_budget: @total_budget)
  end
end

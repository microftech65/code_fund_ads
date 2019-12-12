class InsertionOrdersReflex < ApplicationReflex
  include InsertionOrders::Stashable

  # def change_audience
  #   session[:audience_id] = element[:value]
  # end

  # def change_region
  #   session[:region_id] = element[:value]
  # end

  def change_budget
    insertion_order.budget = Money.new(element[:value].to_f * 100)
  end

  def change_dates
    start_date, end_date = element[:value].split(" - ")
    insertion_order.assign_attributes start_date: Date.parse(start_date), end_date: Date.parse(end_date)
  end

  private

  def insertion_order
    @insertion_order ||= stashed_insertion_order
  end
end

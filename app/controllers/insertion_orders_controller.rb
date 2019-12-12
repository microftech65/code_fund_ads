class InsertionOrdersController < ApplicationController
  include InsertionOrders::Stashable
  layout "public"

  def new
    @insertion_order ||= stashed_insertion_order
    @insertion_order.start_date ||= 2.weeks.from_now.beginning_of_week
    @insertion_order.start_date = Date.current if @insertion_order.start_date.past?
    @insertion_order.end_date ||= @insertion_order.start_date.advance(weeks: 4).end_of_week
    @insertion_order.end_date = @insertion_order.start_date.advance(weeks: 4).end_of_week if @insertion_order.end_date.before?(@insertion_order.start_date)
    @insertion_order.build_campaign if @insertion_order.campaigns.blank?
    stash_insertion_order @insertion_order
  end
end

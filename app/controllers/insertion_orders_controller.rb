class InsertionOrdersController < ApplicationController
  include InsertionOrders::Stashable
  layout "public"
  before_action :authenticate_user!

  def new
    @insertion_order ||= stashed_insertion_order
    @insertion_order.assign_attributes organization: Current.organization, user: current_user
    @insertion_order.start_date ||= 2.weeks.from_now.beginning_of_week
    @insertion_order.start_date = Date.current if @insertion_order.start_date.past?
    @insertion_order.end_date ||= @insertion_order.start_date.advance(weeks: 4).end_of_week
    @insertion_order.end_date = @insertion_order.start_date.advance(weeks: 4).end_of_week if @insertion_order.end_date.before?(@insertion_order.start_date)
    @insertion_order.validate
    stash_insertion_order @insertion_order
  end
end

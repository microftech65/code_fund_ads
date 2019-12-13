module InsertionOrders
  module Stashable
    extend ActiveSupport::Concern

    def stash_insertion_order(insertion_order)
      session[:stashed_insertion_order] = insertion_order&.to_stashable_attributes
    end

    def stashed_insertion_order
      InsertionOrder.new stashed_insertion_order_params
    end

    def stashed_insertion_order_params
      session[:stashed_insertion_order] || {}
    end
  end
end

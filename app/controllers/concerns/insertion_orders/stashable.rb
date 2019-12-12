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
      attrs = session[:stashed_insertion_order] || {insertion_order: {id: nil}}
      attrs = ActionController::Parameters.new(attrs)
      attrs.require(:insertion_order).permit(
        :billing_address_1,
        :billing_address_2,
        :billing_city,
        :billing_contact_email,
        :billing_contact_first_name,
        :billing_contact_last_name,
        :billing_contact_phone,
        :billing_country,
        :billing_postal_code,
        :billing_region,
        :budget_cents,
        :budget_currency,
        :company_address_1,
        :company_address_2,
        :company_city,
        :company_country,
        :company_name,
        :company_phone,
        :company_postal_code,
        :company_region,
        :contact_email,
        :contact_first_name,
        :contact_last_name,
        :contact_phone,
        :end_date,
        :start_date,
        campaigns_attributes: [
          :audience_id,
          :country_codes,
          :daily_budget_cents,
          :daily_budget_currency,
          :ecpm_cents,
          :ecpm_currency,
          :end_date,
          :fixed_ecpm,
          :hourly_budget_cents,
          :hourly_budget_currency,
          :keywords,
          :name,
          :region_id,
          :start_date,
          :status,
          :total_budget_cents,
          :total_budget_currency,
          :url,
        ],
      )
    end
  end
end

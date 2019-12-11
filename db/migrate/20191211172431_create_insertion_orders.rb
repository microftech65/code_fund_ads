class CreateInsertionOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :insertion_orders do |t|
      t.bigint :organization_id, null: false
      t.bigint :user_id, null: false

      t.monetize :total_budget, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.timestamps

      # intentional denormalization of company details
      t.string :company_name

      t.string :contact_first_name, null: false
      t.string :contact_last_name, null: false
      t.string :contact_email, null: false
      t.string :contact_phone_1, null: false
      t.string :contact_phone_2
      t.string :contact_address_1, null: false
      t.string :contact_address_2
      t.string :contact_city, null: false
      t.string :contact_region, null: false
      t.string :contact_postal_code, null: false
      t.string :contact_country, null: false

      t.string :billing_first_name, null: false
      t.string :billing_last_name, null: false
      t.string :billing_email, null: false
      t.string :billing_phone_1, null: false
      t.string :billing_phone_2
      t.string :billing_address_1, null: false
      t.string :billing_address_2
      t.string :billing_city, null: false
      t.string :billing_region, null: false
      t.string :billing_postal_code, null: false
      t.string :billing_country, null: false
    end

    add_column :campaigns, :insertion_order_id, :bigint

    # the campaign additions below aren't strictly necessary since we can determine
    # campaign keywords and country_codes based on audience and region
    add_column :campaigns, :audience_id, :integer
    add_column :campaigns, :region_id, :integer
  end
end

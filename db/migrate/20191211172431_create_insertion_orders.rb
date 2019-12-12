class CreateInsertionOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :insertion_orders do |t|
      t.bigint :organization_id, null: false
      t.bigint :user_id, null: false
      t.string :crm_id

      t.monetize :budget, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.datetime :approved_at
      t.datetime :rejected_at
      t.datetime :paid_at
      t.timestamps

      # company details
      t.string :company_name
      t.string :company_phone
      t.string :company_address_1, null: false
      t.string :company_address_2
      t.string :company_city, null: false
      t.string :company_region, null: false
      t.string :company_postal_code, null: false
      t.string :company_country, null: false

      # company contact
      t.string :contact_first_name, null: false
      t.string :contact_last_name, null: false
      t.string :contact_email, null: false
      t.string :contact_phone, null: false

      # billing details
      t.string :billing_address_1, null: false
      t.string :billing_address_2
      t.string :billing_city, null: false
      t.string :billing_region, null: false
      t.string :billing_postal_code, null: false
      t.string :billing_country, null: false

      # billing contact
      t.string :billing_contact_first_name, null: false
      t.string :billing_contact_last_name, null: false
      t.string :billing_contact_email, null: false
      t.string :billing_contact_phone, null: false

      t.text :notes
    end

    add_column :campaigns, :insertion_order_id, :bigint

    # the campaign additions below aren't strictly necessary since we can determine
    # campaign keywords and country_codes based on audience and region
    add_column :campaigns, :audience_id, :integer
    add_column :campaigns, :region_id, :integer
  end
end

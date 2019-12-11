# == Schema Information
#
# Table name: insertion_orders
#
#  id                    :bigint           not null, primary key
#  billing_address_1     :string           not null
#  billing_address_2     :string
#  billing_city          :string           not null
#  billing_country       :string           not null
#  billing_email         :string           not null
#  billing_first_name    :string           not null
#  billing_last_name     :string           not null
#  billing_phone_1       :string           not null
#  billing_phone_2       :string
#  billing_postal_code   :string           not null
#  billing_region        :string           not null
#  company_name          :string
#  contact_address_1     :string           not null
#  contact_address_2     :string
#  contact_city          :string           not null
#  contact_country       :string           not null
#  contact_email         :string           not null
#  contact_first_name    :string           not null
#  contact_last_name     :string           not null
#  contact_phone_1       :string           not null
#  contact_phone_2       :string
#  contact_postal_code   :string           not null
#  contact_region        :string           not null
#  end_date              :datetime         not null
#  start_date            :datetime         not null
#  total_budget_cents    :integer          default(0), not null
#  total_budget_currency :string           default("USD"), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  organization_id       :bigint           not null
#  user_id               :bigint           not null
#

class InsertionOrder < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................

  # relationships .............................................................
  belongs_to :organization
  belongs_to :user
  has_many :campaigns

  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............

  # class methods .............................................................
  class << self
  end

  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end

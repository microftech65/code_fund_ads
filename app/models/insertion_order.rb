# == Schema Information
#
# Table name: insertion_orders
#
#  id                         :bigint           not null, primary key
#  approved_at                :datetime
#  billing_address_1          :string           not null
#  billing_address_2          :string
#  billing_city               :string           not null
#  billing_contact_email      :string           not null
#  billing_contact_first_name :string           not null
#  billing_contact_last_name  :string           not null
#  billing_contact_phone      :string           not null
#  billing_country            :string           not null
#  billing_postal_code        :string           not null
#  billing_region             :string           not null
#  budget_cents               :integer          default(0), not null
#  budget_currency            :string           default("USD"), not null
#  company_address_1          :string           not null
#  company_address_2          :string
#  company_city               :string           not null
#  company_country            :string           not null
#  company_name               :string
#  company_phone              :string
#  company_postal_code        :string           not null
#  company_region             :string           not null
#  contact_email              :string           not null
#  contact_first_name         :string           not null
#  contact_last_name          :string           not null
#  contact_phone              :string           not null
#  end_date                   :datetime         not null
#  notes                      :text
#  paid_at                    :datetime
#  rejected_at                :datetime
#  start_date                 :datetime         not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  crm_id                     :string
#  organization_id            :bigint           not null
#  user_id                    :bigint           not null
#

class InsertionOrder < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................

  # relationships .............................................................
  belongs_to :organization
  belongs_to :user
  has_many :campaigns

  # validations ...............................................................
  validate :validate_dates, on: [:create]
  validate :validate_budget, on: [:create, :update]

  # callbacks .................................................................
  # scopes ....................................................................

  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  accepts_nested_attributes_for :campaigns
  monetize :budget_cents, numericality: {greater_than_or_equal_to: 0}

  # class methods .............................................................
  class << self
  end

  # public instance methods ...................................................

  def build_campaign
    audience = Audience.blockchain
    region = Region.united_states_and_canada
    campaigns.build(
      temporary_id: campaigns.size,
      audience: audience,
      region: region,
      start_date: start_date,
      end_date: end_date,
    )
  end

  def to_stashable_attributes
    as_json.merge campaigns_attributes: campaigns.map(&:to_stashable_attributes)
  end

  def allocated_budget
    Money.new campaigns.sum(&:total_budget)
  end

  def allocated_budget_percentage
    return 0 unless budget > 0
    return 0 unless allocated_budget > 0
    (allocated_budget.to_f / budget.to_f) * 100
  end

  def budget_allocated?
    budget > 0 && allocated_budget == budget
  end

  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def validate_dates
    return if persisted?
    return unless start_date && end_date
    errors[:start_date] << "cannot be in the past" if start_date.past?
    errors[:end_date] << "cannot be in the past" if end_date.past?
    errors[:end_date] << "cannot be earlier than start_date" if end_date < start_date
  end

  def validate_budget
    return if budget_allocated?
    errors[:budget] << "is not allocated properly"
  end
end

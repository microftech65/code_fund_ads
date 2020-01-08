# == Schema Information
#
# Table name: organizations
#
#  id               :bigint           not null, primary key
#  name             :string           not null
#  balance_cents    :integer          default(0), not null
#  balance_currency :string           default("USD"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require "csv"

class Organization < ApplicationRecord
  # extends ...................................................................

  # includes ..................................................................
  include Organizations::Developable
  include Eventable

  # relationships .............................................................
  has_many :campaigns
  has_many :creatives
  has_many :insertion_orders
  has_many :impressions
  has_many :job_postings
  has_many :organization_reports
  has_many :organization_transactions
  has_many :organization_users, dependent: :destroy
  has_many :scheduled_organization_reports
  has_many :users
  has_many :administrators, -> { where organization_users: {role: ENUMS::ORGANIZATION_ROLES::ADMINISTRATOR} }, through: :organization_users, source: "user"
  has_many :members, -> { where organization_users: {role: ENUMS::ORGANIZATION_ROLES::MEMBER} }, through: :organization_users, source: "user"
  has_many :owners, -> { where organization_users: {role: ENUMS::ORGANIZATION_ROLES::OWNER} }, through: :organization_users, source: "user"

  # validations ...............................................................
  validates :name, presence: true
  validates_each :name, unless: :skip_validation do |record, attr, value|
    if record.name_changed? && ENUMS::RESERVED_ORGANIZATION_NAMES[value.downcase.strip]
      record.errors.add(attr, "'#{value}' is reserved")
    end
  end

  # callbacks .................................................................

  # scopes ....................................................................
  scope :with_positive_balance, -> { where(Organization.arel_table[:balance_cents].gt(0)) }
  scope :with_negative_balance, -> { where(Organization.arel_table[:balance_cents].lt(0)) }
  scope :with_zero_balance, -> { where(balance_cents: 0) }
  scope :search_name, ->(value) { value.blank? ? all : search_column(:name, value) }
  scope :search_balance_direction, ->(value) {
    case value
      when ENUMS::ORGANIZATION_SEARCH_DIRECTIONS::POSITIVE then with_positive_balance
      when ENUMS::ORGANIZATION_SEARCH_DIRECTIONS::NEGATIVE then with_negative_balance
      when ENUMS::ORGANIZATION_SEARCH_DIRECTIONS::ZERO then with_zero_balance
      else all
    end
  }

  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  attr_accessor :skip_validation
  monetize :balance_cents, numericality: true
  acts_as_commentable
  has_paper_trail on: %i[update destroy], only: %i[
    name
  ]

  # class methods .............................................................
  class << self
    def codefund
      where(name: "CodeFund").first_or_create!(skip_validation: true)
    end
    alias positive with_positive_balance
    alias negative with_negative_balance
    alias zero with_zero_balance
  end

  # public instance methods ...................................................

  def total_debits
    Money.new(organization_transactions.debits.sum(&:amount_cents), "USD")
  end

  def total_credits
    Money.new(organization_transactions.credits.sum(&:amount_cents), "USD")
  end

  def recalculate_balance!
    update_attribute(:balance, total_credits - total_debits)
  end

  def organization_transactions_csv
    CSV.generate do |csv|
      csv << %w[
        id
        organization_id
        posted_at
        amount
        transaction_type
        gift
        description
        reference
      ]
      organization_transactions.each do |record|
        row = []
        row << record.id
        row << record.organization_id
        row << record.posted_at
        row << record.amount.format
        row << record.transaction_type
        row << record.gift
        row << record.description
        row << record.reference
        csv << row
      end
    end
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end

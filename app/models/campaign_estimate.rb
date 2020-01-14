class CampaignEstimate
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :campaign
  delegate :start_date, :end_date, :total_budget, :insertion_order, :audience, :region, to: :campaign
  alias budget total_budget

  validate :validate_budget

  # The adjusted budget for this estimate.
  def adjusted_budget
    [budget, estimated_impressions_value].min
  end

  def budget_discrepancy?
    budget != adjusted_budget
  end

  # The eCPM for this estimate. i.e. cost per thousand impressions
  def ecpm
    audience.ecpm_for_region(region)
  end

  # A list of dates for this estimate.
  def dates
    (start_date..end_date).to_a
  end

  # The number of days this estimate spans.
  def days
    dates.size
  end

  def target_daily_spend
    budget / days.to_f
  end

  # The daily-budget for the budget and days.
  # NOTE: The calculated value is padded to allow for traffic spikes and lulls.
  def daily_budget_cap
    return target_daily_spend * 1.5 if days > 0
    Money.new(0)
  end

  def hourly_budget_cap
    daily_budget_cap / 3
  end

  # The maximum number of impressions for each day.
  def max_daily_impressions_count
    @max_daily_impressions_count ||= (daily_budget_cap.to_f / individual_impression_price.to_f).floor
  end

  # The fractional price (in US dollars) of a single impression.
  def individual_impression_price
    @individual_impression_price ||= ecpm.to_f / 1000
  end

  def target_impressions_count
    @target_impressions_count ||= (budget.to_f / individual_impression_price).floor
  end

  def target_daily_impressions_count
    @target_daily_impressions_count ||= (target_daily_spend.to_f / individual_impression_price.to_f).floor
  end

  # The average number of impressions for the audience and region.
  def average_impressions_count
    @average_impressions_count ||= average_daily_impressions.values.sum { |data| data[:count] }
  end

  # The available (for purchase) number of impressions for the audience and region.
  def available_impressions_count
    @available_impressions_count ||= available_daily_impressions.values.sum { |data| data[:count] }
  end

  def available_impressions_count_daily_average
    @avaliable_impressions_daily_average ||= (available_impressions_count / days.to_f).floor
  end

  # The estimated number of impressions.
  def estimated_impressions_count
    @estimated_impressions_count ||= [
      target_impressions_count,
      dates.map { |date| impressions_on(date)[:estimated] }.sum,
    ].min
  end

  # The estimated number of daily impressions.
  def estimated_daily_impressions_count
    (estimated_impressions_count / days.to_f).floor
  end

  # The monetary value of the average number of impressions for the audience and region.
  def average_impressions_value
    @average_impressions_value ||= average_daily_impressions.values.sum { |data| data[:value] }
  end

  # The monetary value for the available (for purchase) impressions for the audience and region.
  def available_impressions_value
    @available_impressions_value ||= available_daily_impressions.values.sum { |data| data[:value] }
  end

  # The monetary value of this estimate.
  def estimated_impressions_value
    @estimated_impressions_value ||= Money.new((estimated_impressions_count * individual_impression_price) * 100)
  end

  # Average daily impressions stats for this estimate.
  #
  # Returns a Hash with the following data structure:
  #
  # {Date: {count: INTEGER, value: Money}
  def average_daily_impressions
    @average_daily_impressions ||= begin
      average_impressions_counts = audience.average_daily_impressions_counts(region: region)
      dates.each_with_object({}) do |date, memo|
        count = average_impressions_counts[date.day]
        value = Money.new((count * individual_impression_price) * 100)
        memo[date] = {count: count, value: value}
      end
    end
  end

  # Available daily impressions stats for this estimate.
  # This data omits pre-sold and reserved inventory.
  #
  # Returns a Hash with the following data structure:
  #
  # {Date: {count: INTEGER, value: Money}
  #
  # TODO: omit sold inventory
  def available_daily_impressions
    @available_daily_impressions ||= begin
      average_daily_impressions.each_with_object({}) do |(date, data), memo|
        count = (data[:count] * 0.85).floor
        value = Money.new((count * individual_impression_price) * 100)
        memo[date] = {count: count, value: value}
      end
    end
  end

  def impressions_on(date)
    @impressions_on ||= {}
    @impressions_on[date] ||= begin
      average_count = average_daily_impressions[date][:count]
      available_count = available_daily_impressions[date][:count]
      sold_count = average_count - available_count
      estimated_min_count = [target_daily_impressions_count, available_count].min
      estimated_max_count = [max_daily_impressions_count, available_count].min

      multiplier = available_count / available_impressions_count_daily_average.to_f
      estimated_min_count = [(estimated_min_count * multiplier).floor, available_count].min
      estimated_max_count = [(estimated_max_count * multiplier).floor, available_count].min
      estimated_count = [((estimated_min_count + estimated_max_count) / 2.to_f).floor, max_daily_impressions_count].min
      available_count -= estimated_count

      {
        date: date.iso8601,
        average: average_count,
        sold: sold_count,
        available: available_count,
        estimated: estimated_count,
      }
    end
  end

  def to_stacked_bar_chart_series
    dates.map { |date| impressions_on date }
  end

  private

  def validate_budget
    errors[:budget] << "has a discrepancy" if budget_discrepancy?
    errors[:budget] << "exceeds the insertion order budget" if budget > insertion_order.budget
  end
end

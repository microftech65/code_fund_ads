class CampaignEstimate
  include ActiveModel::Model

  attr_accessor :campaign
  delegate :start_date, :end_date, :total_budget, :audience, :region, to: :campaign
  alias budget total_budget

  # The adjusted budget for this estimate.
  def adjusted_budget
    [budget, estimated_impressions_value].min
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

  # The daily-budget for the budget and days.
  # NOTE: The calculated value is padded to allow for traffic spikes and lulls.
  def daily_budget
    return (budget / days.to_f) * 1.3 if days > 0
    Money.new(0)
  end

  def hourly_budget
    daily_budget / 3
  end

  # The maximum number of impressions for each day.
  def daily_impressions_count
    @daily_impressions_count ||= (daily_budget.to_f / individual_impression_price.to_f).floor
  end

  # The fractional price (in US dollars) of a single impression.
  def individual_impression_price
    @individual_impression_price ||= ecpm.to_f / 1000
  end

  def desired_impressions_count
    @desired_impressions_count ||= (budget.to_f / individual_impression_price).floor
  end

  # The average number of impressions for the audience and region.
  def average_impressions_count
    @average_impressions_count ||= average_daily_impressions.values.sum { |data| data[:count] }
  end

  # The available (for purchase) number of impressions for the audience and region.
  def available_impressions_count
    @available_impressions_count ||= available_daily_impressions.values.sum { |data| data[:count] }
  end

  # The estimated number of impressions.
  def estimated_impressions_count
    @estimated_impressions_count ||= [
      desired_impressions_count,
      estimated_daily_impressions.values.sum { |data| data[:count] },
    ].min
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

  # Expected daily impressions stats for this estimate.
  #
  # NOTE: The daily counts/values will typically be higher than what the budget supports.
  #       This allows us to accomodate daily variance in traffic patterns.
  #
  # Returns a Hash with the following data structure:
  #
  # {Date: {count: INTEGER, value: Money}
  def estimated_daily_impressions
    @estimated_daily_impressions ||= begin
      available_daily_impressions.each_with_object({}) do |(date, data), memo|
        count = [daily_impressions_count, data[:count]].min
        value = Money.new((count * individual_impression_price) * 100)
        memo[date] = {count: count, value: value}
      end
    end
  end

  def impressions_on(date)
    average_count = average_daily_impressions[date][:count]
    available_count = available_daily_impressions[date][:count]
    sold_count = average_count - available_count
    estimated_count = estimated_daily_impressions[date][:count]

    # TODO: fix multiplier
    # multiplier = ?
    # estimated_count = (estimated_count * multiplier).floor
    estimated_count = available_count if available_count < estimated_count
    available_count -= estimated_count

    {
      date: date.iso8601,
      average: average_count,
      sold: sold_count,
      available: available_count,
      estimated: estimated_count,
    }
  end

  def to_stacked_bar_chart_series
    dates.map { |date| impressions_on date }
  end
end

module Audiences
  module Presentable
    extend ActiveSupport::Concern

    def stacked_bar_chart_series(start_date, end_date, region:, total_budget:)
      dates = (Date.coerce(start_date)..Date.coerce(end_date)).to_a

      average_daily_counts = average_daily_impressions_counts(region: region)
      daily_count_average = (average_daily_counts.values.sum / average_daily_counts.size.to_f).round

      available_daily_counts = available_daily_impressions_counts(start_date, end_date, region: region)
      available_count_average = (available_daily_counts.values.sum / available_daily_counts.size.to_f).round

      purchasable_count = purchasable_impressions_count(start_date, end_date, region: region, total_budget: total_budget)
      purchasable_count_average = (purchasable_count / dates.size.to_f).round

      # target_daily_percentage = purchasable_count_average / daily_count_average.to_f
      target_daily_percentage = purchasable_count_average / available_count_average.to_f

      dates.each_with_object(labels: [], series: []) do |date, memo|
        memo[:labels] << date.to_s("mm/dd")

        reserved = (available_daily_counts[date] * target_daily_percentage).round
        reserved = available_daily_counts[date] if reserved > available_daily_counts[date]

        # total inventory
        memo[:series][0] ||= []
        memo[:series][0] << average_daily_counts[date.day] - reserved

        # purchashed inventory
        memo[:series][1] ||= []
        memo[:series][1] << reserved
      end
    end
  end
end
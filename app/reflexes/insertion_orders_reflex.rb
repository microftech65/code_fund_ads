class InsertionOrdersReflex < ApplicationReflex
  include InsertionOrders::Stashable

  def set_budget
    insertion_order.budget = Money.new(element[:value].to_f * 100)
  end

  def set_dates
    start_date, end_date = element[:value].split(" - ")
    insertion_order.assign_attributes start_date: Date.parse(start_date), end_date: Date.parse(end_date)
    insertion_order.campaigns.each do |campaign|
      campaign.assign_attributes start_date: insertion_order.start_date, end_date: insertion_order.end_date
    end
  end

  def add_campaign
    insertion_order.build_campaign
  end

  def remove_campaign
    insertion_order.campaigns.delete campaign
  end

  def set_campaign_budget
    budget = Money.new(element[:value].to_f * 100)
    campaign.total_budget = 0
    unallocated_budget = insertion_order.unallocated_budget
    budget = unallocated_budget if unallocated_budget < budget
    campaign.total_budget = budget
  end

  def set_campaign_audience
    campaign.assign_attributes audience_id: element[:value].to_i
  end

  def set_campaign_region
    campaign.assign_attributes region_id: element[:value].to_i
  end

  private

  def insertion_order
    @insertion_order ||= stashed_insertion_order
  end

  def campaign
    @campaign ||= begin
      temporary_id = element.dataset["temporary-id"].to_i
      insertion_order.campaigns.find { |c| c.temporary_id == temporary_id }
    end
  end
end
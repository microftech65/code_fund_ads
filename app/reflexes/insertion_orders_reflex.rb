class InsetionOrdersReflex < ApplicationReflex
  def change_audience
    session[:audience_id] = element[:value]
  end

  def change_region
    session[:region_id] = element[:value]
  end

  def change_total_budget
    session[:total_budget] = element[:value]
  end

  def change_dates
    adate, bdate = element[:value].split(" - ")
    session[:adate] = adate
    session[:bdate] = bdate
  end
end

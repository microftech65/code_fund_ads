require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome

  def teardown
    Rails.cache.clear
  end

  def refresh
    page.reset!
  end
end

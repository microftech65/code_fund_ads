# == Schema Information
#
# Table name: regions
#
#  id                                        :integer          primary key
#  name                                      :text
#  blockchain_ecpm_currency                  :text
#  blockchain_ecpm_cents                     :integer
#  css_and_design_ecpm_currency              :text
#  css_and_design_ecpm_cents                 :integer
#  dev_ops_ecpm_currency                     :text
#  dev_ops_ecpm_cents                        :integer
#  game_development_ecpm_currency            :text
#  game_development_ecpm_cents               :integer
#  javascript_and_frontend_ecpm_currency     :text
#  javascript_and_frontend_ecpm_cents        :integer
#  miscellaneous_ecpm_currency               :text
#  miscellaneous_ecpm_cents                  :integer
#  mobile_development_ecpm_currency          :text
#  mobile_development_ecpm_cents             :integer
#  web_development_and_backend_ecpm_currency :text
#  web_development_and_backend_ecpm_cents    :integer
#  country_codes                             :text             is an Array
#

require "test_helper"

class RegionTest < ActiveSupport::TestCase
  test "ecpm pricing for audience" do
    assert Region.find(1).ecpm(Audience.blockchain).format == "$0.75"
    assert Region.find(2).ecpm(Audience.mobile_development).format == "$0.75"
    assert Region.find(3).ecpm(Audience.dev_ops).format == "$5.25"
    assert Region.find(4).ecpm(Audience.game_development).format == "$1.13"
    assert Region.find(5).ecpm(Audience.javascript_and_frontend).format == "$2.03"
    assert Region.find(6).ecpm(Audience.web_development_and_backend).format == "$1.35"
    assert Region.find(7).ecpm(Audience.miscellaneous).format == "$2.25"
    assert Region.find(8).ecpm(Audience.css_and_design).format == "$3.38"
    assert Region.find(9).ecpm(Audience.blockchain).format == "$4.50"
    assert Region.find(10).ecpm(Audience.mobile_development).format == "$0.38"
  end

  test "all country codes are used" do
    Region.all.map(&:country_codes).flatten == Country.all.map(&:iso_code)
  end

  test "Africa pricing" do
    region = Region.africa

    assert region.blockchain_ecpm.format == "$0.75"
    assert region.css_and_design_ecpm.format == "$0.38"
    assert region.dev_ops_ecpm.format == "$0.53"
    assert region.game_development_ecpm.format == "$0.38"
    assert region.javascript_and_frontend_ecpm.format == "$0.68"
    assert region.miscellaneous_ecpm.format == "$0.23"
    assert region.mobile_development_ecpm.format == "$0.38"
    assert region.web_development_and_backend_ecpm.format == "$0.45"
  end

  test "Americas - Central and Southern pricing" do
    region = Region.americas_central_southern

    assert region.blockchain_ecpm.format == "$1.50"
    assert region.css_and_design_ecpm.format == "$0.75"
    assert region.dev_ops_ecpm.format == "$1.05"
    assert region.game_development_ecpm.format == "$0.75"
    assert region.javascript_and_frontend_ecpm.format == "$1.35"
    assert region.miscellaneous_ecpm.format == "$0.45"
    assert region.mobile_development_ecpm.format == "$0.75"
    assert region.web_development_and_backend_ecpm.format == "$0.90"
  end

  test "Americas - Northern pricing" do
    region = Region.americas_northern

    assert region.blockchain_ecpm.format == "$7.50"
    assert region.css_and_design_ecpm.format == "$3.75"
    assert region.dev_ops_ecpm.format == "$5.25"
    assert region.game_development_ecpm.format == "$3.75"
    assert region.javascript_and_frontend_ecpm.format == "$6.75"
    assert region.miscellaneous_ecpm.format == "$2.25"
    assert region.mobile_development_ecpm.format == "$3.75"
    assert region.web_development_and_backend_ecpm.format == "$4.50"
  end

  test "Asia - Central and South-Eastern pricing" do
    region = Region.asia_central_and_south_eastern

    assert region.blockchain_ecpm.format == "$2.25"
    assert region.css_and_design_ecpm.format == "$1.13"
    assert region.dev_ops_ecpm.format == "$1.58"
    assert region.game_development_ecpm.format == "$1.13"
    assert region.javascript_and_frontend_ecpm.format == "$2.03"
    assert region.miscellaneous_ecpm.format == "$0.68"
    assert region.mobile_development_ecpm.format == "$1.13"
    assert region.web_development_and_backend_ecpm.format == "$1.35"
  end

  test "Asia - Eastern pricing" do
    region = Region.asia_eastern

    assert region.blockchain_ecpm.format == "$2.25"
    assert region.css_and_design_ecpm.format == "$1.13"
    assert region.dev_ops_ecpm.format == "$1.58"
    assert region.game_development_ecpm.format == "$1.13"
    assert region.javascript_and_frontend_ecpm.format == "$2.03"
    assert region.miscellaneous_ecpm.format == "$0.68"
    assert region.mobile_development_ecpm.format == "$1.13"
    assert region.web_development_and_backend_ecpm.format == "$1.35"
  end

  test "Asia - Southern and Western pricing" do
    region = Region.asia_southern_and_western

    assert region.blockchain_ecpm.format == "$2.25"
    assert region.css_and_design_ecpm.format == "$1.13"
    assert region.dev_ops_ecpm.format == "$1.58"
    assert region.game_development_ecpm.format == "$1.13"
    assert region.javascript_and_frontend_ecpm.format == "$2.03"
    assert region.miscellaneous_ecpm.format == "$0.68"
    assert region.mobile_development_ecpm.format == "$1.13"
    assert region.web_development_and_backend_ecpm.format == "$1.35"
  end

  test "Australia and New Zealand pricing" do
    region = Region.australia_and_new_zealand

    assert region.blockchain_ecpm.format == "$7.50"
    assert region.css_and_design_ecpm.format == "$3.75"
    assert region.dev_ops_ecpm.format == "$5.25"
    assert region.game_development_ecpm.format == "$3.75"
    assert region.javascript_and_frontend_ecpm.format == "$6.75"
    assert region.miscellaneous_ecpm.format == "$2.25"
    assert region.mobile_development_ecpm.format == "$3.75"
    assert region.web_development_and_backend_ecpm.format == "$4.50"
  end

  test "Europe pricing" do
    region = Region.europe

    assert region.blockchain_ecpm.format == "$6.75"
    assert region.css_and_design_ecpm.format == "$3.38"
    assert region.dev_ops_ecpm.format == "$4.73"
    assert region.game_development_ecpm.format == "$3.38"
    assert region.javascript_and_frontend_ecpm.format == "$6.08"
    assert region.miscellaneous_ecpm.format == "$2.03"
    assert region.mobile_development_ecpm.format == "$3.38"
    assert region.web_development_and_backend_ecpm.format == "$4.05"
  end

  test "Europe - Eastern pricing" do
    region = Region.europe_eastern

    assert region.blockchain_ecpm.format == "$4.50"
    assert region.css_and_design_ecpm.format == "$2.25"
    assert region.dev_ops_ecpm.format == "$3.15"
    assert region.game_development_ecpm.format == "$2.25"
    assert region.javascript_and_frontend_ecpm.format == "$4.05"
    assert region.miscellaneous_ecpm.format == "$1.35"
    assert region.mobile_development_ecpm.format == "$2.25"
    assert region.web_development_and_backend_ecpm.format == "$2.70"
  end

  test "Other pricing" do
    region = Region.other

    assert region.blockchain_ecpm.format == "$0.75"
    assert region.css_and_design_ecpm.format == "$0.38"
    assert region.dev_ops_ecpm.format == "$0.53"
    assert region.game_development_ecpm.format == "$0.38"
    assert region.javascript_and_frontend_ecpm.format == "$0.68"
    assert region.miscellaneous_ecpm.format == "$0.23"
    assert region.mobile_development_ecpm.format == "$0.38"
    assert region.web_development_and_backend_ecpm.format == "$0.45"
  end
end

# == Schema Information
#
# Table name: creative_images
#
#  id                           :bigint           not null, primary key
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  active_storage_attachment_id :bigint           not null
#  creative_id                  :bigint           not null
#
# Indexes
#
#  index_creative_images_on_active_storage_attachment_id  (active_storage_attachment_id)
#  index_creative_images_on_creative_id                   (creative_id)
#

require "test_helper"

class CreativeImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

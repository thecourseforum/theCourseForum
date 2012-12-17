# == Schema Information
#
# Table name: sections
#
#  id              :integer          not null, primary key
#  course_id       :integer
#  professor_id    :integer
#  rate_overall    :float
#  rate_professor  :float
#  rate_fun        :float
#  rate_difficulty :float
#  rate_recommend  :float
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

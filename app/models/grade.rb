class Grade < ActiveRecord::Base
  belongs_to :section
  belongs_to :semester
  attr_accessible :count_a, :count_aminus, :count_b, :count_bminus, :count_bplus, :count_c, :count_cminus, :count_cplus, :count_d, :count_dminus, :count_dplus, :count_drop, :count_f, :count_other, :count_withdraw, :gpa
end

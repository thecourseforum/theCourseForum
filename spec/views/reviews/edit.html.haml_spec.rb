require 'rails_helper'

RSpec.describe "reviews/edit", :type => :view do
  before(:each) do
    @user = create(:confirmed_user_with_student)
    @review = build(:review)
    @review.user = @user
    @review.save
    @subdepartments = [create(:subdepartment)]
    @years = [Time.now.year]
    sign_in @user
  end

  it "renders the edit review form" do
    render

    assert_select "form[action=?][method=?]", review_path(@review), "post" do
    end
  end
end

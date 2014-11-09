require 'rails_helper'

RSpec.describe "reviews/new", :type => :view do
  before(:each) do
    assign(:review, Review.new())
    @user = create(:confirmed_user_with_student)
    @subdepartments = [create(:subdepartment)]
    @years = [Time.now.year]
    sign_in @user
  end

  it "renders new review form" do
    render

    assert_select "form[action=?][method=?]", reviews_path, "post" do
    end
  end
end

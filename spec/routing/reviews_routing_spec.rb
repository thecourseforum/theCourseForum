require "rails_helper"
require "support/devise_helper.rb"

RSpec.describe ReviewsController, :type => :routing do
  before(:each) do
    review = create(:review_with_user)
  end

  describe "routing" do
    it "does not route to #index" do 
      expect(:get => "/reviews/").to_not be_routable
    end

    it "does not route to #show" do 
      expect(:get => "/reviews/1").to_not be_routable
    end

    it "routes to #new" do
      expect(:get => "/reviews/new").to route_to("reviews#new")
    end

      it "routes to #edit" do
      expect(:get => "/reviews/1/edit").to route_to("reviews#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/reviews").to route_to("reviews#create")
    end

    it "routes to #update" do
      expect(:put => "/reviews/1").to route_to("reviews#update", :id => "1")
    end

  end
end

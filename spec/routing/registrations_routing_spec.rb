require "rails_helper"

RSpec.describe RegistrationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/registrations").to route_to("registrations#index")
    end

    it "routes to #new" do
      expect(:get => "/registrations/new").to route_to("registrations#new")
    end

    it "routes to #show" do
      expect(:get => "/registrations/1").to route_to("registrations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/registrations/1/edit").to route_to("registrations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/registrations").to route_to("registrations#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/registrations/1").to route_to("registrations#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/registrations/1").to route_to("registrations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/registrations/1").to route_to("registrations#destroy", :id => "1")
    end

  end
end

require 'rails_helper'
require 'spec_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe "GET #show" do
    # As a developer using RSpec
    # I want to execute arbitrary code before and after each example
    # So that I can control the environment in which it is run
    #RSPec documentation: https://www.relishapp.com/rspec/rspec-core/v/2-0/docs/hooks/before-and-after-hooks
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json  
    end

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_name: true)
      expect(user_response['email']).to eql @user.email
    end

    it { should respond_with 200 }

  end

end

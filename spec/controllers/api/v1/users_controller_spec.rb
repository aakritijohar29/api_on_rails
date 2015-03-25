require 'rails_helper'
require 'spec_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  #Concatenate the JSON format inside the header
  before(:each) { request.headers['Accept'] = "application/vnd.marketapi.v1, #{Mime::JSON}" }
  before(:each) { request.headers['Content-Type'] = Mime::JSON.to_s }

  describe "GET #show" do
    # As a developer using RSpec
    # I want to execute arbitrary code before and after each example
    # So that I can control the environment in which it is run
    #RSPec documentation: https://www.relishapp.com/rspec/rspec-core/v/2-0/docs/hooks/before-and-after-hooks
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id  
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    #GET requests generally return 200 code (The request has succeeded)
    it { should respond_with 200 }
  end

  describe "POST #create" do

    #==========================================================================
    context "when is successfully created" do
      before(:each) do
        @user_attibutes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attibutes }
      end

      it "renders the JSON representation for the user record just created" do
        user_response = json_response
        expect(user_response['email']).to eql @user_attibutes['email']
      end

      #POST requests 201 means the request has been fulfilled 
      #and resulted in a new resource being created.
      it { should respond_with 201 }
    end

    #==========================================================================
    context "when is not created" do
      before(:each) do
        #I am not including the User's email
        @invalid_user_attributes = { password: "12345678", password_confirmation: "12345678" }
        post :create, { user: @invalid_user_attributes }
      end

      it "renders an json error" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the JSON error explaning why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      #POST requests usually returns 422 code in case of errors
      it { should respond_with 422 }
    end

  end

  describe "PUT/PATCH #update" do

    #=============================================================
    context "when is successfully updated" do 
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id, user: { email: "newemail@example.com" } }
      end

      it "renders the JSON representation for the updated User" do
        user_response = json_response
        expect(user_response[:email]).to eql "newemail@example.com"
      end

      # 200 code == OK
      it { should respond_with 200 }
    end

    context "when is not updated" do

      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id, user: { email: "invalid.com" } }
      end

      it "renders and JSON error" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the JSON error explaning why the user could not be updated" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      # 422 code == The request was well-formed but was unable to be followed due to semantic errors
      it { should respond_with 422 }

    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      delete :destroy, { id: @user.id }
    end

    #The server successfully processed the request, 
    #but is not returning any content. 
    #Usually used as a response to a successful delete request.
    it { should respond_with 204 }
  end

end


















































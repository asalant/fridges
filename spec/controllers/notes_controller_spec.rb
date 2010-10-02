require 'spec_helper'

describe NotesController do

  describe "GET index" do
    before do
      get :index, :fridge_id => fridges(:alon).id
    end

    it "finds all notes for fridge" do
      assigns(:notes).should have(2).items
    end

    it "responds with json" do
      response.body.should == assigns(:notes).to_json
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before do
        post :create, :fridge_id => fridges(:alon).id, :note => {}
      end

      it "creates note" do
        response.should be_success
        assigns(@note).should be_present
      end

      it "responds with json" do
        response.body.should == assigns(:note).to_json
      end
    end

    describe "with invalid params" do

    end

  end

  describe "DELETE destroy" do
    before do
      Note.should_receive(:find).with("37") { Note.new }
    end

    it "destroys the note" do
      delete :destroy, :fridge_id => fridges(:alon).id, :id => "37"
      response.should be_success
    end
  end

end

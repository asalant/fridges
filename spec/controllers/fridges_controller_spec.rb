require 'spec_helper'

describe FridgesController do
  before do
    AWS::S3::Base.stubs(:establish_connection!)
    Fridge.any_instance.stubs(:save_attached_files)
    Fridge.any_instance.stubs(:destroy_attached_files)
  end

  describe "GET index" do
    it "assigns all fridges as @fridges" do
      Fridge.stubs(:all).returns [fridges(:alon)]
      get :index
      assigns(:fridges).should == [fridges(:alon)]
    end
  end

  describe "GET any" do
    it "redirects to show" do
      Fridge.stubs(:any).returns fridges(:alon)
      get :any
      response.should redirect_to(fridge_key_url(fridges(:alon).key))
    end
  end

  describe "GET show" do
    it "shows by id" do
      get :show, :id => fridges(:alon)
      assigns(:fridge).should == fridges(:alon)
    end

    it "shows by key" do
      get :show, :key => fridges(:alon).key
      assigns(:fridge).should == fridges(:alon)
    end

    it "responds with not found for unknown key" do
      get :show, :key => 'unknown'
      response.should be_not_found
    end
  end

  describe "GET claim" do
    before { sign_in users(:alon) }

    context "for unclaimed fridge" do
      before do
        get :claim, :token => fridges(:unclaimed).claim_token
      end

      it "claims the fridge for the logged in user" do
        assigns(:fridge).should == fridges(:unclaimed)
        assigns(:fridge).user.should == users(:alon)
      end

      it "redirects to show" do
        response.should redirect_to fridge_key_url(assigns(:fridge).key)
      end

    end

    context "for unknown token" do
      before do
        get :claim, :token => 'unknown'
      end

      it "responds with not found" do
        response.should be_not_found
      end
    end
  end

  describe "GET new" do
    before { sign_in users(:alon) }

    it "assigns a new fridge as @fridge" do
      get :new
      assigns(:fridge).should be_new_record
    end
  end

  describe "GET edit" do
    before { sign_in users(:alon) }

    it "assigns the requested fridge as @fridge" do
      get :edit, :id => fridges(:alon)
      assigns(:fridge).should == fridges(:alon)
    end
  end

  describe "POST create" do
    before { sign_in users(:alon) }

    describe "with valid params" do
      before do
        post :create, :fridge => {:name => 'Name', :photo => fixture_file_upload('spec/fixtures/fridge.jpg', 'image/jpeg')}
      end

      it "creates the fridge" do
        assigns(:fridge).should_not be_new_record
        assigns(:fridge).user.should == users(:alon)
      end

      it "redirects to the created fridge" do
        response.should redirect_to(fridge_key_url(assigns(:fridge).key))
      end
    end

    describe "with invalid params" do
      before do
        post :create, :fridge => {}
      end

      it "re-renders the 'new' template" do
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do
    before { sign_in users(:alon) }

    describe "with valid params" do
      before do
        put :update, :id => fridges(:alon), :fridge => {'name' => 'new'}
      end

      it "updates the requested fridge" do
        assigns(:fridge).name.should == 'new'
      end

      it "redirects to the fridge" do
        response.should redirect_to(fridge_key_url(assigns(:fridge).key))
      end
    end

    describe "with invalid params" do
      before do
        put :update, :id => fridges(:alon), :fridge => {'photo_file_name' => ''}
      end

      it "re-renders the 'edit' template" do
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    before do
      sign_in users(:alon)
      delete :destroy, :id => fridges(:alon)
    end

    it "destroys the requested fridge" do
      lambda { Fridge.find fridges(:alon) }.should raise_exception(ActiveRecord::RecordNotFound)
    end

    it "redirects to the fridges list" do
      response.should redirect_to(fridges_url)
    end
  end

end

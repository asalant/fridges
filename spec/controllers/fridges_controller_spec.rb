require 'spec_helper'

describe FridgesController do

  def mock_fridge(stubs={})
    @mock_fridge ||= mock_model(Fridge, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all fridges as @fridges" do
      Fridge.stub(:all) { [mock_fridge] }
      get :index
      assigns(:fridges).should eq([mock_fridge])
    end
  end

  describe "GET show" do
    it "assigns the requested fridge as @fridge" do
      Fridge.stub(:find).with("37") { mock_fridge }
      get :show, :id => "37"
      assigns(:fridge).should be(mock_fridge)
    end
  end

  describe "GET new" do
    it "assigns a new fridge as @fridge" do
      Fridge.stub(:new) { mock_fridge }
      get :new
      assigns(:fridge).should be(mock_fridge)
    end
  end

  describe "GET edit" do
    it "assigns the requested fridge as @fridge" do
      Fridge.stub(:find).with("37") { mock_fridge }
      get :edit, :id => "37"
      assigns(:fridge).should be(mock_fridge)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created fridge as @fridge" do
        Fridge.stub(:new).with({'these' => 'params'}) { mock_fridge(:save => true) }
        post :create, :fridge => {'these' => 'params'}
        assigns(:fridge).should be(mock_fridge)
      end

      it "redirects to the created fridge" do
        Fridge.stub(:new) { mock_fridge(:save => true) }
        post :create, :fridge => {}
        response.should redirect_to(fridge_url(mock_fridge))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved fridge as @fridge" do
        Fridge.stub(:new).with({'these' => 'params'}) { mock_fridge(:save => false) }
        post :create, :fridge => {'these' => 'params'}
        assigns(:fridge).should be(mock_fridge)
      end

      it "re-renders the 'new' template" do
        Fridge.stub(:new) { mock_fridge(:save => false) }
        post :create, :fridge => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested fridge" do
        Fridge.should_receive(:find).with("37") { mock_fridge }
        mock_fridge.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :fridge => {'these' => 'params'}
      end

      it "assigns the requested fridge as @fridge" do
        Fridge.stub(:find) { mock_fridge(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:fridge).should be(mock_fridge)
      end

      it "redirects to the fridge" do
        Fridge.stub(:find) { mock_fridge(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(fridge_url(mock_fridge))
      end
    end

    describe "with invalid params" do
      it "assigns the fridge as @fridge" do
        Fridge.stub(:find) { mock_fridge(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:fridge).should be(mock_fridge)
      end

      it "re-renders the 'edit' template" do
        Fridge.stub(:find) { mock_fridge(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested fridge" do
      Fridge.should_receive(:find).with("37") { mock_fridge }
      mock_fridge.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the fridges list" do
      Fridge.stub(:find) { mock_fridge }
      delete :destroy, :id => "1"
      response.should redirect_to(fridges_url)
    end
  end

end

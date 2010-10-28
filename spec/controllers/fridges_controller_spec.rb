require 'spec_helper'

describe FridgesController do
  render_views

  before do
    AWS::S3::Base.stubs(:establish_connection!)
    Fridge.any_instance.stubs(:save_attached_files)
    Fridge.any_instance.stubs(:destroy_attached_files)
  end

  describe "GET index" do
    context "when not logged in" do
      it "requires log in" do
        get :index
        response.should be_redirect
      end
    end

    context "when logged in" do
      before do
        sign_in users(:alon)
      end

      it "shows fridges for user" do
        get :index, :user_id => users(:alon).id
        assigns(:fridges).should == [fridges(:alon)]
        assigns(:user).should == users(:alon)
      end

      it "forbids viewing fridges for other user" do
        get :index, :user_id => users(:rob).id
        response.should be_forbidden
      end
    end

    context "when logged in as admin" do
      before do
        sign_in users(:admin)
      end

      it "shows all fridges" do
        get :index
        assigns(:fridges).should == Fridge.all
      end

      it "shows fridges for user" do
        get :index, :user_id => users(:rob).id
        assigns(:fridges).should == [fridges(:rob)]
        assigns(:user).should == users(:rob)
      end
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
      get :show, :key => 'nofrdg'
      response.should be_not_found
    end

    it "should increment view count" do
      get :show, :id => fridges(:alon)
      assigns(:fridge).view_count.should == 1
    end

    context "when logged in as fridge owner" do
      before do
        sign_in users(:alon)
      end

      it "should increment view count if not yet viewed" do
        get :show, :id => fridges(:alon)
        assigns(:fridge).view_count.should == 1
      end

      it "should not increment view count if already viewed" do
        fridges(:alon).update_attribute(:view_count, 10)
        get :show, :id => fridges(:alon)
        assigns(:fridge).view_count.should == 10
      end
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

    context "with valid params" do
      before do
        controller.expects(:post_to_facebook).never
        post :create, :fridge => {:name => 'Name', :photo => fixture_file_upload('spec/fixtures/fridge.jpg', 'image/jpeg')}
      end

      it "creates the fridge" do
        assigns(:fridge).should_not be_new_record
        assigns(:fridge).user.should == users(:alon)
      end

      it "redirects to the created fridge" do
        response.should redirect_to(fridge_key_url(assigns(:fridge).key))
      end

      context "with facebook token" do
        it "posts to facebook" do
          controller.expects(:post_to_facebook)

          post :create,
            :fridge                        => {:photo => fixture_file_upload('spec/fixtures/fridge.jpg', 'image/jpeg')},
            :access_token                  => 'access_token',
            :post_to_facebook              => 'true'
        end
      end
    end

    context "with invalid params" do
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

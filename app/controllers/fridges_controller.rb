class FridgesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :any, :show]

  def index
    @fridges = Fridge.all
  end

  def any
    fridge = Fridge.any
    if fridge
      redirect_to fridge_key_url(fridge.key)
    else
      redirect_to fridges_url
    end
  end

  def show
    if (params[:key])
      @fridge = Fridge.find_by_key(params[:key])
      if !@fridge
        render :action => 'not_found', :status => :not_found
        return
      end
    else
      @fridge = Fridge.find(params[:id])
    end

    if !@fridge.owned_by?(current_user) || @fridge.view_count == 0
      @fridge.count_view!
    end
  end

  def claim
    @fridge = Fridge.find_by_claim_token(params[:token])
    if !@fridge
      render :action => 'not_found', :status => :not_found
    else
      @fridge.claim_by! current_user
      redirect_to(fridge_key_url(@fridge.key), :notice => 'Fridge claimed!')
    end
  end

  def new
    @fridge = Fridge.new
  end

  def edit
    @fridge = Fridge.find(params[:id])
  end

  def create
    @fridge      = Fridge.new(params[:fridge])
    @fridge.user = current_user

    if @fridge.save
      if params[:post_to_facebook] && params[:access_token]
        post_to_facebook(params[:access_token], @fridge)
      end
      redirect_to(fridge_key_url(@fridge.key), :notice => 'Fridge uploaded!')
    else
      render :action => "new"
    end
  end

  def update
    @fridge = Fridge.find(params[:id])

    if @fridge.update_attributes(params[:fridge])
      redirect_to(fridge_key_url(@fridge.key), :notice => 'Fridge updated!')
    else
      render :action => "edit"
    end
  end

  def destroy
    @fridge = Fridge.find(params[:id])
    @fridge.destroy

    redirect_to(fridges_url)
  end

  private

  def post_to_facebook(access_token, fridge)
    post = {
      :message => "Check out my fridge!",
      :picture => fridge.photo.url(:large).gsub(%r(^/system/), "http://localhost:300/system/"), # for development
      :link    => fridge_key_url(fridge.key, :host => 'frdg.us'),
      :description => "You are what you refrigerate. Do you agree?\n\nPost your own so I can see!</p>"
      }
    Rails.logger.debug "Posting to Facebook: #{post.inspect}"
    graph = Koala::Facebook::GraphAPI.new(access_token)
    graph.put_object("me", "feed", post)

  end
end

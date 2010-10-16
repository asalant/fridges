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
        render :status => :not_found, :file => "#{Rails.root}/public/404.html"
      end
    else
      @fridge = Fridge.find(params[:id])
    end
  end

  def claim
    @fridge = Fridge.find_by_claim_token(params[:token])
    if !@fridge
      render :status => :not_found, :file => "#{Rails.root}/public/404.html"
    else
      @fridge.claim_by current_user
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
      redirect_to(fridge_key_url(@fridge.key), :notice => 'Fridge created!')
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
end

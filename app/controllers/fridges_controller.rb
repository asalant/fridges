class FridgesController < ApplicationController
  include FridgesHelper

  before_filter :authenticate_user!, :except => [:index, :any, :show]

  def index
    @fridges = Fridge.all
  end

  def any
    fridge = Fridge.any
    if fridge
      redirect_to fridge_key_url(fridge)
    else
      redirect_to fridges_url
    end
  end

  def show
    if (params[:key])
      @fridge = Fridge.find_by_key(params[:key])
    else
      @fridge = Fridge.find(params[:id])
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
      redirect_to(@fridge, :notice => 'Fridge was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @fridge = Fridge.find(params[:id])

    if @fridge.update_attributes(params[:fridge])
      redirect_to(@fridge, :notice => 'Fridge was successfully updated.')
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

class FridgesController < ApplicationController
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

  # GET /fridges/1/edit
  def edit
    @fridge = Fridge.find(params[:id])
  end

  # POST /fridges
  # POST /fridges.xml
  def create
    @fridge = Fridge.new(params[:fridge])

    respond_to do |format|
      if @fridge.save
        format.html { redirect_to(@fridge, :notice => 'Fridge was successfully created.') }
        format.xml { render :xml => @fridge, :status => :created, :location => @fridge }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @fridge.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /fridges/1
  # PUT /fridges/1.xml
  def update
    @fridge = Fridge.find(params[:id])

    respond_to do |format|
      if @fridge.update_attributes(params[:fridge])
        format.html { redirect_to(@fridge, :notice => 'Fridge was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @fridge.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /fridges/1
  # DELETE /fridges/1.xml
  def destroy
    @fridge = Fridge.find(params[:id])
    @fridge.destroy

    respond_to do |format|
      format.html { redirect_to(fridges_url) }
      format.xml { head :ok }
    end
  end
end

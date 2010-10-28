class NotesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  def index
    @notes = Note.find_all_by_fridge_id(params[:fridge_id])
    render :json => @notes
  end

  def create
    @note = Note.new(params[:note].merge(:fridge_id => params[:fridge_id]))

    if @note.save
      render :json => @note
    else
      render :json => @note.errors, :status => :unprocessable_entity
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy

    head :ok
  end
end

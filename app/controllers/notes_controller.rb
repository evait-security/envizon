class NotesController < ApplicationController
  before_action :set_note, only: [:show, :destroy]
  before_action :set_noteable, only: [:create, :new]

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new

    case @noteable.model_name 
    when "Client"
      @noteable_info = @noteable.ip
    when "Group"
      @noteable_info = @noteable.name
    when "Port"
      @noteable_info = "#{@noteable.client.ip}: #{@noteable.number}"
    else
      @noteable_info = "No further information received"
    end
  end

  # POST /notes
  # POST /notes.json
  def create
    if defined?(@noteable) && @noteable.present?
      @new_note = @noteable.notes.new(note_params)
      unless @new_note.save
        respond_with_notify("Error while creating the note", "alert")
      end
    else
      respond_with_notify("Error while creating the note", "alert")
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_with_notify("Note was successfully destroyed", "success")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:content, :noteable_id, :noteable_type)
    end
    def set_noteable
      return unless ActiveRecord::Base.connection.tables.map{
                                                            |x|x.capitalize.singularize.camelize
                                                            }.include?(params[:noteable_type])
  
      noteable_type = params[:noteable_type].constantize
      @noteable = noteable_type.find(params[:noteable_id])
    end
    def respond_with_notify(message = 'Unknown error', type = 'alert')
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { render 'pages/notify', locals: { message: message, type: type, close: true } }
      end
    end
end

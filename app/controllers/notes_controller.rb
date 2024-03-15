class NotesController < ApplicationController
  include UsersHelper

  before_action :set_note, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ new create edit update destroy ]
  before_action :require_user_if_private, only: %i[ show ]

  # GET /notes or /notes.json
  def index
    @notes = logged_in? ? Note.all : Note.where(private: false)
    @notes = @notes.where("? = ANY(tags)", params[:tag]) if params[:tag]

    @notes = @notes.order(updated_at: :desc)
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to note_url(@note), notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to note_url(@note), notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy!

    respond_to do |format|
      format.html { redirect_to notes_url, notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      tags = (params.dig(:note, :tags) || []).split(",").map(&:strip)

      params
        .require(:note)
        .permit(:title, :content, :tags, :private)
        .merge(tags:)
    end

    def authenticate_user!
      redirect_to root_path unless logged_in?
    end

    def require_user_if_private
      redirect_to root_path if @note.private? && !logged_in?
    end
end

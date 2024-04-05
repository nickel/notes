# frozen_string_literal: true

class NotesController < ApplicationController
  include ApplicationHelper

  before_action :set_note, only: %i(show edit update destroy)
  before_action :authenticate_user!, only: %i(new create edit update destroy)
  before_action :require_user_if_private, only: %i(show)

  def index
    @notes = logged_in? ? Note.all : Note.where(private: false)
    @notes = @notes.where("? = ANY(tags)", params[:tag]) if params[:tag]

    @notes = @notes.order(updated_at: :desc)
  end

  def show
  end

  def new
    @note = Note.new
  end

  def edit
  end

  def create
    @note = Note.new(note_params)

    if @note.save
      redirect_to note_url(@note), notice: "Note was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      redirect_to note_url(@note), notice: "Note was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy!

    redirect_to notes_url, notice: "Note was successfully destroyed."
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

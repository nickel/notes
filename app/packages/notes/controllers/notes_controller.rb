# frozen_string_literal: true

class NotesController < ApplicationController
  include ApplicationHelper

  before_action :set_note, only: %i(show edit update destroy)
  before_action :authenticate_user!, only: %i(new create edit update destroy)
  before_action :require_user_if_private, only: %i(show)

  def index
    by_visibility = logged_in? ? "private" : "public"

    @notes = Note::FindAll.call(
      by_visibility:, by_tag: params[:tag], by_query: params[:q]
    ).value

    @tags = Tag::FindAll.call(
      by_visibility:
    ).value
  end

  def show
  end

  def new
    @note_form = Note::Create::Form.new
  end

  def edit
    @note_form = Note::Update::Form.new(
      @note.attributes
        .slice(:title, :content, :tags, :private)
        .merge(note_id: params[:id])
    )
  end

  def create
    response = Note::Create.call(**input_data_for_create)

    if response.success?
      redirect_to note_url(response.value.id), notice: "Note was successfully created."
    else
      @note_form = response.value.data
      render :new, status: :unprocessable_entity
    end
  end

  def update
    response = Note::Update.call(**input_data_for_update)

    if response.success?
      redirect_to note_url(response.value.id), notice: "Note was successfully updated."
    else
      @note_form = response.value.data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Note::Remove.call(note_id: @note.id)

    redirect_to notes_url
  end

  private

  def set_note
    @note = Note::Find.call(
      note_id: params[:id]
    ).value!
  end

  def input_data_for_create
    params
      .require(:note_create_form)
      .permit(:title, :content, :tags, :private)
  end

  def input_data_for_update
    params
      .require(:note_update_form)
      .permit(:title, :content, :tags, :private)
      .merge(note_id: @note.id)
  end

  def authenticate_user!
    redirect_to root_path unless logged_in?
  end

  def require_user_if_private
    redirect_to root_path if @note.private? && !logged_in?
  end
end

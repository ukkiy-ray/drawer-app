class Api::BookmarksController < ApplicationController
  def index
    @bookmarks = Bookmark.order('created_at DESC')
  end

  def show
    @bookmark = Bookmark.find(params[:id])
    render 'show', formats: 'json', handlers: 'jbuilder'
  end
end

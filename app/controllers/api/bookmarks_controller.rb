class Api::BookmarksController < ApplicationController
  protect_from_forgery :except => [:create, :destroy]

  def index
    @bookmarks = Bookmark.order('created_at DESC')
  end

  def show
    @bookmark = Bookmark.find(params[:id])
    render 'show', formats: 'json', handlers: 'jbuilder'
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    if @bookmark.save
      render :show, status: :created
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    if @bookmark.destroy
      render json: { json: 'Bookmark was successfully deleted.'}
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end
 
  private
    def bookmark_params
      params.permit(:title, :url, :category)
    end
end

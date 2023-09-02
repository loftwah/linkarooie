# app/controllers/links_controller.rb

class LinksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_link, only: [:show, :edit, :update, :destroy]
  
    def index
      @links = current_user.links.order(:links_group, :links_pinned, :position)
    end
  
    def new
      @link = current_user.links.build
    end
  
    def create
      @link = current_user.links.build(link_params)
      if @link.save
        redirect_to links_path, notice: 'Link created successfully.'
      else
        render :new
      end
    end
  
    def show
    end
  
    def edit
    end
  
    def update
      if @link.update(link_params)
        redirect_to links_path, notice: 'Link updated successfully.'
      else
        render :edit
      end
    end
  
    def destroy
      @link.destroy
      redirect_to links_path, notice: 'Link deleted successfully.'
    end
  
    private
  
    def set_link
      @link = current_user.links.find(params[:id])
    end
  
    def link_params
      params.require(:link).permit(:links_group, :links_url, :links_display_name, :links_icon, :links_enabled, :links_pinned, :position)
    end
  end
  
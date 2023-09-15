class KanbanColumnsController < ApplicationController
    before_action :set_kanban
    before_action :set_kanban_column, only: %i[ show edit update destroy ]
  
    def index
        @kanban_columns = @kanban.kanban_columns
    end
  
    def show
    end
  
    def new
      @kanban_column = @kanban.kanban_columns.new
    end
  
    def create
      @kanban_column = @kanban.kanban_columns.new(kanban_column_params)
      if @kanban_column.save
        redirect_to kanban_kanban_columns_url(@kanban), notice: "Column was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
    end
  
    def update
      if @kanban_column.update(kanban_column_params)
        redirect_to kanban_kanban_columns_url(@kanban), notice: "Column was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @kanban_column.destroy
      redirect_to kanban_kanban_columns_url(@kanban), notice: "Column was successfully destroyed."
    end
  
    private
  
    def set_kanban
      @kanban = Kanban.find(params[:kanban_id])
    end
  
    def set_kanban_column
      @kanban_column = @kanban.kanban_columns.find(params[:id])
    end
  
    def kanban_column_params
      params.require(:kanban_column).permit(:name)
    end
  end
  
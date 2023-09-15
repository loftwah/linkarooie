class KanbansController < ApplicationController
  before_action :set_kanban, only: %i[ show edit update destroy ]

  # GET /kanbans or /kanbans.json
  def index
    @kanbans = Kanban.all
  end

  # GET /kanbans/1 or /kanbans/1.json
  def show
  end

  # GET /kanbans/new
  def new
    @kanban = Kanban.new
  end

  # GET /kanbans/1/edit
  def edit
  end

  # POST /kanbans or /kanbans.json
  def create
    @kanban = Kanban.new(kanban_params)

    respond_to do |format|
      if @kanban.save
        format.html { redirect_to kanban_url(@kanban), notice: "Kanban was successfully created." }
        format.json { render :show, status: :created, location: @kanban }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @kanban.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kanbans/1 or /kanbans/1.json
  def update
    respond_to do |format|
      if @kanban.update(kanban_params)
        format.html { redirect_to kanban_url(@kanban), notice: "Kanban was successfully updated." }
        format.json { render :show, status: :ok, location: @kanban }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kanban.errors, status: :unprocessable_entity }
      end
    end
  end

  def move
    begin
      card = Card.find(params[:card_id])
      new_column = KanbanColumn.find(params[:new_col_id])
      kanban = Kanban.find(params[:id])
      new_position = params[:new_position].to_i + 1 # Adjusting for 1-based index in acts_as_list
  
      if card && new_column && kanban && kanban.user == current_user
        Card.transaction do
          card.remove_from_list
          card.update!(kanban_column_id: new_column.id)
          card.insert_at(new_position)
        end
        render json: { status: 'success' }, status: :ok
      else
        render json: { status: 'error', message: 'Invalid parameters or unauthorized action.' }, status: :unprocessable_entity
      end
    rescue => e
      render json: { status: 'error', message: e.message }, status: :unprocessable_entity
    end
  end 

  # DELETE /kanbans/1 or /kanbans/1.json
  def destroy
    @kanban.destroy

    respond_to do |format|
      format.html { redirect_to kanbans_url, notice: "Kanban was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kanban
      @kanban = Kanban.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kanban_params
      params.require(:kanban).permit(:name, :description, kanban_columns_attributes: [:id, :name, :_destroy, cards_attributes: [:id, :name, :_destroy]])
    end
end

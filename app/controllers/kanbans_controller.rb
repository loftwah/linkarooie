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
        @new_card = @kanban.cards.last # Assuming last card created belongs to this Kanban
        format.turbo_stream
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
        turbo_stream.replace "card_#{card.id}", partial: 'cards/card', locals: { card: card }
      else
        turbo_stream.append "errors", turbo_stream: turbo_stream_action_tag(action: 'replace', target: 'errors') do
          render partial: 'shared/error', locals: { message: 'Invalid parameters or unauthorized action.' }
        end
      end
    rescue => e
      turbo_stream.append "errors", turbo_stream: turbo_stream_action_tag(action: 'replace', target: 'errors') do
        render partial: 'shared/error', locals: { message: e.message }
      end
    end
  end  

  # DELETE /kanbans/1 or /kanbans/1.json
  def destroy
    @card = Card.find(params[:id])
    @card.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to kanban_url(@kanban), notice: "Card was successfully destroyed." }
      format.json { head :no_content }
    end
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kanban
      @kanban = Kanban.find(params[:id])
      unless @kanban.user == current_user
        redirect_to root_url, alert: "Unauthorized action."
      end
    end    

    # Only allow a list of trusted parameters through.
    def kanban_params
      params.require(:kanban).permit(:name, :description, kanban_columns_attributes: [:id, :name, :_destroy, cards_attributes: [:id, :name, :_destroy]])
    end
end

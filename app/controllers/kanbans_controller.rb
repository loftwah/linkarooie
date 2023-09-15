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
      params.require(:kanban).permit(:name, :description, :cards)
    end
end

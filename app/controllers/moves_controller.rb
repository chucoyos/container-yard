class MovesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_move, only: %i[ show edit update destroy ]

  # GET /moves or /moves.json
  def index
    authorize current_user, :index?, policy_class: MovePolicy
    if current_user.role.name == "cliente"
      @moves = Move.joins(:container).where(containers: { user_id: current_user.id }).order(created_at: :desc)
    else
      @moves = Move.order(created_at: :desc)
    end
    if params[:number].present?
      @moves = @moves.joins(:container).where("containers.number ILIKE ?", "%#{params[:number]}%")
    end
    if params[:move_type].present? && params[:move_created_at].present?
      @moves = @moves.joins(:container).where(move_type: params[:move_type]).where("moves.created_at::date = ?", params[:move_created_at].to_date)
    end
    if params[:user_id].present?
      @moves = @moves.joins(:container).where(containers: { user_id: params[:user_id] })
    end
  end

  # GET /moves/1 or /moves/1.json
  def show
    authorize current_user, :show?, policy_class: MovePolicy
    @container = Container.find(@move.container_id)
  end

  # GET /moves/new
  def new
    authorize current_user, :create?, policy_class: MovePolicy
    @container = Container.find(params[:container_id])
    @move = Move.new(container_id: @container&.id)
    @current_location = @container.moves.last&.location
    @available_locations = if @current_location
      Location.available.or(Location.where(id: @current_location.id))
    else
      Location.available
    end
  end

  # GET /moves/1/edit
  def edit
    authorize current_user, :update?, policy_class: MovePolicy
    @container = Container.find(@move.container_id)
    @location = Location.find(@move.location_id) if @move.location_id.present?
    @move = Move.find(params[:id])
    @available_locations = Location.where(available: true).or(Location.where(id: @location.id))
    @current_location = @move.location
  end

  # POST /moves or /moves.json
  def create
    authorize current_user, :create?, policy_class: MovePolicy
    @move = Move.new(move_params)
    @container = Container.find(@move.container_id)

    if @move.move_type == "Entrada" && Location.available.exists?(params[:location_id])
       @move.location = Location.find(params[:location_id])
    end

    respond_to do |format|
      if @move.save
        format.html { redirect_to @move, notice: "Se agregó el movimiento." }
        format.json { render :show, status: :created, location: @move }
      else
        @available_locations = Location.available
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @move.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moves/1 or /moves/1.json
  def update
    authorize current_user, :update?, policy_class: MovePolicy
    @container = Container.find(@move.container_id)
    @location = Location.find(@move.location_id) if @move.location_id.present?
    respond_to do |format|
      if @move.update(move_params)
        format.html { redirect_to @move, notice: "Se actualizó el movimiento." }
        format.json { render :show, status: :ok, location: @move }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @move.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moves/1 or /moves/1.json
  def destroy
    authorize current_user, :destroy?, policy_class: MovePolicy
    @move.destroy!

    respond_to do |format|
      format.html { redirect_to moves_path, status: :see_other, notice: "El movimiento ha sido eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_move
      @move = Move.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def move_params
      params.require(:move).permit(:container_id, :move_type, :location_id, :status, :mode, :seal, :notes, images: [])
    end
end

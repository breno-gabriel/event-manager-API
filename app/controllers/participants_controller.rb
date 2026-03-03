class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :update, :destroy]

  def index
    @participants = Participant.all

    if params[:name].present?
      @participants = @participants.where("name ILIKE ?", "%#{params[:name]}%")
    end

    if params[:event_id].present?
      @participants = @participants.where(event_id: params[:event_id])
    end

    if params[:check_in_status].present?
      @participants = @participants.where(check_in_status: params[:check_in_status])
    end

    @participants = @participants.page(params[:page]).per(params[:per_page])
    render json: {
      participants: @participants.as_json(include: :event),
      meta: {
        current_page: @participants.current_page,
        total_pages: @participants.total_pages,
        total_count: @participants.total_count,
        per_page: @participants.limit_value
      }
    }
  end

  def show
    render json: @participant.as_json(include: :event)
  end


  def create
    @participant = Participant.new(participant_params)

    if @participant.save
      render json: @participant, status: :created
    else
      render json: @participant.errors, status: :unprocessable_entity
    end
  end

  def update
    if @participant.update(participant_params)
      render json: @participant
    else
      render json: @participant.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @participant.destroy
    head :no_content
  end

  private

  def set_participant
    @participant = Participant.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Participant not found' }, status: :not_found
  end

  def participant_params
    params.require(:participant).permit(:name, :email, :check_in_status, :event_id)
  end
end
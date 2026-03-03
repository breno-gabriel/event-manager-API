class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]

  def index
    @events = Event.all
    @events = @events.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
    @events = @events.where(status: params[:status]) if params[:status].present?
    @events = @events.where("location ILIKE ?", "%#{params[:location]}%") if params[:location].present?
    @events = @events.where("date >= ?", params[:date_from]) if params[:date_from].present?
    @events = @events.where("date <= ?", params[:date_to]) if params[:date_to].present?
    order_direction = %w[asc desc].include?(params[:order]&.downcase) ? params[:order].downcase : "asc"
    @events = @events.order(date: order_direction)
    @events = @events.page(params[:page]).per(params[:per_page])
    render json: {
      events: ActiveModelSerializers::SerializableResource.new(@events),
      meta: {
        current_page: @events.current_page,
        total_pages: @events.total_pages,
        total_count: @events.total_count,
        per_page: @events.limit_value
      }
    }
  end

  def show
    render json: @event
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      render json: @event, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Event not found' }, status: :not_found
  end

  def event_params
    params.require(:event).permit(
    :name, :description, :date, :location, :status,
    checkin_rules_attributes: [
        :id, :name, :is_mandatory, :is_active, 
        :start_minutes, :end_minutes, :_destroy
    ]
    )
  end
end
class CheckinRulesController < ApplicationController
  before_action :set_event
  before_action :set_checkin_rule, only: [:show, :update, :destroy]

  def index
    @checkin_rules = @event.checkin_rules
    render json: @checkin_rules
  end

  def show
    render json: @checkin_rule
  end

  def create
    @checkin_rule = @event.checkin_rules.new(checkin_rule_params)

    if @checkin_rule.save
      render json: @checkin_rule, status: :created
    else
      render json: @checkin_rule.errors, status: :unprocessable_entity
    end
  end

  def update
    if @checkin_rule.update(checkin_rule_params)
      render json: @checkin_rule
    else
      render json: @checkin_rule.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @checkin_rule.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Event not found' }, status: :not_found
  end

  def set_checkin_rule
    @checkin_rule = @event.checkin_rules.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Checkin rule not found' }, status: :not_found
  end

  def checkin_rule_params
    params.require(:checkin_rule).permit(:name, :is_mandatory, :is_active, :start_minutes, :end_minutes)
  end
end

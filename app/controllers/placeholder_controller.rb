class PlaceholderController < ApplicationController
  before_action :set_placeholder_set, only: [:select, :destroy]
  def create
    begin
      placeholderset = PlaceholderSet.create(name: params[:placeholder_set][:name])

      params[:placeholder_value].each do | placeholder_id, placeholder_value_content|
        placeholderset.placeholder_values << PlaceholderValue.create(placeholder: Placeholder.find(placeholder_id), content: placeholder_value_content) if placeholder_value_content.present?
      end
      session[:current_placeholder_set] = placeholderset.id
      redirect_to :methodologies_index, notice: "Placeholder set successful created"
    rescue => exception
      redirect_to :methodologies_index, alert: "Error while creating placeholder set"
    end
  end

  def select
    session[:current_placeholder_set] = @placeholder_set.id
    redirect_to :methodologies_index, notice: "Placeholder set '#{@placeholder_set.name}' selected"
  end

  def destroy
    @placeholder_set.placeholder_values.delete_all
    @placeholder_set.delete
    redirect_to :methodologies_index, notice: "Placeholder successful destroyed"
  end


  private

  def set_placeholder_set
    unless @placeholder_set = PlaceholderSet.find_by_id(params[:id])
      redirect_to :methodologies_index, alert: "Error while selecting placeholder set"
    end
  end
end

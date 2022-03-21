class MethodologiesController < ApplicationController
  before_action :set_methodology, only: [:show, :check]
  before_action :set_methodology_book, only: [:book]

  def index
    @books = MethodologyBook.all
    @current_book = MethodologyBook.first
    @current_methodologies_by_cat = @current_book.methodologies
                                                 .includes(:methodology_category)
                                                 .order('methodology_categories.name, methodologies.name')
                                                 .group_by(&:methodology_category)

    @placeholder_set = PlaceholderSet.new
    @placeholder_value = PlaceholderValue.new
    @placeholders = Placeholder.all
    @placeholder_sets = PlaceholderSet.all

    render :book
  end

  def book
    @books = MethodologyBook.all
    @current_methodologies_by_cat = @current_book.methodologies
                                                 .includes(:methodology_category)
                                                 .order('methodology_categories.name, methodologies.name')
                                                 .group_by(&:methodology_category)
    @placeholder_set = PlaceholderSet.new
    @placeholder_value = PlaceholderValue.new
    @placeholders = Placeholder.all
    @placeholder_sets = PlaceholderSet.all
  end

  def show
  end

  def check
    @methodology.checked = !@methodology.checked
    @methodology.save
    redirect_back(fallback_location: methodologies_index_path)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_methodology
    unless @methodology = Methodology.find_by_id(params[:id])
      respond_with_notify("Methodology not found in DB", "alert")
    end
  end

  def set_methodology_book
    unless @current_book = MethodologyBook.find_by_id(params[:id])
      respond_with_notify("MethodologyBook not found in DB", "alert")
    end
  end
end

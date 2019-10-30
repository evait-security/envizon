class ReportPartsController < ApplicationController
  before_action :set_report_part, only: [:show, :edit, :update, :destroy]

  # GET /report_parts
  # GET /report_parts.json
  def index
    @report_parts = ReportPart.all
  end

  # GET /report_parts/1
  # GET /report_parts/1.json
  def show
  end

  # GET /report_parts/new
  def new
    @report_part = ReportPart.new
  end

  # GET /report_parts/1/edit
  def edit
  end

  # POST /report_parts
  # POST /report_parts.json
  def create
    @report_part = ReportPart.new(report_part_params)

    respond_to do |format|
      if @report_part.save
        format.html { redirect_to @report_part, notice: 'Report part was successfully created.' }
        format.json { render :show, status: :created, location: @report_part }
      else
        format.html { render :new }
        format.json { render json: @report_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /report_parts/1
  # PATCH/PUT /report_parts/1.json
  def update
    respond_to do |format|
      if @report_part.update(report_part_params)
        format.html { redirect_to @report_part, notice: 'Report part was successfully updated.' }
        format.json { render :show, status: :ok, location: @report_part }
      else
        format.html { render :edit }
        format.json { render json: @report_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /report_parts/1
  # DELETE /report_parts/1.json
  def destroy
    @report_part.destroy
    respond_to do |format|
      format.html { redirect_to report_parts_url, notice: 'Report part was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report_part
      @report_part = ReportPart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_part_params
      params.require(:report_part).permit(:title, :severity, :description, :customtargets, :rating, :recommendation, :type, :index)
    end
end

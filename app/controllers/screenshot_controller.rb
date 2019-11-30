class IssuesController < ApplicationController
    before_action :set_issue, :set_screenshot, only: [:update, :destroy]

    # PATCH/PUT /issues/1
    # PATCH/PUT /issues/1.json
    def update
        respond_to do |format|
            if @screenshot.update(screenshot_params)
                format.html { redirect_to reports_path, notice: 'Screenshot was successfully updated.' }
                format.json { render :show, status: :ok, location: @issue }
            else
                format.html { render :edit }
                format.json { render json: @issue.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /issues/1
    # DELETE /issues/1.json
    def destroy
        @screenshot.destroy
        respond_to do |format|
            format.html { redirect_to reports_path, notice: 'Screenshot was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
        @issue = Issue.find(params[:issue])
    end

    def set_screenshot
        @screenshot = Issue.find(params[:id])
    end

    def screenshot_params
        params.require(:screenshot).permit(:image, :description, :order)
    end
end

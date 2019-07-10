class ImagesController < ApplicationController
    def index
        @images = Port.joins(:image_attachment).map{|p| p.image}.sort{|i| i.created_at}
    end

    def scan_all
        ScreenshotJob.perform_async(false)
        respond_with_notify("Re-Scan started. Please refresh this page to get new results!", "notice", "true")
    end

    def scan_all_overwrite
        ScreenshotJob.perform_async(true)
        respond_with_notify("Re-Scan with overwrite started. Please refresh this page to get new results!", "notice", "true")
    end

    def respond_with_notify(message = 'Please make a selection', type = 'alert', close = "true")
        respond_to do |format|
          format.html { redirect_to images_path }
          format.js { render 'pages/notify', locals: { message: message, type: type, close: close } }
        end
    end
end

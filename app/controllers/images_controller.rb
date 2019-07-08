class ImagesController < ApplicationController
    def index
        @images = Port.joins(:image_attachment).map{|p| p.image}.sort{|i| i.created_at}.reverse
    end
end

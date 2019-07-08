class ImagesController < ApplicationController
    def index
        @ports_with_images = Port.joins(:image_attachment)
    end
end

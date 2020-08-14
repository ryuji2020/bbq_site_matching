class HomeController < ApplicationController
  def index
    @surplus_lands = SurplusLand.includes(:images_attachments).limit(4)
  end
end

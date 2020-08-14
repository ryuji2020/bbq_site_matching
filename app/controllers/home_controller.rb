class HomeController < ApplicationController
  def index
    @surplus_lands = SurplusLand.includes(images_attachments: :blob).limit(4)
  end
end

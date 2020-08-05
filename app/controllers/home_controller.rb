class HomeController < ApplicationController
  def index
    @surplus_lands = SurplusLand.order(:created_at).limit(4)
  end
end

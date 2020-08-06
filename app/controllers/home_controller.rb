class HomeController < ApplicationController
  def index
    @surplus_lands = SurplusLand.limit(4)
  end
end

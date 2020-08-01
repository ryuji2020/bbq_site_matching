class SurplusLandsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @surplus_lands = SurplusLand.all
  end

  def show
  end

  def new
    @surplus_land = SurplusLand.new
    @prefectures = Prefecture.pluck(:name)
    @prefectures.unshift('選択してください')
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end

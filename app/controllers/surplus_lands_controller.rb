class SurplusLandsController < ApplicationController
  def index
  end

  def show
  end

  def new
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

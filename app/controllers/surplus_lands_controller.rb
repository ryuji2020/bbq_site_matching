class SurplusLandsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_prefecture_array, only: [:new, :create, :edit, :update]

  def index
    @surplus_lands = SurplusLand.all
  end

  def show
  end

  def new
    @surplus_land = current_user.surplus_lands.build
  end

  def create
    @surplus_land = current_user.surplus_lands.build(surplus_land_params)
    if @surplus_land.save
      flash[:success] = '所有地を公開しました！'
      redirect_to root_path # 後で @surplus_land に変える
    else
      render 'new'
    end
  end

  def edit
    @surplus_land = SurplusLand.find(params[:id])
  end

  def update
    @surplus_land = SurplusLand.find(params[:id])
    if @surplus_land.update_attributes(surplus_land_params)
      if image_ids = params[:surplus_land][:image_ids]
        image_ids.each do |image_id|
          image = @surplus_land.images.find(image_id)
          image.purge
        end
      end
      flash[:success] = '公開所有地情報が変更されました'
      redirect_to root_path # 後で変更
    else
      @surplus_land.reload
      @surplus_land.attributes = surplus_land_params_without_images
      render 'edit'
    end
  end

  def destroy
  end

  private

  def surplus_land_params
    params.require(:surplus_land).permit(
      :title,
      :price,
      :state,
      :address,
      :description,
      images: []
    )
  end

  def surplus_land_params_without_images
    params.require(:surplus_land).permit(
      :title,
      :price,
      :state,
      :address,
      :description,
    )
  end

  # before_action

  # 都道府県セレクトボックス用の配列を作成
  def set_prefecture_array
    @prefectures = Prefecture.selectbox
  end
end

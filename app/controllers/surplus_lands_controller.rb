class SurplusLandsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_prefecture_array, only: [:new, :create, :edit, :update]
  before_action :get_region_prefectures, only: [:index, :refine_search]

  def index
    @surplus_lands = SurplusLand.includes(images_attachments: :blob).page(params[:page])
    @page_title = '貸し出し中のキャンプ地＆BBQ場'
  end

  def show
    @surplus_land = SurplusLand.includes(images_attachments: :blob).find(params[:id])
    @comments = @surplus_land.comments.includes(:user).page(params[:page]) # pagenationにするか？未定
    @comment = @surplus_land.comments.build
  end

  def new
    @surplus_land = current_user.surplus_lands.build
  end

  def create
    @surplus_land = current_user.surplus_lands.build(surplus_land_params)
    if @surplus_land.save
      flash[:success] = '所有地を公開しました！'
      redirect_to @surplus_land
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @surplus_land.update_attributes(surplus_land_params)
      if (image_ids = params[:surplus_land][:image_ids])
        image_ids.each do |image_id|
          image = @surplus_land.images.find(image_id)
          image.purge
        end
      end
      flash[:success] = '公開所有地情報が変更されました'
      redirect_to @surplus_land
    else
      @surplus_land.reload
      @surplus_land.attributes = surplus_land_params_without_images
      render 'edit'
    end
  end

  def destroy
    @surplus_land.destroy
    flash[:success] = '公開所有地を削除しました'
    redirect_to root_url
  end

  def refine_search
    @prefecture_name = params[:id]
    @surplus_lands = SurplusLand.where(state: @prefecture_name).includes(images_attachments: :blob).page(params[:page])
    @page_title = "#{@prefecture_name}のキャンプ地＆BBQ場"
    render 'index'
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
      :description
    )
  end

  # before_action

  def correct_user
    @surplus_land = SurplusLand.find(params[:id])
    redirect_to root_url unless current_user?(@surplus_land.user)
  end

  # 都道府県セレクトボックス用の配列を作成
  def set_prefecture_array
    @prefectures = Prefecture.selectbox
  end

  # サイドバー用の地方ごとの都道府県名配列を作成
  def get_region_prefectures
    @tohoku_hokkaido_prefectures = Prefecture.get_tohoku_hokkaido
    @kanto_prefectures = Prefecture.get_kanto
    @chubu_prefectures = Prefecture.get_chubu
    @kinki_prefectures = Prefecture.get_kinki
    @chugoku_prefectures = Prefecture.get_chugoku
    @shikoku_prefectures = Prefecture.get_shikoku
    @okinawa_kyushu_prefectures = Prefecture.get_okinawa_kyushu
  end
end

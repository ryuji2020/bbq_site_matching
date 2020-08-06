class Prefecture < ApplicationRecord
  # セレクトボックス用の配列を作成
  def self.selectbox
    pluck(:name).unshift('選択してください')
  end

  # 地方ごとの配列を作成
  def self.get_tohoku_hokkaido
    where(id: 1..7).pluck(:name)
  end

  def self.get_kanto
    where(id: 8..14).pluck(:name)
  end

  def self.get_chubu
    where(id: 15..23).pluck(:name)
  end

  def self.get_kinki
    where(id: 24..30).pluck(:name)
  end

  def self.get_chugoku
    where(id: 31..35).pluck(:name)
  end

  def self.get_shikoku
    where(id: 36..39).pluck(:name)
  end

  def self.get_okinawa_kyushu
    where(id: 40..47).pluck(:name)
  end
end

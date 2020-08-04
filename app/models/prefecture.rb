class Prefecture < ApplicationRecord
  # セレクトボックス用の配列を作成
  def self.selectbox
    pluck(:name).unshift('選択してください')
  end
end

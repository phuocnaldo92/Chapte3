class Micropost < ApplicationRecord

  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content_maximum}
  validate  :picture_size

  scope :order_by_day, -> {order(created_at: :desc)}
  scope :find_user_micropost, ->following_ids, user_id do
    where("user_id IN (?) OR user_id = ?", following_ids, user_id)
  end

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, t("should_be_less_than_5MB")
    end
  end
end

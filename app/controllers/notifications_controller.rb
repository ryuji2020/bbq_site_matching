class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.where.not(visitor_id: current_user.id).includes(:visitor, :surplus_land)
    if unchecked_notifications = @notifications.where(checked: false)
      unchecked_notifications.each do |notification|
        notification.update_attribute(:checked, true)
      end
    end
  end
end

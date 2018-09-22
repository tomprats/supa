class RemoveMensXSmallShirtSize < ActiveRecord::Migration[5.2]
  def up
    User.where(shirt_size: "Mens XSmall").update(shirt_size: nil)
  end
end

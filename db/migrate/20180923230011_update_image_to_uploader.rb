class UpdateImageToUploader < ActiveRecord::Migration[5.2]
  def change
    Image.destroy_all
  end
end

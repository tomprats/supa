class ImageUploader < CarrierWave::Uploader::Base
  def store_dir
    "#{model.class.name.pluralize.underscore.dasherize}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    "image.#{file.extension}" if original_filename
  end
end

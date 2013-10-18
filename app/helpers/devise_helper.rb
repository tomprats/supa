module DeviseHelper
  def devise_error_messages!
    errors_hash = Hash.new

    if defined?(resource) && resource && resource.errors && !resource.errors.empty?
      resource.errors.each do |key, value|
        unless value.blank?
          errors_hash[key] = value
        end
      end
    end

    errors_hash
  end
end

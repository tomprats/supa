module ActionController
  module Flash
    def render(*args)
      options = args.last.is_a?(Hash) ? args.last : {}

      self.class._flash_types.each do |type|
        if message = options.delete(type)
          flash[type] = message
        end
      end

      super(*args)
    end
  end
end

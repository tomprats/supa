Traitify.configure do |traitify|
  traitify.version = "v1"
  traitify.host = ENV["TRAITIFY_HOST"]
  traitify.public_key = ENV["TRAITIFY_PUBLIC"]
  traitify.secret_key = ENV["TRAITIFY_SECRET"]
  traitify.deck_id = "core"
end

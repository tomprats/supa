class TomConstraint
  def matches?(request)
    user = User.find_by(id: request.session[:current_user_id])
    user&.tom?
  end
end

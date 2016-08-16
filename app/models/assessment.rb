class Assessment < ApplicationRecord
  belongs_to :user

  def results
    Traitify.new.find_results(uid)
  end

  def blend
    results.personality_blend
  end
end

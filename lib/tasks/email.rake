namespace :email do
  desc "Championship email blast"
  task championship: :environment do
    raise "Do not attempt in #{Rails.env}" unless Rails.env.production?

    User.find_each do |user|
      UserMailer.championship(user).deliver_now
    end
  end

  desc "Invite email blast"
  task invite: :environment do
    raise "Do not attempt in #{Rails.env}" unless Rails.env.production?

    User.find_each do |user|
      UserMailer.invite(user).deliver_now
    end
  end
end

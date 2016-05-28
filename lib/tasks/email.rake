namespace :email do
  desc "Registration email blast"
  task registration: :environment do
    raise "Do not attempt in #{Rails.env}" unless Rails.env.production?
    User.find_each do |user|
      UserMailer.registration_email(user).deliver_now
    end
  end
end

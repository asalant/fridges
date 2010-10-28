namespace :users do
  desc 'Reset all user passwords to password.'
  task :reset_password => :environment do
    User.all.each { |user| user.update_attribute :password, 'password' }
  end

  desc 'Make a user an admin (use EMAIL=[email] to specify user).'
  task :enable_admin => :environment do
    User.find_by_email(ENV['EMAIL']).update_attribute(:role, 'admin')
  end
end
namespace :users do
  desc 'Reset all user passwords to password'
  task :reset_password => :environment do
    User.all.each { |user| user.update_attribute :password, 'password' }
  end
end
class UsersScenario < Scenario::Base  
  def load
    create_record :user, :ryan, :login => 'ryan', :daily_units => 3, :email => 'ryan.daigle@gmail.com', :crypted_password => User.encrypt('password', 'salt'), :salt => 'salt'
    create_record :user, :guest, :login => 'guest', :daily_units => 3, :email => 'guest@gmail.com', :crypted_password => User.encrypt('password', 'salt'), :salt => 'salt'
    Subject.all.each { |s| users(:ryan).subjects << s }
  end
end
require 'ptls/learning'
require 'ptls/reviewing'
require 'digest/sha1'

class User < ActiveRecord::Base

  include ::Authentication
  include ::Authentication::ByPassword
  include ::Authentication::ByCookieToken

  include Ptls::User::Learning
  include Ptls::User::Reviewing

  validates :login, :presence   => true,
                    :uniqueness => true,
                    :length     => { :within => 3..40 },
                    :format     => { :with => Authentication.login_regex, :message => Authentication.bad_login_message }

  validates :email, :presence   => true,
                    :uniqueness => true,
                    :format     => { :with => Authentication.email_regex, :message => Authentication.bad_email_message },
                    :length     => { :within => 6..100 }

  # Basic validations
  validates_numericality_of :daily_units, :integer_only => true, :less_than_or_equal_to => 100, :greater_than_or_equal_to => 1


  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :time_zone, :daily_units, :password, :password_confirmation

  # Basic associations
  has_many :learnings
  has_many :reviews
  has_many :associations
  has_many :subjects, :foreign_key => :owner_id

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  # Does this user own the given subject?
  def owns?(subject)
    subjects.include?(subject)
  end

end

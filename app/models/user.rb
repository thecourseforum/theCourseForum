class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, 
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_one :student
  has_one :professor
  has_many :reviews, :foreign_key => "student_id"#, :through => :student
  belongs_to :professor_user

  # relationships for scheduling
  has_and_belongs_to_many :courses
  has_many :schedules, dependent: :destroy

  # relationships for textbook listings
  has_many :active_listings, -> { where updated_at: (Time.now - TextbookTransaction.duration)..Time.now, buyer_id: nil }, :class_name => TextbookTransaction, :foreign_key => 'seller_id'
  has_many :inactive_listings, -> { where updated_at: Time.new(2000)..(Time.now - TextbookTransaction.duration), buyer_id: nil}, :class_name => TextbookTransaction, :foreign_key => 'seller_id'
  has_many :sold_listings, -> { where.not buyer_id: nil }, :class_name => TextbookTransaction, :foreign_key => 'seller_id'
  has_many :claims, :class_name => TextbookTransaction, :foreign_key => 'buyer_id'

  has_and_belongs_to_many :books

  #Provides citizenship and voter privileges
  acts_as_voter

  # creates default settings
  has_settings do |s|
    s.key :word_cloud, :defaults => {:on => false, :doge => false}
    s.key :last_four_years, :defaults => {:professors => false}
  end

  before_save { self.email.downcase! }
  VALID_EMAIL_REGEX = /\A[\w\-\.]+@(\w+\.)*virginia\.edu\z/i

  validates :email, :presence   => true,
                    :format     => { :with => VALID_EMAIL_REGEX },
                    :uniqueness => { :case_sensitive => false }

  validates_presence_of :first_name #, :last_name

  # Authenticate user based on old MD5-hashed password
  def old_authenticate(password)
    password_salt = ENV["OLD_SALT"]
    old_hash = Digest::MD5.hexdigest(password + password_salt)
    if old_hash == self.old_password
      return self
    else
      return false
    end
  end

  def migrate(password)
    self.password = password
    self.password_confirmation = password
    self.old_password = nil
    self.save
    return self      
  end

end

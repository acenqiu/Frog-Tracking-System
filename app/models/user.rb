class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:encryptable,
         :rememberable, :validatable, :token_authenticatable, :token_authentication_key => "i"

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :telephone, :avatar, :token

  #validates :username,  :presence => true,
	#                      :length   => { :within => 1..40 }
  validates :telephone, :format   => { :with => /\A1\d{10}\z/, :allow_nil => true }    

  ### plugins ###
  uniquify        :token, :length => 12, :chars => ('a'..'z').to_a + ('0'..'9').to_a

  has_many :projects
  has_many :jobs
  has_many :members
  has_many :relavant_projects, :class_name => "Project", :through => :members, :source => :project, :conditions => ['active=?', true]

  scope :no_member, lambda { |*args| {:conditions => ["not exists (select id from members where user_id=users.id and project_id=?)",
                                                       args.first]}}

  def gravatar_url
    hash = Digest::MD5.hexdigest email.gsub(/\s+/, '').downcase
    "http://www.gravatar.com/avatar/#{hash}"
  end                                                    

end

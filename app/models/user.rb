class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  devise :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable,
         :two_factor_authenticatable,
         :otp_secret_encryption_key => ENV['OTP_SECRET_ENCRYPTION_KEY']
         # :database_authenticatable,

  has_many :activities
  enum role: { admin: 'admin', teacher: 'teacher', student: 'student' }

  def to_s
    email || phone_number
  end

  def email_md5
    Digest::MD5.hexdigest email
  end

  def email_anonymised
    (email || '').gsub /[^@.]/, '*'
  end

  def points
    # All seasons with 0 points by default
    season_ids = Season.all.map { |s| [s.id, 0] }.to_h
    # Merge seasons hash witht the point by season for this user
    season_ids.merge activities.group(:season_id).sum(:points).to_h
  end

  def password=(p)
    if p
      super
    end
  end

  def password_required?
    false
  end

  def role?(*roles)
    roles.map(&:to_sym).include? role.to_sym
  end

  def send_two_factor_authentication_code
    #send sms with code!
    p "=> Your OTP code for #{email}:  #{otp_code}"
  end
end

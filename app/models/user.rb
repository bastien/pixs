class User < ActiveRecord::Base
  has_many :bookmarks, :dependent => :destroy
  has_many :films, :through => :bookmarks
  
  before_create :generate_secret_id
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["user_info"]["name"]
    end
  end
  
  protected
  
  def generate_secret_id
    self.secret_id = Digest::MD5.hexdigest(name + Time.now.to_s)
  end
  
end

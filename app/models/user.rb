class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :doodles, dependent: :destroy
  has_many :missions
  has_many :comments

  def friendships
    Friendship.find_by_sql(
      ["SELECT * FROM friendships WHERE user_id = :thisuser OR friend_id = :thisuser",
        {thisuser: id}])
  end

  def friends
    User.find_by_sql(
      ["SELECT * FROM users u, friendships f WHERE (u.id = f.user_id AND f.friend_id = :thisuser) OR (u.id = f.friend_id AND f.user_id = :thisuser)",
        {thisuser: id}
      ])
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end

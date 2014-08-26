require 'pry'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :doodles, dependent: :destroy
  has_many :profile_pictures, class_name: "Doodle", as: :doodleable
  has_many :missions
  has_many :comments

  attr_accessor :omniauth_token

  def friendships
    Friendship.find_by_sql(
      ["SELECT * FROM friendships WHERE user_id = :thisuser OR friend_id = :thisuser",
        {thisuser: id}])
  end

  def friends
    friend_ids = []
    friendships.each do |friendship|
      friend_ids << friendship.user_id unless friendship.user_id == id
      friend_ids << friendship.friend_id unless friendship.friend_id == id
    end
    User.where(id: friend_ids)
  end

  def add_friend(new_friend)
    Friendship.create(user: self, friend: new_friend)
  end

  def points
    if doodles.present?
      doodles.map(&:points).reduce(&:+)
    else
      0
    end
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.email = auth.info.email || "example@example.com"
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.omniauth_token = auth.credentials.token
      user.find_friends

      user.save!
    end
  end

  def find_friends
    graph = Koala::Facebook::API.new(omniauth_token)
    facebook_friends = graph.get_connection("me", "friends")
    uids = facebook_friends.map{ |friend| friend["id"] }
    existing_friends_uids = friends.map(&:uid)

    new_friends_uids = uids - existing_friends_uids

    new_friends = User.where(uid: new_friends_uids)
    new_friends.each do |person|
      add_friend(person)
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

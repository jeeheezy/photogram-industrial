# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  comments_count         :integer          default(0)
#  email                  :citext           default(""), not null
#  encrypted_password     :string           default(""), not null
#  likes_count            :integer          default(0)
#  photos_count           :integer          default(0)
#  private                :boolean          default(TRUE)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :citext
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, presence: true, uniqueness: true

  has_many :own_photos, class_name: "Photo", foreign_key: "owner_id"
  has_many :comments, foreign_key: "author_id"
  has_many :sent_follow_requests, class_name: "FollowRequest", foreign_key: "sender_id"
  has_many :accepted_sent_follow_requests, -> { accepted }, class_name: "FollowRequest", foreign_key: "sender_id"
  has_many :received_follow_requests, class_name: "FollowRequest", foreign_key: "recipient_id"
  has_many :accepted_received_follow_requests, -> { accepted },class_name: "FollowRequest", foreign_key: "recipient_id" 
  has_many :likes, foreign_key: "fan_id"

# consider going from one table to another table by named association
# e.g. makinga new association of many-to-many called liked_photos by starting from User, take association of likes to get to Like, and then go from Like to Photos by the association in Like called photos
  has_many :liked_photos, through: :likes, source: :photos
# start from User, go to FollowRequest by taking accepted_sent_follow_request, then going from FollowRequest to "different" User table by recipient association
  has_many :leaders, through: :accepted_sent_follow_requests, source: :recipient
# same association as the one before but just going the other way around
  has_many :followers, through: :accepted_received_follow_requests, source: :sender

# think of it as going from yourself to the user you are following by association of leaders, then going from that user to photos by associations of own_photos for their photos or liked_photos for the photos they liked
  has_many :feed, through: :leaders, source: :own_photos
  has_many :discover, through: :leaders, source: :liked_photos
end

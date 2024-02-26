desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  p "Creating sample data"
  if Rails.env.development?
    FollowRequest.destroy_all
    Comment.destroy_all
    Like.destroy_all
    Photo.destroy_all
    User.destroy_all
  end

  # create sample users
  usernames = Array.new {Faker::Name.first_name} #not sure what the point of this latter statement is
  usernames << "alice"
  usernames << "bob"
  # could've prob just written usernames = ["alice", "bob"]

  usernames.each do |username|
    User.create(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      private: [true, false].sample
    )
  end

  12.times do
    name = Faker::Name.first_name
    User.create(
      email: "#{name}@example.com",
      password: "password",
      username: name,
      private: [true, false].sample,
    )
  end

  p "There are now #{User.count} users."

  users = User.all

  # creating follow requests for sample users
  users.each do |first_user|
    users.each do |second_user|
      next if first_user == second_user
      if rand < 0.75
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.keys.sample,
        )
      end
      if rand < 0.75
        second_user.sent_follow_requests.create(
          recipient: first_user,
          status: FollowRequest.statuses.keys.sample,
        )
      end
    end
  end

  p "There are now #{FollowRequest.count} follow requests."

  users.each do |user|
    # creating random photos
    rand(15).times do
      photo = user.own_photos.create(
        caption: Faker::Quote.famous_last_words,
        image: "https://robohash.org/#{rand(9999)}",
      )

      user.followers.each do |follower|
        # using shovels to create likes that's has the appropriate user_id and photo_id populated
        if rand < 0.5 && !photo.fans.include?(follower)
          photo.fans << follower
        end

        # creating sample comments
        if rand < 0.25
          photo.comments.create(
            body: Faker::Quote.famous_last_words,
            author: follower
          )
        end
      end
    end
  end

  p "There are now #{Photo.count} photos."
  p "There are now #{Like.count} likes."
  p "There are now #{Comment.count} comments."
end

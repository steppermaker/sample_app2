# user
User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now,
             unique_name: "exsample_user",
             profile: "Hello World!")

99.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@railstutorial.org"
  password = "password"
  profile = Faker::Lorem.sentence(8)
  User.create!(name: name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now,
               unique_name: "sample_#{n+1}",
               profile: profile)
end

# micropost
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# relationship
users = User.all
user  = User.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# like
microposts = Micropost.all
targeted_micropost = microposts[0..49]
users_to_like      = User.order(:created_at).take(6)
users_to_like.each do |user|
  targeted_micropost.each { |micropost| micropost.likes.create!(user_id: user.id) }
end

# room, entry and messaged
mutual_users = users[3..22]
mutual_users.each do |mutual_user|
  room = Room.create!
  Entry.create!(room_id: room.id, user_id: user.id)
  Entry.create!(room_id: room.id, user_id: mutual_user.id)

  5.times do
    content = Faker::Lorem.sentence(10)
    Message.create!(user_id: user.id, room_id: room.id, content: content,
                    addressee_user_id: mutual_user.id, read: false)
    Message.create!(user_id: mutual_user.id, room_id: room.id, content: content,
                    addressee_user_id: user.id, read: false)
  end
end

# reply
micropost = Micropost.all
first = micropost[0]
first_replys = micropost[292..293]
second = micropost[1]
second_replys = micropost[294..295]
first_replys.each { |micropost| first.add_reply(micropost) }
second_replys.each { |micropost| second.add_reply(micropost)}

# active_admin
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

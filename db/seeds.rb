# user
User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now )

99.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# micropost
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# relationshp
users = User.all
user  = User.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# like
microposts = Micropost.all
targeted_micropost = microposts[2..50]
users_to_like      = User.order(:created_at).take(6)
users_to_like.each do |user|
  targeted_micropost.each { |micropost| micropost.likes.create!(user_id: user.id) }
end

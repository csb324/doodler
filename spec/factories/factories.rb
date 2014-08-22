FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Lorem.words(5).join }
  end

  factory :mission do
    user
    name { Faker::Lorem.word }
  end

  factory :doodle do
    user
    mission
    image Rack::Test::UploadedFile.new(
      File.open(File.join(Rails.root, '/spec/fixtures/myfiles/bunny.jpg'))
    )
  end

  factory :comment do
    user
    doodle
    body { Faker::Lorem.words(10).join(" ") }
  end


end

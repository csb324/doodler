FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Lorem.words(3).join }
  end

  factory :mission do
    user
    name { Faker::Lorem.words(1).join }
  end

  factory :doodle do
    user
    mission
    image Rack::Test::UploadedFile.new(
      File.open(File.join(Rails.root, '/spec/fixtures/myfiles/bunny.jpg'))
    )
  end

end

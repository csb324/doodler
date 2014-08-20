# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Mission.delete_all
Doodle.delete_all
User.delete_all

@admin = User.create(email: "Admin@doodler.com", password: "password")

10.times do
  @mission = Mission.create(name: RandomWord.nouns.next, user: @admin)
  4.times do
    Doodle.create(name: RandomWord.nouns.next, mission: @mission, user: @admin)
  end
end

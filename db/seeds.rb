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
  @mission = Mission.create(name: Wordnik.words.get_random_word(include_part_of_speech: 'noun', min_corpus_count: 50000)['word'], user: @admin)
end

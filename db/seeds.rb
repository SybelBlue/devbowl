# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
Question.destroy_all
Room.destroy_all

# Create sample questions
question1 = Question.create!(
  title: "Sample Science Question",
  category: "Science",
)

TossUp.create!(
  question: question1,
  format: "MultipleChoice",
  content: "What is the chemical symbol for gold?",
  answer: "X",
  answer_choices: ["Ag", "Au", "Go", "Gd"]
)

question2 = Question.create!(
  title: "Sample History Question",
  category: "History",
)

TossUp.create!(
  question: question2,
  format: "ShortAnswer",
  content: "Who was the first President of the United States?",
  answer: "George Washington"
)

# Create a sample room
Room.create!(name: "Test Room", code: "TEST01")

puts "Sample data created!"
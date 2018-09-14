# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: "prism@snu.com", password: "prism-snu")
User.create(email: "a@a.com", password: "aaaaaa")
User.create(email: "b@b.com", password: "bbbbbb")
User.create(email: "c@c.com", password: "cccccc")
User.create(email: "d@d.com", password: "dddddd")

Question.create(content: "what is your name?") # 디폴트로 admin이 생성한 것으로 되는지 확인
Question.create(content: "where are you from?", author_id: 2)
Question.create(content: "do you like butterflies?", author_id: 3)

FriendRequest.create(requester_id: 1, requestee_id: 2)
FriendRequest.create(requester_id: 1, requestee_id: 3)
FriendRequest.create(requester_id: 2, requestee_id: 4)

Friendship.create(user_id: 1, friend_id: 4)
Friendship.create(user_id: 4, friend_id: 3)
Friendship.create(user_id: 3, friend_id: 2)

Assignment.create(question_id: 2, assigner_id: 1, assignee_id: 4)
Assignment.create(question_id: 2, assigner_id: 2, assignee_id: 4)
Assignment.create(question_id: 2, assigner_id: 1, assignee_id: 2)
Assignment.create(question_id: 1, assigner_id: 2, assignee_id: 3)

Answer.create(author_id: 3, question_id: 1, content: "my name is A.") # assiger인 2번 유저에게 노티 보내져야함.
Answer.create(author_id: 2, question_id: 1, content: "my name is B.")
Answer.create(author_id: 1, question_id: 2, content: "I am from Jeju.")
Answer.create(author_id: 4, question_id: 2, content: "I am from Gunpo.") # assigner인 1번과 2번 유저에게 노티 보내져야함.
Answer.create(author_id: 1, question_id: 3, content: "No, never.")
Answer.create(author_id: 4, question_id: 3, content: "Not really.") 
Answer.create(author_id: 3, question_id: 3, content: "Are you kidding me?")

# Highlight 모델을 어떻게?

Comment.create(author_id: 2, recipient_id: 3, answer_id: 1, content: "oh really?")
Comment.create(author_id: 2, recipient_id: 3, answer_id: 2, content: "nice.")
Comment.create(author_id: 3, recipient_id: 1, answer_id: 3, content: "awesome!")
Comment.create(author_id: 3, recipient_id: 2, answer_id: 4, content: "same.")
Comment.create(author_id: 4, recipient_id: 3, answer_id: 5, content: "be a butterfly")
Comment.create(author_id: 4, recipient_id: 2, answer_id: 6, content: "shinee is the best")
Comment.create(author_id: 1, recipient_id: 2, answer_id: 1, content: "this is a comment.")

Tmi.create(author_id: 1, content: "I want bingsu.")
Tmi.create(author_id: 1, content: "writing TMIs")
Tmi.create(author_id: 1, content: "no shit yet today")
Tmi.create(author_id: 2, content: "I love soccer")
Tmi.create(author_id: 2, content: "I have an iPad.")
Tmi.create(author_id: 3, content: "I want to get a Macbook Pro.")
Tmi.create(author_id: 3, content: "Bangna came visit me yesterday")
Tmi.create(author_id: 3, content: "two lovely chihuahuas")
Tmi.create(author_id: 3, content: "salmon sushi ftw")
Tmi.create(author_id: 4, content: "406 sucks")

Star.create(user_id: 1, target: Question.find(1))
Star.create(user_id: 1, target: Question.find(2))
Star.create(user_id: 1, target: Answer.find(1))
Star.create(user_id: 3, target: Question.find(1))
Star.create(user_id: 3, target: Answer.find(3))
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development?
  # User
  # 1: 백산수, 2: 마틸다, 3:율로몬, 4: 잡동사니, 5: 이룰렁, 6: 누구게, 7: 메롱
  if User.where(email: 'prism@snu.com').empty?
    User.create(email: 'prism@snu.com', password: 'prism-snu', username: 'sansoo')
  end
  if User.where(email: 'a@a.com').empty?
    User.create(email: 'a@a.com', password: 'aaaaaa', username: 'matilda')
  end
  if User.where(email: 'b@b.com').empty?
    User.create(email: 'b@b.com', password: 'bbbbbb', username: 'yulomon')
  end
  if User.where(email: 'c@c.com').empty?
    User.create(email: 'c@c.com', password: 'cccccc', username: 'zapdongsani')
  end
  if User.where(email: 'd@d.com').empty?
    User.create(email: 'd@d.com', password: 'dddddd', username: 'leelooleong')
  end
  if User.where(email: 'e@e.com').empty?
    User.create(email: 'e@e.com', password: 'eeeeee', username: 'whod')
  end
  if User.where(email: 'f@f.com').empty?
    User.create(email: 'f@f.com', password: 'ffffff', username: 'merong')
  end

  # Question
  (1..8).each do |i|
    q = Question.find_or_create_by(content: Faker::TvShows::Simpsons.quote)
    if i <= 5
      q.selected_date = Time.now
    end
  end

  # Friend Request
  FriendRequest.find_or_create_by(requester_id: 1, requestee_id: 6)
  FriendRequest.find_or_create_by(requester_id: 3, requestee_id: 6)
  FriendRequest.find_or_create_by(requester_id: 4, requestee_id: 7)

  # Friendship
  Friendship.find_or_create_by(user_id: 1, friend_id: 2)
  Friendship.find_or_create_by(user_id: 1, friend_id: 3)
  Friendship.find_or_create_by(user_id: 1, friend_id: 4)
  Friendship.find_or_create_by(user_id: 1, friend_id: 5)
  Friendship.find_or_create_by(user_id: 2, friend_id: 3)
  Friendship.find_or_create_by(user_id: 2, friend_id: 4)
  Friendship.find_or_create_by(user_id: 2, friend_id: 5)
  Friendship.find_or_create_by(user_id: 3, friend_id: 4)
  Friendship.find_or_create_by(user_id: 3, friend_id: 5)
  Friendship.find_or_create_by(user_id: 4, friend_id: 5)

  # Assignment
  Assignment.find_or_create_by(target: Question.find(2), assigner_id: 1, assignee_id: 4)
  Assignment.find_or_create_by(target: Question.find(2), assigner_id: 2, assignee_id: 4)
  Assignment.find_or_create_by(target: Question.find(2), assigner_id: 1, assignee_id: 2)
  Assignment.find_or_create_by(target: Question.find(1), assigner_id: 2, assignee_id: 3)

  # Answer
  (1..20).each do |i|
    author_id = rand(7) + 1
    question_id = rand(8) + 1
    Answer.find_or_create_by(author_id: author_id, question_id: question_id, content: Faker::Quote.most_interesting_man_in_the_world)
  end

  (1..20).each do |i|
    answer = Answer.find(i)
    Entrance.find_or_create_by(channel: Channel.where(user_id: answer.author, name: '일촌').first, target: answer)
    Entrance.find_or_create_by(channel: Channel.where(user_id: answer.author, name: '이촌').first, target: answer)
    Entrance.find_or_create_by(channel: Channel.where(user_id: answer.author, name: '삼촌').first, target: answer)
    Entrance.find_or_create_by(channel: Channel.where(user_id: answer.author, name: '익명피드').first, target: answer)
  end

  # Post
  (1..20).each do |i|
    author_id = rand(7) + 1
    Post.find_or_create_by(author_id: author_id, content: Faker::TvShows::SiliconValley.quote)
  end

  (1..20).each do |i|
    post = Post.find(i)
    Entrance.find_or_create_by(channel: Channel.where(user_id: post.author, name: '일촌').first, target: post)
    Entrance.find_or_create_by(channel: Channel.where(user_id: post.author, name: '이촌').first, target: post)
    Entrance.find_or_create_by(channel: Channel.where(user_id: post.author, name: '삼촌').first, target: post)
    Entrance.find_or_create_by(channel: Channel.where(user_id: post.author, name: '익명피드').first, target: post)
  end

  # Custom Question
  (1..20).each do |i|
    author_id = rand(7) + 1
    CustomQuestion.find_or_create_by(author_id: author_id, content: Faker::Quotes::Shakespeare.romeo_and_juliet_quote)
  end

  (1..20).each do |i|
    custom_question = CustomQuestion.find(i)
    Entrance.find_or_create_by(channel: Channel.where(user_id: custom_question.author, name: '일촌').first, target: custom_question)
    Entrance.find_or_create_by(channel: Channel.where(user_id: custom_question.author, name: '이촌').first, target: custom_question)
    Entrance.find_or_create_by(channel: Channel.where(user_id: custom_question.author, name: '삼촌').first, target: custom_question)
    Entrance.find_or_create_by(channel: Channel.where(user_id: custom_question.author, name: '익명피드').first, target: custom_question)
  end

  # Repost
  (1..10).each do |i|
    author_id = rand(7) + 1
    ancestor_id = rand(20) + 1
    CustomQuestion.find_or_create_by(author_id: author_id, content: CustomQuestion.find(ancestor_id).content, repost_message: Faker::TvShows::Friends.quote, ancestor_id: ancestor_id)
  end

  (21..30).each do |i|
    custom_question = CustomQuestion.find(i)
    Entrance.find_or_create_by(channel: Channel.where(user_id: custom_question.author, name: '일촌').first, target: custom_question)
    Entrance.find_or_create_by(channel: Channel.where(user_id: custom_question.author, name: '이촌').first, target: custom_question)
    Entrance.find_or_create_by(channel: Channel.where(user_id: custom_question.author, name: '삼촌').first, target: custom_question)
    Entrance.find_or_create_by(channel: Channel.where(user_id: custom_question.author, name: '익명피드').first, target: custom_question)
  end

  # Comment
  (1..120).each do |i|
    author_id = rand(7) + 1
    Comment.find_or_create_by(author_id: author_id, content: Faker::Movies::HarryPotter.quote)
  end

  # Reply
  (1..60).each do |i|
    author_id = rand(7) + 1
    Reply.find_or_create_by(author_id: author_id, content: Faker::TvShows::HowIMetYourMother.catch_phrase)
  end

  # Like
  (1..100).each do |i|
    user_id = rand(7) + 1
    target_id = rand(20) + 1
    Like.find_or_create_by(user_id: user_id, target: Answer.find(target_id))
  end

  (1..100).each do |i|
    user_id = rand(7) + 1
    target_id = rand(20) + 1
    Like.find_or_create_by(user_id: user_id, target: Post.find(target_id))
  end

  (1..100).each do |i|
    user_id = rand(7) + 1
    target_id = rand(20) + 1
    Like.find_or_create_by(user_id: user_id, target: CustomQuestion.find(target_id))
  end

  # Drawer
  (1..100).each do |i|
    user_id = rand(7) + 1
    target_id = rand(20) + 1
    Drawer.find_or_create_by(user_id: user_id, target: Answer.find(target_id))
  end

  (1..100).each do |i|
    user_id = rand(7) + 1
    target_id = rand(20) + 1
    Drawer.find_or_create_by(user_id: user_id, target: Post.find(target_id))
  end

  (1..100).each do |i|
    user_id = rand(7) + 1
    target_id = rand(20) + 1
    Drawer.find_or_create_by(user_id: user_id, target: CustomQuestion.find(target_id))
  end

  # 어드민 질문 태그 검색 테스트용
  q = Question.first
  q.tag_string = "닐리리야\n에헤라\n디야\n태그"
  q.save
  Question.first.tags << Tag.create(author_id: 1, content: '닐리리야', target: Question.first)
  Question.first.tags << Tag.create(author_id: 1, content: '에헤라', target: Question.first)
  Question.first.tags << Tag.create(author_id: 1, content: '디야', target: Question.first)
  Question.first.tags << Tag.create(author_id: 1, content: '태그', target: Question.first)

  # 커스텀 질문 태그 검색 테스트용
  q = Question.find(2)
  q.tag_string = "뿌잉\n삉삉\n뀨\n뀨뀨꺄꺆ㄲ\n태그"
  q.save
  Question.find(2).tags << Tag.create(author_id: 6, content: '뿌잉', target: Question.find(2))
  Question.find(2).tags << Tag.create(author_id: 6, content: '삉삉', target: Question.find(2))
  Question.find(2).tags << Tag.create(author_id: 6, content: '뀨', target: Question.find(2))
  Question.find(2).tags << Tag.create(author_id: 6, content: '뀨뀨꺄꺆ㄲ', target: Question.find(2))
  Question.find(2).tags << Tag.create(author_id: 6, content: '태그', target: Question.find(2))

  # 나+친구 답변 태그 검색 테스트용
  a = Answer.where(author_id: 1).first
  a.tag_string = "삽질왕 김삽질\n삽질왕 이삽질\n삽질왕 구삽질\n태그"
  a.save
  a.tags << Tag.create(author_id: 6, content: '삽질왕 김삽질', target: a)
  a.tags << Tag.create(author_id: 6, content: '삽질왕 이삽질', target: a)
  a.tags << Tag.create(author_id: 6, content: '삽질왕 구삽질', target: a)
  a.tags << Tag.create(author_id: 6, content: '태그', target: a)

  # 익명 답변 태그 검색 테스트용
  a = Answer.where(author_id: 6).first
  a.tag_string = "나는 태그다\n너는 태그냐\n와썹맨"
  a.save
  a.tags << Tag.create(author_id: 6, content: '나는 태그다', target: a)
  a.tags << Tag.create(author_id: 6, content: '너는 태그냐', target: a)
  a.tags << Tag.create(author_id: 6, content: '와썹맨', target: a)

elsif Rails.env.production?

  if User.where(email: 'adoor.team@gmail.com').empty?
    User.create(email: 'adoor.team@gmail.com', password: 'adoor2019', username: '관리자')
  end
  u = User.find(1)
  u.image = Rails.root.join('app/assets/images/logo/final-app-logo.png').open
  u.skip_confirmation!
  u.save!
end

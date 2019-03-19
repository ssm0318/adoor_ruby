# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Faker gem을 사용하기 때문에 create가 제대로 먹히지 않아요. db:drop을 한 후에 db:seed를 해야합니다.
if Rails.env.development?
  # User
  # 1: 백산수, 2: 마틸다, 3:율로몬, 4: 잡동사니, 5: 이룰렁, 6: 누구게, 7: 메롱
  if User.where(email: 'prism@snu.com').empty?
    User.create(email: 'prism@snu.com', password: 'prism-snu', username: 'sansoo', confirmed_at: Time.now)
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
    User.create(email: 'f@f.com', password: 'ffffff', username: 'merong', confirmed_at: Time.now)
  end

  # Question
  (1..10).each do |i|
    q = Question.create(content: Faker::TvShows::Simpsons.quote)
    if i <= 5
      q.selected_date = Time.now
      q.save
    end
  end

  # Friend Request
  FriendRequest.create(requester_id: 1, requestee_id: 6)
  FriendRequest.create(requester_id: 3, requestee_id: 6)
  FriendRequest.create(requester_id: 4, requestee_id: 7)

  # Friendship
  Friendship.create(user_id: 1, friend_id: 2)
  Friendship.create(user_id: 1, friend_id: 3)
  Friendship.create(user_id: 1, friend_id: 4)
  Friendship.create(user_id: 1, friend_id: 5)
  Friendship.create(user_id: 2, friend_id: 3)
  Friendship.create(user_id: 2, friend_id: 4)
  Friendship.create(user_id: 2, friend_id: 5)
  Friendship.create(user_id: 3, friend_id: 4)
  Friendship.create(user_id: 3, friend_id: 5)
  Friendship.create(user_id: 4, friend_id: 5)

  # Assignment
  Assignment.create(target: Question.find(2), assigner_id: 1, assignee_id: 4)
  Assignment.create(target: Question.find(2), assigner_id: 2, assignee_id: 4)
  Assignment.create(target: Question.find(2), assigner_id: 1, assignee_id: 2)
  Assignment.create(target: Question.find(1), assigner_id: 2, assignee_id: 3)

  # Answer
  (1..20).each do |i|
    author_id = rand(7) + 1
    question_id = rand(5) + 1
    a = Answer.create(author_id: author_id, question_id: question_id, content: Faker::Quote.most_interesting_man_in_the_world)
    puts a.errors.full_messages
  end

  # Post
  (1..20).each do |i|
    author_id = rand(7) + 1
    Post.create(author_id: author_id, content: Faker::TvShows::SiliconValley.quote)
  end

  # Custom Question
  (1..20).each do |i|
    author_id = rand(7) + 1
    CustomQuestion.create(author_id: author_id, content: Faker::Quotes::Shakespeare.romeo_and_juliet_quote)
  end

  # Repost
  (1..10).each do |i|
    author_id = rand(7) + 1
    ancestor_id = rand(20) + 1
    CustomQuestion.create(author_id: author_id, content: CustomQuestion.find(ancestor_id).content, repost_message: Faker::TvShows::Friends.quote, ancestor_id: ancestor_id)
  end

  # Comment
  (1..60).each do |i|
    author_id = rand(7) + 1
    target_id = rand(20) + 1
    if Answer.find(target_id).author.friends.include? User.find(author_id)
      anonymous = false
    else
      anonymous = true
    end
    c = Comment.create(author_id: author_id, content: Faker::Movies::HarryPotter.quote, target: Answer.find(target_id), anonymous: anonymous)
    if i % 5 == 0
      c.secret = true
    end
    c.save
  end

  (1..60).each do |i|
    author_id = rand(7) + 1
    target_id = rand(20) + 1
    if Post.find(target_id).author.friends.include? User.find(author_id)
      anonymous = false
    else
      anonymous = true
    end
    c = Comment.create(author_id: author_id, content: Faker::Movies::HarryPotter.quote, target: Post.find(target_id), anonymous: anonymous)
    if i % 5 == 0
      c.secret = true
    end
    c.save
  end

  (1..60).each do |i|
    author_id = rand(7) + 1
    target_id = rand(20) + 1
    if CustomQuestion.find(target_id).author.friends.include? User.find(author_id)
      anonymous = false
    else
      anonymous = true
    end
    c = Comment.create(author_id: author_id, content: Faker::Movies::HarryPotter.quote, target: CustomQuestion.find(target_id), anonymous: anonymous)
    if i % 5 == 0
      c.secret = true
    end
    c.save
  end

  # Reply
  (1..100).each do |i|
    author_id = rand(7) + 1
    comment_id = rand(150) + 1
    if Comment.find(comment_id).anonymous?
      anonymous = true
    else
      anonymous = false
    end

    r = Reply.create(author_id: author_id, comment_id: comment_id, content: Faker::TvShows::HowIMetYourMother.catch_phrase, anonymous: anonymous)
    if i % 5 == 0
      r.secret = true
    end
    if i % 4 == 0
      if author_id != r.comment.author_id
        r.target_author_id = r.comment.author_id
      end
    end
    r.save
  end

  # Like
  (1..100).each do |i|
    user_id = rand(7) + 1
    target_id = rand(20) + 1
    Like.create(user_id: user_id, target: Answer.find(target_id))
  end

  (1..100).each do |i|
    user_id = rand(7) + 1
    target_id = rand(20) + 1
    Like.create(user_id: user_id, target: Post.find(target_id))
  end

  (1..100).each do |i|
    user_id = rand(7) + 1
    target_id = rand(30) + 1
    Like.create(user_id: user_id, target: CustomQuestion.find(target_id))
  end

  # Drawer
  (1..100).each do |i|
    user_id = rand(7) + 1
    target_id = rand(20) + 1
    Drawer.create(user_id: user_id, target: Answer.find(target_id))
  end

  (1..100).each do |i|
    user_id = rand(7) + 1
    target_id = rand(20) + 1
    Drawer.create(user_id: user_id, target: Post.find(target_id))
  end

  (1..100).each do |i|
    user_id = rand(7) + 1
    target_id = rand(30) + 1
    Drawer.create(user_id: user_id, target: CustomQuestion.find(target_id))
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

  # Entrance
  (1..20).each do |i|
    answer = Answer.find(i)
    Entrance.create(channel: Channel.where(user_id: answer.author, name: '일촌').first, target: answer)
    Entrance.create(channel: Channel.where(user_id: answer.author, name: '이촌').first, target: answer)
    Entrance.create(channel: Channel.where(user_id: answer.author, name: '삼촌').first, target: answer)
    Entrance.create(channel: Channel.where(user_id: answer.author, name: '익명피드').first, target: answer)
  end

  (1..20).each do |i|
    post = Post.find(i)
    Entrance.create(channel: Channel.where(user_id: post.author, name: '일촌').first, target: post)
    Entrance.create(channel: Channel.where(user_id: post.author, name: '이촌').first, target: post)
    Entrance.create(channel: Channel.where(user_id: post.author, name: '삼촌').first, target: post)
    Entrance.create(channel: Channel.where(user_id: post.author, name: '익명피드').first, target: post)
  end
  
  (1..30).each do |i|
    custom_question = CustomQuestion.find(i)
    Entrance.create(channel: Channel.where(user_id: custom_question.author, name: '일촌').first, target: custom_question)
    Entrance.create(channel: Channel.where(user_id: custom_question.author, name: '이촌').first, target: custom_question)
    Entrance.create(channel: Channel.where(user_id: custom_question.author, name: '삼촌').first, target: custom_question)
    Entrance.create(channel: Channel.where(user_id: custom_question.author, name: '익명피드').first, target: custom_question)
  end

elsif Rails.env.production?

  if User.where(email: 'adoor.team@gmail.com').empty?
    User.create(email: 'adoor.team@gmail.com', password: 'adoor2019', username: '관리자')
  end
  u = User.find(1)
  u.image = Rails.root.join('app/assets/images/logo/final-app-logo.png').open
  u.skip_confirmation!
  u.save!
end

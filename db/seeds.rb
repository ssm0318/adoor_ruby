# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Question.delete_all
# FriendRequest.delete_all
# Friendship.delete_all
# Assignment.delete_all
# Answer.delete_all
# Highlight.delete_all
# Comment.delete_all
# Tmi.delete_all
# Star.delete_all
if User.where(email: "prism@snu.com").empty?
    User.create(email: "prism@snu.com", password: "prism-snu", username: "백산수")
end
if User.where(email: "a@a.com").empty?
    User.create(email: "a@a.com", password: "aaaaaa", username: "마틸다")
end
if User.where(email: "b@b.com").empty?
    User.create(email: "b@b.com", password: "bbbbbb", username: "율로몬")
end
if User.where(email: "c@c.com").empty?
    User.create(email: "c@c.com", password: "cccccc", username: "잡동사니")
end
if User.where(email: "d@d.com").empty?
    User.create(email: "d@d.com", password: "dddddd", username: "이룰렁")
end
if User.where(email: "e@e.com").empty?
    User.create(email: "e@e.com", password: "eeeeee", username: "누구게")
end
if User.where(email: "f@f.com").empty?
    User.create(email: "f@f.com", password: "ffffff", username: "메롱")
end
# User.find_or_create_by(email: "a@a.com", password: "aaaaaa", username: "마틸다")
# User.find_or_create_by(email: "b@b.com", password: "bbbbbb", username: "율로몬")
# User.find_or_create_by(email: "c@c.com", password: "cccccc", username: "잡동사니")
# User.find_or_create_by(email: "d@d.com", password: "dddddd", username: "이룰렁")

Question.find_or_create_by(content: "마무리") # 디폴트로 admin이 생성한 것으로 되는지 확인
Question.find_or_create_by(content: "꿈", author_id: 6)

# FriendRequest.find_or_create_by(requester_id: 1, requestee_id: 2)
# FriendRequest.find_or_create_by(requester_id: 1, requestee_id: 3)
# FriendRequest.find_or_create_by(requester_id: 2, requestee_id: 4)

# Friendship.find_or_create_by(user_id: 1, friend_id: 2)
# Friendship.find_or_create_by(user_id: 1, friend_id: 3)
# Friendship.find_or_create_by(user_id: 1, friend_id: 4)
# Friendship.find_or_create_by(user_id: 1, friend_id: 5)
# Friendship.find_or_create_by(user_id: 2, friend_id: 3)
# Friendship.find_or_create_by(user_id: 2, friend_id: 4)
# Friendship.find_or_create_by(user_id: 2, friend_id: 5)
# Friendship.find_or_create_by(user_id: 3, friend_id: 4)
# Friendship.find_or_create_by(user_id: 3, friend_id: 5)
# Friendship.find_or_create_by(user_id: 4, friend_id: 5)

Assignment.find_or_create_by(question_id: 2, assigner_id: 1, assignee_id: 4)
Assignment.find_or_create_by(question_id: 2, assigner_id: 2, assignee_id: 4)
Assignment.find_or_create_by(question_id: 2, assigner_id: 1, assignee_id: 2)
Assignment.find_or_create_by(question_id: 1, assigner_id: 2, assignee_id: 3)

Answer.find_or_create_by(author_id: 5, question_id: 1, content: "내가 제일 못하는거!!!!!!!!!!!!!!!!\n
항상 뭐 시작하는건 되게 잘하는데 꾸준한게 없어서 끝을 마무리를 잘 못 짓는다.\n
그래서 요즘은 어떤 일을 시작할지 말지 결정할 때 내가 과연 이걸 끝까지 할 수 있을지 시뮬레이션을 상상속으로 해본다. 그래서 요즘은 시작한 일이 없다!ㅋ
") # assiger인 2번 유저에게 노티 보내져야함.
Answer.find_or_create_by(author_id: 2, question_id: 1, content: "내 하루의 마무리는 침대 옆의 켜져있던 장스탠드를 끄는 일이다.\n
잠들기 직전 장스탠드를 켜 놓으면 노란빛이 마음을 편하게 해주어서 잠이 잘오기 때문이다.\n
무엇보다 불을 끄러 일어나지 않아도 돼서 좋다.")
Answer.find_or_create_by(author_id: 1, question_id: 2, content: "존~~~~~~~~~~~~~~~~~~~~~~~~~~~~~나 좋은 스피커를 사서 개좋은 음질의 음악을 엄청 고요한 방에서 혼자 빵빵하게 틀어놓고 조용히 누워서 듣고 싶다. 개행복할듯.")
Answer.find_or_create_by(author_id: 4, question_id: 2, content: "높은 곳에서 뛰어내리기, 맨몸으로 날기") # assigner인 1번과 2번 유저에게 노티 보내져야함.
Answer.find_or_create_by(author_id: 3, question_id: 3, content: "중학교 때는 빨리 할머니가 되고싶었다. 빨리 현명한 할머니가 돼서 흰 머리를 휘날리며 “음.. 그래 그땐 내가 그랬었지... 참 어리석었군.. 허허”하면서 지난 날을 돌아보고 싶었다. 눈앞에 놓인 것들을 헤쳐나갈 자신이 없었던 것 같다. 역시 나는 도망치려고 태어났나보다. 대학생 이후로 나이를 먹는 건 항상 싫은 일이라고만 생각했다. 근데 돌아보면 나는 새내기 때보다 지금이 훨씬 좋다. 몰랐던 것들을 알게 되고, 나와 더 친해져서 좋다. 그렇게 생각하면 30대, 40대, 할머니가 되는 것도 그렇게 두려운 일은 아니지 않을까? 그 때는 또 그 때만의 재미와 새로움이 있겠지!! 
")
Answer.find_or_create_by(author_id: 4, question_id: 3, content: "젊은 건 아니고 어린데\n내 나이를 생각하기 싫다
\n도대체 20살인지 21살인지 22살인지\n
저번 생일 때는 내 생일 케이크에 초를 꽂지 말자고 하려다가 말았다
") 
Answer.find_or_create_by(author_id: 2, question_id: 4, content: "눈썹타투를 하는 시간. 요즘 눈썹 타투의 편리함에 빠져서 4일에 한 번 꼴로 눈썹을 그리고 잔다.
앞머리가 있지만 눈썹은 포기 하기 힘들다.
")
Answer.find_or_create_by(author_id: 2, question_id: 5, content: "어렸을 땐 발이 바닥에 닫는 깊이를 좋아했는데, 지금은 발이 닫지 않고 폭 잠기는 깊이가 좋다.
그래도 전혀 가늠할 수 없는 깊이는 좀 무섭다.
")
Answer.find_or_create_by(author_id: 3, question_id: 7, content: "
작년 이맘때는 열심히 유럽 여행 중이었지! 나는 매번 새로운 일을 하고 새로운 사람을 만나면 많이 배우는 편이니까 그 때의 나와 지금의 나는 많이 다르겠지! 그 중에 가장 많이 바뀐 건 역시 채식과 페미니즘에 눈을 뜬 것 그리고 외모강박을 이해하고 나를 용서할 수 있게 된 것일 게다! 내가 믿는 가치의 형체를 좀 더 정확히 보고 알 수 있게 된 느낌이라 너무 좋다.
")
Answer.find_or_create_by(author_id: 4, question_id: 7, content: "올해 처음으로 나의 과거가 나와 분리되는 것을 느꼈다. 유치원 때의 나는 더 이상 내가 아니다. 예전엔 그것도 나였는데. 과거의 나를 이해할 수 없게 되었다. 그 때의 나는 내가 아닌가? 끔찍
")
Answer.find_or_create_by(author_id: 3, question_id: 8, content: "과분하기 전에 피했다.")
Answer.find_or_create_by(author_id: 5, question_id: 10, content: "충분히 쉬고 시작할 수 있어서 좋다. 이번 학기 불태울 다짐이 되어있다!!!!!
그런데 우선 학기 초에 교수님께 초안지 받아달라고 존버해야된다. 4학년의 라이프가 이렇게 힘들지 몰랐다ㅠ")
Answer.find_or_create_by(author_id: 2, question_id: 10, content: "만족스러웠다. 첫날 강의들의 교수님이 다들 열정적이시고 좋은 분 같았다. 로드가 많을까 걱정이 되긴 하지만 많이 배울 수 있는 학기가 될 수 있을 것 같다.
또, 프리즘이 개강 후 처음으로 모여서 편안한 시간을 보낸게 만족스러웠다.")
Answer.find_or_create_by(author_id: 1, question_id: 11, content: "저절로, 습관대로 행동하고 생각하고 말하게 되는 순간이 무섭다. 나는 나를 믿지 못한다.")
Answer.find_or_create_by(author_id: 5, question_id: 11, content: "세상에 저절로 되는 일은 없다. \n뻔한 말이지만 기회는 준비된 사람한테만 오는거다. \n저절로 되기만을 바라고 그냥 기다리는건 양아치다.
")
Answer.find_or_create_by(author_id: 6, question_id: 1, content: "마무으리!")
Answer.find_or_create_by(author_id: 7, question_id: 1, content: "마무리 마유리")
Answer.find_or_create_by(author_id: 6, question_id: 2, content: "뿡")
Answer.find_or_create_by(author_id: 7, question_id: 2, content: "꺅")
Answer.find_or_create_by(author_id: 6, question_id: 3, content: "스물다섯쨜")
Answer.find_or_create_by(author_id: 7, question_id: 3, content: "존나 많아")
Answer.find_or_create_by(author_id: 6, question_id: 4, content: "zinzi")
Answer.find_or_create_by(author_id: 7, question_id: 4, content: "진지잡수세여")


# Highlight 모델을 어떻게?
Highlight.find_or_create_by(user_id: 2, answer_id: 3, content: "좋은 스피커를 사서")
Highlight.find_or_create_by(user_id: 2, answer_id: 1, content: "시작하는건 되게 잘하는데 꾸준한게 없어서")
Highlight.find_or_create_by(user_id: 3, answer_id: 6, content: "초를 꽂지 말자고")
Highlight.find_or_create_by(user_id: 1, answer_id: 4, content: "높은 곳에서")
Highlight.find_or_create_by(user_id: 3, answer_id: 14, content: "저절로, 습관대로 행동하고 생각하고 말하게 되는 순간이 무섭다.")
Highlight.find_or_create_by(user_id: 3, answer_id: 12, content: "충분히 쉬고 시작할 수 있어서 좋다.")
Highlight.find_or_create_by(user_id: 3, answer_id: 15, content: "세상에 저절로 되는 일은 없다.")

Comment.find_or_create_by(author_id: 2, recipient_id: 2, answer_id: 1, content: "oh really?")
Comment.find_or_create_by(author_id: 3, recipient_id: 3, answer_id: 3, content: "awesome!")
Comment.find_or_create_by(author_id: 3, recipient_id: 3, answer_id: 4, content: "same.")
Comment.find_or_create_by(author_id: 4, recipient_id: 4, answer_id: 5, content: "be a butterfly")
Comment.find_or_create_by(author_id: 1, recipient_id: 1, answer_id: 1, content: "그랬구나~")
Comment.find_or_create_by(author_id: 2, recipient_id: 2, answer_id: 5, content: "그런 일이 있었다니 몰랐네.")
Comment.find_or_create_by(author_id: 3, recipient_id: 3, answer_id: 16, content: "아하~")
Comment.find_or_create_by(author_id: 7, recipient_id: 7, answer_id: 16, content: "오~")
Comment.find_or_create_by(author_id: 3, recipient_id: 3, answer_id: 22, content: "아하~")
Comment.find_or_create_by(author_id: 7, recipient_id: 7, answer_id: 22, content: "오~")
Comment.find_or_create_by(author_id: 3, recipient_id: 3, answer_id: 17, content: "아하~")
Comment.find_or_create_by(author_id: 6, recipient_id: 6, answer_id: 17, content: "오~")
Comment.find_or_create_by(author_id: 3, recipient_id: 3, answer_id: 23, content: "아하~")
Comment.find_or_create_by(author_id: 6, recipient_id: 6, answer_id: 23, content: "오~")

Tmi.find_or_create_by(author_id: 1, content: "I want bingsu.")
Tmi.find_or_create_by(author_id: 1, content: "writing TMIs")
Tmi.find_or_create_by(author_id: 1, content: "no shit yet today")
Tmi.find_or_create_by(author_id: 2, content: "I love soccer")
Tmi.find_or_create_by(author_id: 2, content: "I have an iPad.")
Tmi.find_or_create_by(author_id: 3, content: "I want to get a Macbook Pro.")
Tmi.find_or_create_by(author_id: 3, content: "Bangna came visit me yesterday")
Tmi.find_or_create_by(author_id: 3, content: "two lovely chihuahuas")
Tmi.find_or_create_by(author_id: 3, content: "salmon sushi ftw")
Tmi.find_or_create_by(author_id: 4, content: "406 sucks")

Star.find_or_create_by(user_id: 1, target: Question.find(1))
Star.find_or_create_by(user_id: 1, target: Question.find(2))
Star.find_or_create_by(user_id: 1, target: Answer.find(1))
Star.find_or_create_by(user_id: 3, target: Question.find(1))
Star.find_or_create_by(user_id: 3, target: Answer.find(3))

# 어드민 질문 태그 검색 테스트용
Question.first.tag_string = "닐리리야\n에헤라\n디야\n태그"
Question.first.save
Question.first.tags << Tag.create(author_id: 1, content: "닐리리야", target: Question.first)
Question.first.tags << Tag.create(author_id: 1, content: "에헤라", target: Question.first)
Question.first.tags << Tag.create(author_id: 1, content: "디야", target: Question.first)
Question.first.tags << Tag.create(author_id: 1, content: "태그", target: Question.first)

# 커스텀 질문 태그 검색 테스트용
Question.find(2).tag_string = "뿌잉\n삉삉\n뀨\n뀨뀨꺄꺆ㄲ\n태그"
Question.find(2).save
Question.find(2).tags << Tag.create(author_id: 6, content: "뿌잉", target: Question.find(2))
Question.find(2).tags << Tag.create(author_id: 6, content: "삉삉", target: Question.find(2))
Question.find(2).tags << Tag.create(author_id: 6, content: "뀨", target: Question.find(2))
Question.find(2).tags << Tag.create(author_id: 6, content: "뀨뀨꺄꺆ㄲ", target: Question.find(2))
Question.find(2).tags << Tag.create(author_id: 6, content: "태그", target: Question.find(2))

# 나+친구 답변 태그 검색 테스트용
a = Answer.where(author_id: 1).first
a.tag_string = "삽질왕 김삽질\n삽질왕 이삽질\n삽질왕 구삽질\n태그"
a.save
a.tags << Tag.create(author_id: 6, content: "삽질왕 김삽질", target: a)
a.tags << Tag.create(author_id: 6, content: "삽질왕 이삽질", target: a)
a.tags << Tag.create(author_id: 6, content: "삽질왕 구삽질", target: a)
a.tags << Tag.create(author_id: 6, content: "태그", target: a)

# 익명 답변 태그 검색 테스트용
a = Answer.where(author_id: 6).first
a.tag_string = "나는 태그다\n너는 태그냐\n와썹맨"
a.save
a.tags << Tag.create(author_id: 6, content: "나는 태그다", target: a)
a.tags << Tag.create(author_id: 6, content: "너는 태그냐", target: a)
a.tags << Tag.create(author_id: 6, content: "와썹맨", target: a)
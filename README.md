# DailyRecord
일기장 어플
당일 이외의 기록은 삭제만 가능

- 소셜 로그인 구현 (apple, google)
- Friebase Firestore, Storage 사용. 유저별로 작성한 일기를 Firestore에 저장 이미지는 Storage에 올리고 링크만 따로 Firestore에 저장 후 사용했습니다.
- Storyboard SwiftUI 화면 함께 사용 (Login, Home 뷰 제외, 나머지는 SwiftUI로 작업)
- UIKit에 Combine을 사용해 MVVM 구조 구현

## 사용 기술
- MVVM Architecture
- StoryBoard + SwiftUI
- Combine
- PhotosUI
- Swift Concurrency (async/await)
- UICollectionViewDiffableDataSource

## 사용 라이브러리
- Firebase Auth
- Firebase Firestore
- Firebase Storage

## Preview

| Login | Home | Detail |
| ------------- | ------------- | ------------- |
| ![image](https://github.com/JustHm/DailyRecord/assets/21167914/bda909dc-f1c7-4e32-872c-dcc6a2a4852e) | ![IMG_7300](https://github.com/JustHm/DailyRecord/assets/21167914/8dc712dc-a86b-4bc5-9bd7-a09f1d711269) | ![IMG_7304](https://github.com/JustHm/DailyRecord/assets/21167914/1c6dca80-ca6d-41e8-a231-ed2aeb83cde8) |

| Add  | Settings | Info |
| ------------- | ------------- | ------------- |
| ![IMG_7312](https://github.com/JustHm/DailyRecord/assets/21167914/bfc0507a-38e8-4f13-83e7-6477b2befb1e) | ![IMG_7313](https://github.com/JustHm/DailyRecord/assets/21167914/b026362e-b266-486e-8a09-cd829f0b2e93) | ![IMG_7314](https://github.com/JustHm/DailyRecord/assets/21167914/7171efb9-ee03-45d2-9492-8cbcb7886cbe) |

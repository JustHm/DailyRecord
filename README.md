# DailyRecord
<img width="1306" alt="앱 스크린샷 정렬된거" src="https://github.com/user-attachments/assets/ec9f1cac-620b-4a9f-8fff-b639ed616b78">

## 프로젝트 설명
> 개발 인원: 1명 (iOS)
> 
> 개발 기간: 2023년 5월 ~ 6월 (개발기간 1달)

- 일기장 어플
- 그 날의 일기를 쓰고 시간이 지나면 수정이 불가능
- 소셜 로그인 사용 (apple, google)

## 사용 기술
- MVVM Architecture, Combine

  > ViewController의 책임을 분리하고자 MVVM 도입
    Combine을 사용해 양방향 바인딩 구현
- StoryBoard + SwiftUI
  
  > Login, Home View를 제외하고 Detail, Setting은 SwiftUI로 제작
- Swift Concurrency (async/await)
  
  > Firebase Firestore, Storage를 사용해 일기를 업로드, 다운로드 할 때 사용
  >
  > 이미지를 먼저 Storage에 업로드 후 링크를 받아와 Firestore에 글과 함께 링크를 저장하는 작업을 하는데,
    다중 이미지를 더 빠르게 처리하기 위해 withThrowingTaskGroup 사용
    
- UICollectionViewDiffableDataSource
  > Compositional layout list를 사용해 디자인
  >
  > 서버에서 비동기로 데이터를 가져와 보여줄 때 DiffableDataSource를 사용해 데이터를 바인딩 시킴
  >
  > 비동기로 정렬이나 삭제, 추가 등 데이터를 변경해줘도 자연스러운 애니매이션을 기대할 수 있음.

- PhotosUI
  > 사용자 갤러리에 접근해 선택된 이미지를 불러오는 작업

## 사용 라이브러리
- Firebase Auth
- Firebase Firestore
- Firebase Storage

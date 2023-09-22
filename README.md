# Insu's TodoApp

## 📱 앱 간단소개

* 기존 UserDefault 에서 CoreData로 변경
* 기존 TodoList, Todo Add, Edit ViewController를 ViewModel로 나누어 ViewModel 내부는 크게 Input, Output, Logic 3가지로 분류하여 분기처리.
* ProfileViewController 추가 UI 구현 (ProfileHeader, ProfileViewController)
* PetViewController 에서 라이브러리 'Kingfisher' 를 이용하여 이미지 캐싱 처리 -> 이미지가 자동으로 캐싱 (로컬 이미지도 구현방법은 추후 구현)
* (추후 구현) Todo 앱 구성상 프로필 페이지가 들어간다고 할때, 기존 앱에서 연결성을 생각해보면, Todo를 추가할때 이미지를 추가 할수 있게 해서 프로필에 띄우는 작업까지 하려 했으니 추후 구현
* (추후 구현) 넷플릭스 처럼 멤버를 선택하여, 멤버별 Todo를 추가한 데이터를 불러올 수 있게 구현

<br>

| LaunchScreen -> HomeVC | HomeVC -> TodoListVC | HomeVC -> Todo완료VC |
| --------------- | --------------- | --------------- |
| <img src = "https://github.com/Insuuu24/Insu-TodoApp/assets/117909631/d3f35d0b-a67a-4d4a-895d-d7050fb930d8" width = "200" height = "400"/> | <img src = "https://github.com/Insuuu24/Insu-TodoApp/assets/117909631/7ba037a5-8b01-4e34-b449-e52cd9d993d1" width = "200" height = "400"/> | <img src = "https://github.com/Insuuu24/Insu-TodoApp/assets/117909631/51f536b6-3cc6-4cdd-8db7-d51994c83d04" width = "200" height = "400"/>  |

<br>

| Todo 추가 | PetViewController | ProfileViewController |
| --------------- | --------------- | --------------- |
| <img src = "https://github.com/Insuuu24/Insu-TodoApp/assets/117909631/d6a0e531-6b5b-413a-a669-86a157f4464d" width = "200" height = "400"/> | <img src = "https://github.com/Insuuu24/Insu-TodoApp/assets/117909631/a9649824-40ef-43f5-af9d-639f53ab714c" width = "200" height = "400"/> | <img src = "https://github.com/Insuuu24/Insu-TodoApp/assets/117909631/5ed2d2c2-c62d-40fb-806c-ef4b8a7c3ea3" width = "200" height = "400"/>

<br>

## 📚 개발 환경 및 라이브러리

### 개발 환경

[![UIKit](https://img.shields.io/badge/UIKit-iOS-black.svg?style=square)](https://swift.org) ![Xcode](https://img.shields.io/badge/Xcode-14.3.1-blue) ![swift](https://img.shields.io/badge/swift-5.8.1-orange) ![iOS](https://img.shields.io/badge/iOS-15.0-yellow)

### 라이브러리

| 라이브러리(Library) | 목적(Purpose)            | 버전(Version)                                                |
| ------------------- | ------------------------ | ------------------------------------------------------------ |
| SnapKit             | 오토레이아웃             | ![SnapKit](https://img.shields.io/badge/SnapKit-5.6.0-skyblue) |
| Then                | 짧은 코드 처리           | ![Then](https://img.shields.io/badge/Then-3.0.0-white) |
| KingFisher          | 이미지 캐싱              | ![Kingfisher](https://img.shields.io/badge/Kingfisher-7.9.1-orange)

<br>

## ⛓️ Architecture Pattern (MVVM)



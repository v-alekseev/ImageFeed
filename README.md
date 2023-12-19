# Image Feed 

Приложение было написано в рамках учебного курса "iOS-разработчик" от Яндекс Практикум.

## Стек
- вёрстка на сторибордах и вёрстка кодом с Auto Layout. [Дизайн](https://www.figma.com/file/HyDfKh5UVPOhPZIhBqIm3q/Image-Feed-(YP)?node-id=318-1469) в Figma.
- UITableView, UIScrollView
- URLSession и пагинация запросов
- многопоточность; предотвращение race condition (DispatchQueue, блокировка UI)
- Используется Kingfisher. Добавлена через SPM.
- реализация авторизации с OAuth 2.0.
- UI-тесты и Unit-тесты

## Описание
Многостраничное приложение с бесконечной лентой картинок с сервиса Unsplash. Частично верстка кодом. Архитектура MVP. Реализация авторизации с OAuth 2.0. Авторизация через WKWebView. Токен в храним в Keychain. Загрузка картинок через Kingfisher. Зависимости добавлены через SPM. Написаны UITests и UnitTests.
Главный экран состоит из ленты с изображениями (UITableView). Пользователь может просматривать ее, добавлять и удалять изображения из избранного. Каждое отдельное изображение можно открыить в отдельном окне и масштабировать (UIScrollView).

## Инструкция по использованию
Необходимо создать аккаунт на сайте [unsplash](https://unsplash.com) и зарегистрировать там свое приложение Image Feed. Затем в файле AuthConfiguration указать свои access_ket и secret_key, полученные после регистрации приложения

<img width="200" alt="image" src="https://github.com/v-alekseev/ImageFeed/blob/main/ImageFeed/Assets.xcassets/Images/Screenshots/image.imageset/2023-12-19_13-55-43.png"><img width="200"  alt="list" src="https://github.com/v-alekseev/ImageFeed/blob/main/ImageFeed/Assets.xcassets/Images/Screenshots/list.imageset/2023-12-19_13-54-56.png">

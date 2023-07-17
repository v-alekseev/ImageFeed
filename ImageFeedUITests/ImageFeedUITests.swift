//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Vitaly Alekseev on 15.07.2023.
//

import XCTest

class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        // тестируем сценарий авторизации
        
        // Нажать кнопку авторизации
        app.buttons["Authenticate"].tap()
        print(app.debugDescription)
        
        let webView = app.webViews["UnsplashWebView"]
        
        // Подождать, пока экран авторизации открывается и загружается
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        // Ввести данные в форму
        let loginTextField = webView.textFields.element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("---")
        print(app.debugDescription)
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        passwordTextField.tap()
        passwordTextField.typeText("---")
        
        
        // Нажать кнопку логина
        webView.buttons["Login"].tap()
        
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        
    }
    
    func testFeed2() throws {
        
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        //let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        let cell = tablesQuery.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        
        sleep(1)
//        // Сделать жест «смахивания» вверх по экрану для его скролла
        cell.swipeUp()
        //sleep(1)

        //let likeCell = tablesQuery.children(matching: .cell).element(boundBy: 1)
        let likeCell = tablesQuery.cells.element(boundBy: 1)
        print(app.debugDescription)
        XCTAssertTrue(likeCell.waitForExistence(timeout: 10))
        //likeCell/*@START_MENU_TOKEN@*/.buttons["LikeButton"]/*[[".buttons[\"favorits active\"]",".buttons[\"LikeButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        //sleep(2)
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        //let cell = tablesQuery.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        
        //sleep(1)
//        // Сделать жест «смахивания» вверх по экрану для его скролла
        cell.swipeUp()
        sleep(2)

        let likeCell = tablesQuery.children(matching: .cell).element(boundBy: 1)
        print(app.debugDescription)
        //XCTAssertTrue(likeCell.waitForExistence(timeout: 10))
        likeCell/*@START_MENU_TOKEN@*/.buttons["LikeButton"]/*[[".buttons[\"favorits active\"]",".buttons[\"LikeButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(2)
//
        print(app.debugDescription)
        // Отменить лайк в ячейке верхней картинки
        let button2 = likeCell/*@START_MENU_TOKEN@*/.buttons["LikeButton"]/*[[".buttons[\"favorits active\"]",".buttons[\"LikeButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        button2.tap()
        sleep(2)

        // Нажать на верхнюю ячейку
        likeCell.tap()

        // Подождать, пока картинка открывается на весь экран
        sleep(2)

        // Увеличить картинку
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in

        // Уменьшить картинку
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        // Вернуться на экран ленты

        let navBackButtonWhiteButton = app.buttons["BackToImageListButton"]
            navBackButtonWhiteButton.tap()

        
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
        
        // Подождать, пока открывается экран ленты
        XCTAssertTrue(app.tables.element.waitForExistence(timeout: 10))

       // Перейти на экран профиля
        app.tabBars.buttons.element(boundBy: 1).tap()
        
       // Проверить, что на нём отображаются ваши персональные данные
        XCTAssertTrue(app.staticTexts["NameLastname"].exists)
        XCTAssertTrue(app.staticTexts["username"].exists)
        
       // Нажать кнопку логаута
        app.buttons["LogoutButton"].tap()
        sleep(3)
        print(app.debugDescription)
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Выхожу точно"].tap()
        
        sleep(5)
       // Проверить, что открылся экран авторизации
        print(app.debugDescription)
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
        
    }
}

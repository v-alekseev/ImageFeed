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
        print("IMGTST webView.exists = \(webView.exists)")
        
        // Ввести данные в форму
        let loginTextField = webView.textFields.element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("***")
        print(app.debugDescription)
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        passwordTextField.tap()
        passwordTextField.typeText("***")
        
        
        // Нажать кнопку логина
        webView.buttons["Login"].tap()
        
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        
        print("cell text = \(cell.staticTexts.element.label)")
        print(app.debugDescription)
        
        let imagestableviewTable = app/*@START_MENU_TOKEN@*/.tables["ImagesTableView"]/*[[".otherElements[\"ImageListView\"].tables[\"ImagesTableView\"]",".tables[\"ImagesTableView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let likebuttonButton2 = imagestableviewTable.children(matching: .cell).element(boundBy: 1)/*@START_MENU_TOKEN@*/.buttons["LikeButton"]/*[[".buttons[\"favorits active\"]",".buttons[\"LikeButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let likebuttonButton22 = imagestableviewTable.children(matching: .cell).element(boundBy: 1)/*@START_MENU_TOKEN@*/.buttons["favorits active"]/*[[".buttons[\"favorits active\"]",".buttons[\"LikeButton\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        likebuttonButton2.tap()

        sleep(10)
        // Отменить лайк в ячейке верхней картинки
        // Нажать на верхнюю ячейку
        // Подождать, пока картинка открывается на весь экран
        // Увеличить картинку
        // Уменьшить картинку
        // Вернуться на экран ленты
        
        
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
    }
    func testRecord() {
        XCUIApplication().tables["ImagesTableView"].cells.containing(.staticText, identifier:"2 марта 2022 г.").buttons["LikeButton"].tap()
        
        let app = XCUIApplication()
        let imagestableviewTable = app/*@START_MENU_TOKEN@*/.tables["ImagesTableView"]/*[[".otherElements[\"ImageListView\"].tables[\"ImagesTableView\"]",".tables[\"ImagesTableView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let likebuttonButton = imagestableviewTable.cells.containing(.staticText, identifier:"2 марта 2022 г.")/*@START_MENU_TOKEN@*/.buttons["LikeButton"]/*[[".buttons[\"favorits active\"]",".buttons[\"LikeButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        likebuttonButton.tap()
        likebuttonButton.tap()
        likebuttonButton.tap()
        likebuttonButton.tap()
        
        let likebuttonButton2 = imagestableviewTable.children(matching: .cell).element(boundBy: 1)/*@START_MENU_TOKEN@*/.buttons["LikeButton"]/*[[".buttons[\"favorits active\"]",".buttons[\"LikeButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        likebuttonButton2.tap()
        likebuttonButton2.tap()
        likebuttonButton.tap()
        app.tabBars["Tab Bar"].buttons.containing(.image, identifier:"feed_active").element.tap()
        app/*@START_MENU_TOKEN@*/.icons["Команды"]/*[[".otherElements[\"Home screen icons\"]",".icons.icons[\"Команды\"]",".icons[\"Команды\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.otherElements["Home screen icons"].children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
                
    }
}

//
//  ShortenerUITests.swift
//  ShortenerUITests
//
//  Created by Piotr Pawluś on 31/03/16.
//  Copyright © 2016 Piotr Pawluś. All rights reserved.
//

import XCTest

class ShortenerUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAddLink() {
        let app = XCUIApplication()
        let addNewLinkTextField = app.textFields["Add New Link"]
        XCTAssert(addNewLinkTextField.exists, "addNewLinkTextField doesn't exist")

        addNewLinkTextField.tap()
        addNewLinkTextField.typeText("www.github.com")
        XCTAssertEqual(addNewLinkTextField.value as? String, "www.github.com", "addNewLinkTextField value is not correct")

        let addButton = app.buttons["+"]
        XCTAssert(addButton.exists, "addButton doesn't exist")
        addButton.tap()

        let menuButton = app.navigationBars["Shorten link"].buttons["menu"]
        XCTAssert(menuButton.exists, "menuButton doesn't exist")
        menuButton.tap()

        let tableQuery = app.tables
        let links = tableQuery.staticTexts["Links"]
        XCTAssert(links.exists, "Links in menu table doesn't exist")
        links.tap()
    }

    func testCountOfCellsAfterAddingLink() {
        let app = XCUIApplication()

        let menuButtonInShorten = app.navigationBars["Shorten link"].buttons["menu"]
        XCTAssert(menuButtonInShorten.exists, "menuButtonInShorten doesn't exist")
        menuButtonInShorten.tap()

        let tableQuery = app.tables
        let links = tableQuery.staticTexts["Links"]
        XCTAssert(links.exists, "Links in menu table doesn't exist")
        links.tap()

        let countCells = app.tables.cells.count

        let menuButtonInLinks = app.navigationBars["Links"].buttons["menu"]
        XCTAssert(menuButtonInLinks.exists, "menuButtonInLinks doesn't exist")
        menuButtonInLinks.tap()

        let shortenLink = tableQuery.staticTexts["Shorten link"]
        XCTAssert(shortenLink.exists, "shortenLink in menu table doesn't exist")
        shortenLink.tap()

        let addNewLinkTextField = app.textFields["Add New Link"]
        XCTAssert(addNewLinkTextField.exists, "addNewLinkTextField doesn't exist")

        addNewLinkTextField.tap()
        let link = "www.apple.com"
        addNewLinkTextField.typeText(link)
        XCTAssertEqual(addNewLinkTextField.value as? String, link, "addNewLinkTextField value is not correct")

        let addButton = app.buttons["+"]
        XCTAssert(addButton.exists, "addButton doesn't exist")
        addButton.tap()

        menuButtonInShorten.tap()
        links.tap()
        let countNewCells = app.tables.cells.count - UInt(1)

        XCTAssert(countCells == countNewCells , "Doesn't add new link.")
    }

    func testShouldNotAddLink() {
        let app = XCUIApplication()

        let menuButtonInShorten = app.navigationBars["Shorten link"].buttons["menu"]
        XCTAssert(menuButtonInShorten.exists, "menuButtonInShorten doesn't exist")
        menuButtonInShorten.tap()

        let tableQuery = app.tables
        let links = tableQuery.staticTexts["Links"]
        XCTAssert(links.exists, "Links in menu table doesn't exist")
        links.tap()

        let countCells = app.tables.cells.count

        let menuButtonInLinks = app.navigationBars["Links"].buttons["menu"]
        XCTAssert(menuButtonInLinks.exists, "menuButtonInLinks doesn't exist")
        menuButtonInLinks.tap()

        let shortenLink = tableQuery.staticTexts["Shorten link"]
        XCTAssert(shortenLink.exists, "shortenLink in menu table doesn't exist")
        shortenLink.tap()

        let addNewLinkTextField = app.textFields["Add New Link"]
        XCTAssert(addNewLinkTextField.exists, "addNewLinkTextField doesn't exist")

        addNewLinkTextField.tap()
        let link = "Apple"
        addNewLinkTextField.typeText(link)
        XCTAssertEqual(addNewLinkTextField.value as? String, link, "addNewLinkTextField value is not correct")

        let addButton = app.buttons["+"]
        XCTAssert(addButton.exists, "addButton doesn't exist")
        addButton.tap()

        menuButtonInShorten.tap()
        links.tap()
        let countNewCells = app.tables.cells.count

        XCTAssert(countCells == countNewCells , "Add new link.")
    }

}

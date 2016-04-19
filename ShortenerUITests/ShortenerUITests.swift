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
        let linkTextField = app.textFields["Add New Link"]
        linkTextField.tap()
        XCTAssert(linkTextField.exists, "LinkTextField don't exist")
        linkTextField.typeText("https://github.com/PiotrPawlus")
        let addButton = app.buttons["+"]
        addButton.tap()
        
        let menuButton = app.navigationBars["Shorten link"].buttons["menu"]
        menuButton.tap()
        let table = app.tables
        table.staticTexts["Links"].tap()
    }

}

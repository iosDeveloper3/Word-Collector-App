//
//  Word_CollectorUITests.swift
//  Word CollectorUITests
//
//  Created by Dawid Herman on 04/09/2022.
//

import XCTest

// swiftlint:disable all

class Word_CollectorUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEditedFileIsRefreshedInReadingMode() throws {
        
        let app = XCUIApplication()
        app.launch()

        app.navigationBars["Library"].children(matching: .button).element(boundBy: 1).tap()
                
        let fileNameTextField = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element
        fileNameTextField.tap()
        fileNameTextField.typeText("test0_file_name")
        
        let fileContentTextView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        fileContentTextView.tap()
        fileContentTextView.typeText("example")
        
        let createEditNavigationBar = app.navigationBars["Create / Edit"]
        createEditNavigationBar.buttons["Save this file"].tap()
        createEditNavigationBar.buttons["Library"].tap()
        
        app/*@START_MENU_TOKEN@*/.collectionViews/*[[".scrollViews.collectionViews",".collectionViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.cells["test0_file_name"].children(matching: .other).element.children(matching: .other).element.tap()
        app.navigationBars["test0_file_name"].buttons["Open this file for editing"].tap()
        fileContentTextView.tap()
        fileContentTextView.typeText("content ")
        
        createEditNavigationBar.buttons["Save this file"].tap()
        createEditNavigationBar.buttons["test0_file_name"].tap()
        
        XCTAssertTrue(app.collectionViews.staticTexts["content"].exists)
    }

    func testThereAreNoWordsConnectedToDeletedFiles() throws {
        
        let app = XCUIApplication()
        app.launch()

        app.navigationBars["Library"].children(matching: .button).element(boundBy: 1).tap()
                
        let fileNameTextField = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element
        fileNameTextField.tap()
        fileNameTextField.typeText("test_file")
        
        let fileContentTextView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        fileContentTextView.tap()
        fileContentTextView.typeText("A word")

        let createEditNavigationBar = app.navigationBars["Create / Edit"]
        createEditNavigationBar.buttons["Save this file"].tap()
        createEditNavigationBar.buttons["Library"].tap()
        
        app/*@START_MENU_TOKEN@*/.collectionViews/*[[".scrollViews.collectionViews",".collectionViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.cells["test_file"].children(matching: .other).element.children(matching: .other).element.tap()
        app/*@START_MENU_TOKEN@*/.collectionViews.staticTexts["word"]/*[[".scrollViews.collectionViews",".cells.staticTexts[\"word\"]",".staticTexts[\"word\"]",".collectionViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        
        app.buttons["Add to your vocabulary"].tap()
        app.navigationBars["test_file"].buttons["Open this file for editing"].tap()
        
        var monitor = addUIInterruptionMonitor(withDescription: "Possible data loss") { (alert) -> Bool in
            alert.buttons["Yes"].tap()
            return true
        }
        
        createEditNavigationBar.buttons["Delete this file"].tap()
        removeUIInterruptionMonitor(monitor)

        monitor = addUIInterruptionMonitor(withDescription: "Delete this file") { (alert) -> Bool in
            alert.buttons["Yes"].tap()
            return true
        }
        
        createEditNavigationBar.tap()

        app.navigationBars["Library"].buttons["Open Vocabulary Inspector"].tap()

        XCTAssertFalse(app.tables.staticTexts["word"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

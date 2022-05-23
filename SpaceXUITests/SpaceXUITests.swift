//
//  SpaceXUITests.swift
//  SpaceXUITests
//
//  Created by Rolando Rodriguez on 5/19/22.
//

import XCTest

class SpaceXUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }
    
    func testLoadingFlow() {
        let listBody = app.buttons["launchesList"]
        XCTAssertTrue(listBody.waitForExistence(timeout: 5))

        let loadedList = app.buttons["loadedList"]
        XCTAssertTrue(loadedList.waitForExistence(timeout: 1))
    }
    
    func testThatFilterMenuAppears() {
        let filterMenu = app.buttons["menu"]
        XCTAssertTrue(filterMenu.exists)
        
        filterMenu.tap()
    
        let ASCbutton = app.buttons["ASC"]
        XCTAssertTrue(ASCbutton.waitForExistence(timeout: 1))
    }
    
    func testThatYearSelectorAppears() {
        let filterMenu = app.buttons["menu"]
        XCTAssertTrue(filterMenu.exists)
        
        filterMenu.tap()
        
        let yearsButton = app.buttons["Years"]
        XCTAssertTrue(yearsButton.exists)
        
        yearsButton.tap()
        
        let allYearsButton = app.buttons["allYearsButton"]
        XCTAssertTrue(allYearsButton.exists)

    }
    
    func testFilteringAndActionSheetFlow() {
        let filterMenu = app.buttons["menu"]
        XCTAssertTrue(filterMenu.exists)
        
        filterMenu.tap()
        
        let yearsButton = app.buttons["Years"]
        XCTAssertTrue(yearsButton.exists)
        
        yearsButton.tap()
        
        let allYearsButton = app.buttons["allYearsButton"]
        XCTAssertTrue(allYearsButton.exists)
        
        let _2006Button  = app.buttons["2006"]
        XCTAssertTrue(_2006Button.exists)
        
        _2006Button.tap()
        
        let loadedList = app.buttons["launchesList"]
        XCTAssertTrue(loadedList.waitForExistence(timeout: 1))
        
        loadedList.tap()
                
        let watchVideoButton = app.buttons["Watch Video"]
        let openArticleButton = app.buttons["Watch Video"]
        let wikipediaButton = app.buttons["Watch Video"]
        
        XCTAssertTrue(watchVideoButton.exists)
        XCTAssertTrue(openArticleButton.exists)
        XCTAssertTrue(wikipediaButton.exists)
        
        watchVideoButton.tap()
        
        let webview = app.otherElements["webview"]
        
        XCTAssertTrue(webview.exists)
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

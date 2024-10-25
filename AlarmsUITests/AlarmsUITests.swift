//
//  AlarmsUITests.swift
//  AlarmsUITests
//
//  Created by joshmac on 10/25/24.
//

@testable import Alarms
import XCTest

@MainActor
final class AlarmsUITests: XCTestCase {
    private var application: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        application = XCUIApplication()
    }

    func testDatesListScreen() async throws {
        application.launch()
        XCTAssert(application.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["September 15, 2024 at 10:04 AM"]/*[[".cells.staticTexts[\"September 15, 2024 at 10:04 AM\"]",".staticTexts[\"September 15, 2024 at 10:04 AM\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
    }
    
    func testAlarmEntryScreen() async throws {
        application.launch()
        application/*@START_MENU_TOKEN@*/.buttons["plus"]/*[[".buttons[\"Add\"]",".buttons[\"plus\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(application.staticTexts["Add Alarm"].exists)
    }
}

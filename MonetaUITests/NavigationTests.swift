import XCTest

@MainActor
final class NavigationTests: XCTestCase {
    func testLaunchSwitchAndDragOppositeSurface() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment["MONETA_DISABLE_HOT_RELOAD"] = "1"
        app.launch()

        let calendar = app.buttons["calendar-tab"]
        let todos = app.buttons["todos-tab"]
        XCTAssertTrue(calendar.waitForExistence(timeout: 10))
        XCTAssertEqual(app.state, .runningForeground)
        XCTAssertTrue(calendar.isSelected)

        let panel = app.otherElements["main-panel"]
        XCTAssertTrue(panel.waitForExistence(timeout: 5))
        let collapsedPanelHeight = panel.frame.height
        todos.tap()
        XCTAssertTrue(todos.isSelected)
        XCTAssertTrue(panel.staticTexts["Todos"].exists)
        XCTAssertEqual(
            panel.frame.height, collapsedPanelHeight, accuracy: 2,
            "Switching tabs must not expand the drawer")

        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.86))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.40))
        start.press(forDuration: 0.1, thenDragTo: end)
        XCTAssertLessThan(panel.frame.height, collapsedPanelHeight - 100)
        XCTAssertTrue(
            app.staticTexts["Calendar"].isHittable,
            "The drawer should reveal Calendar when Todos is selected")

        end.press(forDuration: 0.1, thenDragTo: start)
        let collapsed = NSPredicate { _, _ in
            abs(panel.frame.height - collapsedPanelHeight) < 3
        }
        let expectation = XCTNSPredicateExpectation(predicate: collapsed, object: nil)
        XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 5), .completed)
    }
}

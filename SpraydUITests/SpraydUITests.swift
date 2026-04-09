//
//  SpraydUITests.swift
//  SpraydUITests
//
//  Created by Егор Мальцев on 31.03.2026.
//

import XCTest

final class SpraydUITests: XCTestCase {
    private func makeApp(startOnFeed: Bool = true) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += ["-ui-testing"]

        if startOnFeed {
            app.launchArguments += ["-ui-testing-start-feed"]
        }

        return app
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testFeedLaunchShowsSearchFieldAndFeaturedCard() throws {
        let app = makeApp()
        app.launch()

        XCTAssertTrue(app.scrollViews["feed.root"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.textFields["searchBar.textField"].exists)
        XCTAssertTrue(app.otherElements["feed.featuredCard"].exists)
    }

    @MainActor
    func testTappingFeaturedCardOpensArtObjectScreen() throws {
        let app = makeApp()
        app.launch()

        let featuredCard = app.otherElements["feed.featuredCard"]
        XCTAssertTrue(featuredCard.waitForExistence(timeout: 5))

        featuredCard.tap()

        XCTAssertTrue(app.otherElements["artObject.root"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testFeedLaunchCapturesScreenshot() throws {
        let app = makeApp()
        app.launch()

        XCTAssertTrue(app.otherElements["feed.featuredCard"].waitForExistence(timeout: 5))

        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "FeedLaunch"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

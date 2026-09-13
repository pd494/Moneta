import SnapshotTesting
import SwiftUI
import XCTest

@testable import Moneta

@MainActor
final class SnapshotTests: XCTestCase {
    func testCalendarCompactAndLargeText() {
        // Stable date, locale, size, and traits make intentional visual changes reviewable.
        let date = Date(timeIntervalSince1970: 1_789_171_200)
        for category in [UIContentSizeCategory.large, .accessibilityExtraExtraExtraLarge] {
            let view = CalendarView(date: date)
                .padding(24)
                .background(Color.monetaPaper)
                .environment(\.colorScheme, .light)
                .environment(\.locale, Locale(identifier: "en_US"))
                .environment(\.timeZone, TimeZone(secondsFromGMT: 0)!)
            assertSnapshot(
                of: UIHostingController(rootView: view),
                as: .image(
                    precision: 0.99, size: CGSize(width: 375, height: 600),
                    traits: UITraitCollection(preferredContentSizeCategory: category)),
                named: category == .large ? "compact" : "large-text",
                record: ProcessInfo.processInfo.environment["RECORD_SNAPSHOTS"] == "1"
                    ? .all : .never
            )
        }
    }

    func testTodosInDarkDrawer() {
        let view = TodosView()
            .padding(24)
            .background(Color.monetaBlack)
            .environment(\.colorScheme, .dark)
            .environment(\.locale, Locale(identifier: "en_US"))
        assertSnapshot(
            of: UIHostingController(rootView: view),
            as: .image(precision: 0.99, size: CGSize(width: 375, height: 500)),
            record: ProcessInfo.processInfo.environment["RECORD_SNAPSHOTS"] == "1" ? .all : .never
        )
    }
}

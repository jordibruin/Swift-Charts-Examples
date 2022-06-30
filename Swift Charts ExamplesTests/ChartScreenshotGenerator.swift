//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import XCTest
import SwiftUI
@testable import Swift_Charts_Examples

final class ChartScreenshotGenerator: XCTestCase {
    @MainActor
    func testGenerateScreenshots() throws {
        let url = URL(fileURLWithPath: "\(#file)", isDirectory: false)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appending(components: "images", "charts")

        for category in ChartCategory.allCases {
            let categoryURL = url.appending(component: category.id)
            try createDirectoryIfNeeded(at: categoryURL)

            for chart in ChartType.allCases.filter({ $0.category == category }) {
                let view = chart.view
                    .padding(10)
                    .frame(width: 360)
                    .background {
                        if chart.category == .apple {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                        }
                    }
                let renderer = ImageRenderer(content: view)
                renderer.scale = UIScreen.main.scale
                let pngData = try XCTUnwrap(renderer.uiImage?.pngData(), "Failed to generate PNG data for chart '\(chart.title)'")
                let chartURL = categoryURL.appending(component: "\(chart.id).png")
                try pngData.write(to: chartURL)
            }
        }
    }

    private func createDirectoryIfNeeded(at url: URL) throws {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url.path()) {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }
}

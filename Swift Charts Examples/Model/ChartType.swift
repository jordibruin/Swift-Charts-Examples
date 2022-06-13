//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Foundation
import SwiftUI

enum ChartCategory: String, CaseIterable, Hashable, Identifiable {
    case line
    case bar
    case area
    case range
    
    var id: String { self.rawValue }
}

enum ChartType: String, Identifiable, CaseIterable {
    
    // Line Charts
    case singleLine
    case singleLineLollipop
    
    // Bar Charts
    case singleBar
    case twoBars
    case pyramid
    case oneDimensionalBar
    
    // Area Charts
    case areaSimple
    
    // Range Charts
    case rangeSimple
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .singleLine:
            return "Single Line"
        case .singleLineLollipop:
            return "Single Line with Lollipop"
        case .singleBar:
            return "Single Bar"
        case .twoBars:
            return "Two Bars"
        case .pyramid:
            return "Pyramid"
        case .oneDimensionalBar:
            return "One Dimensional Bar"
        case .areaSimple:
            return "Simple Area"
        case .rangeSimple:
            return "Simple Range"
        }
    }
    
    var category: ChartCategory {
        switch self {
        case .singleLine, .singleLineLollipop:
            return .line
        case .singleBar, .twoBars, .pyramid:
            return .bar
        case .areaSimple:
            return .area
        case .rangeSimple:
            return .range
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .singleLine:
            LineChartSimpleOverview()
        case .singleLineLollipop:
            SingleLineLollipopView(isPreview: true)
        case .singleBar:
            BarChartSimpleOverview()
        case .twoBars:
            TwoBarsSimpleOverview()
        case .oneDimensionalBar:
            OneDimensionalBarSimpleOverview()
        case .pyramid:
            PyramidChartOverview()
        case .areaSimple:
            AreaChartSimpleOverview()
        case .rangeSimple:
            RangeChartSimpleOverview()
        }
    }
}

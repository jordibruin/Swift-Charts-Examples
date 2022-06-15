//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI

enum ChartCategory: String, CaseIterable, Hashable, Identifiable {
    case line
    case bar
    case area
    case range
    case heatMap
    case point
  
    var id: String { self.rawValue }
}

enum ChartType: String, Identifiable, CaseIterable {
    // Line Charts
    case singleLine
    case singleLineLollipop
    case heartBeat

    // Bar Charts
    case singleBar
    case twoBars
    case pyramid
    case oneDimensionalBar

    // Area Charts
    case areaSimple

    // Range Charts
    case rangeSimple
    case rangeHeartRate

    // HeatMap Charts
    case customizeableHeatMap

    // Point Charts
    case scatter

    var id: String { self.rawValue }

    var title: String {
        switch self {
        case .singleLine:
            return "Line Chart"
        case .singleLineLollipop:
            return "Line Chart with Lollipop"
        case .heartBeat:
            return "Heart Beat / ECG Chart"
        case .singleBar:
            return "Single Bar"
        case .twoBars:
            return "Two Bars"
        case .pyramid:
            return "Pyramid"
        case .oneDimensionalBar:
            return "One Dimensional Bar"
        case .areaSimple:
            return "Area Chart"
        case .rangeSimple:
            return "Range Chart"
        case .rangeHeartRate:
            return "Heart Rate Range Chart"
        case .customizeableHeatMap:
            return "Customizable Heat Map"
        case .scatter:
            return "Scatter Chart"
        }
    }

    var category: ChartCategory {
        switch self {
        case .singleLine, .singleLineLollipop, .heartBeat:
            return .line
        case .singleBar, .twoBars, .pyramid, .oneDimensionalBar:
            return .bar
        case .areaSimple:
            return .area
        case .rangeSimple, .rangeHeartRate:
            return .range
        case .customizeableHeatMap:
            return .heatMap
        case .scatter:
            return .point
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .singleLine:
            SingleLineOverview()
        case .singleLineLollipop:
            SingleLineLollipop(isOverview: true)
        case .heartBeat:
            HeartBeatOverview()
        case .singleBar:
            SingleBarOverview()
        case .twoBars:
            TwoBarsOverview()
        case .oneDimensionalBar:
            OneDimensionalBarOverview()
        case .pyramid:
            PyramidChartOverview()
        case .areaSimple:
            AreaSimpleOverview()
        case .rangeSimple:
            RangeSimpleOverview()
        case .rangeHeartRate:
            HeartRateRangeChartOverview()
        case .customizeableHeatMap:
            HeatMapOverview()
        case .scatter:
            ScatterChartOverview()
        }
    }

    @ViewBuilder
    var detailView: some View {
        switch self {
        case .singleLine:
            SingleLine()
        case .singleLineLollipop:
            SingleLineLollipop(isOverview: false)
        case .heartBeat:
            HeartBeat()
        case .singleBar:
            SingleBar()
        case .twoBars:
            TwoBars()
        case .oneDimensionalBar:
            OneDimensionalBar()
        case .pyramid:
            PyramidChart()
        case .areaSimple:
            AreaSimple()
        case .rangeSimple:
            RangeSimple()
        case .rangeHeartRate:
            HeartRateRangeChart()
        case .customizeableHeatMap:
            HeatMap()
        case .scatter:
            ScatterChart()
        }
    }
}

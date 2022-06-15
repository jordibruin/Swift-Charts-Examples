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
    case threshold
    
    // Area Charts
    case areaSimple
    
    // Range Charts
    case rangeSimple
    
    // HeatMap Charts
    case customizeableHeatMap
    
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
        case .threshold:
            return "Threshold Bar"
        case .oneDimensionalBar:
            return "One Dimensional Bar"
        case .areaSimple:
            return "Area Chart"
        case .rangeSimple:
            return "Range Chart"
        case .customizeableHeatMap:
            return "Customizable Heat Map"
        }
    }
    
    var category: ChartCategory {
        switch self {
        case .singleLine, .singleLineLollipop, .heartBeat:
            return .line
        case .singleBar, .twoBars, .pyramid, .threshold, .oneDimensionalBar:
            return .bar
        case .areaSimple:
            return .area
        case .rangeSimple:
            return .range
        case .customizeableHeatMap:
            return .heatMap
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
        case .threshold:
            ThresholdBarOverview()
        case .areaSimple:
            AreaSimpleOverview()
        case .rangeSimple:
            RangeSimpleOverview()
        case .customizeableHeatMap:
            HeatMapOverview()
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
        case .threshold:
            ThresholdBar()
        case .areaSimple:
            AreaSimple()
        case .rangeSimple:
            RangeSimple()
        case .customizeableHeatMap:
            HeatMap()
        }
    }
}

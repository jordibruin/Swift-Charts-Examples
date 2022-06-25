//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI

enum ChartCategory: String, CaseIterable, Hashable, Identifiable {
    case all
    case line
    case bar
    case area
    case range
    case heatMap
    case point
  
    var id: String { self.rawValue }
    
    var sfSymbolName: String {
        switch self {
        case .all:
            return ""
        case .line:
            return "chart.xyaxis.line"
        case .bar:
            return "chart.bar.fill"
        case .area:
            return "triangle.fill"
        case .range:
            return "trapezoid.and.line.horizontal.fill"
        case .heatMap:
            return "checkerboard.rectangle"
        case .point:
            return "point.3.connected.trianglepath.dotted"
        }
    }
}

enum ChartType: String, Identifiable, CaseIterable {
    // Line Charts
    case singleLine
    case singleLineLollipop
    case heartBeat
    case animatingLine
    case gradientLine
    case multiLine

    // Bar Charts
    case singleBar
    case singleBarThreshold
    case twoBars
    case pyramid
    case oneDimensionalBar
    case timeSheetBar
    case soundBar

    // Area Charts
    case areaSimple
    case stackedArea

    // Range Charts
    case rangeSimple
    case rangeHeartRate
    case candleStick

    // HeatMap Charts
    case customizeableHeatMap
    case gitContributions

    // Point Charts
    case scatter
    case vectorField

    var id: String { self.rawValue }

    var title: String {
        switch self {
        case .singleLine:
            return "Line Chart"
        case .singleLineLollipop:
            return "Line Chart with Lollipop"
        case .animatingLine:
            return "Animating Line"
        case .heartBeat:
            return "Heart Beat / ECG Chart"
        case .gradientLine:
            return "Line with changing gradient"
        case .multiLine:
            return "Line Charts"
        case .singleBar:
            return "Single Bar"
        case .singleBarThreshold:
            return "Single Bar with Threshold Rule Mark"
        case .twoBars:
            return "Two Bars"
        case .pyramid:
            return "Pyramid"
        case .oneDimensionalBar:
            return "One Dimensional Bar"
        case .timeSheetBar:
            return "Time Sheet Bar"
        case .soundBar:
            return "Sound Bar"
        case .areaSimple:
            return "Area Chart"
        case .stackedArea:
            return "Stacked Area Chart"
        case .rangeSimple:
            return "Range Chart"
        case .rangeHeartRate:
            return "Heart Rate Range Chart"
        case .candleStick:
            return "Candle Stick Chart"
        case .customizeableHeatMap:
            return "Customizable Heat Map"
        case .gitContributions:
            return "GitHub Contributions Graph"
        case .scatter:
            return "Scatter Chart"
        case .vectorField:
            return "Vector Field"
        }
    }

    var category: ChartCategory {
        switch self {
        case .singleLine, .singleLineLollipop, .heartBeat, .animatingLine, .gradientLine, .multiLine:
            return .line
        case .singleBar, .singleBarThreshold, .twoBars, .pyramid, .oneDimensionalBar, .timeSheetBar, .soundBar:
            return .bar
        case .areaSimple, .stackedArea:
            return .area
        case .rangeSimple, .rangeHeartRate, .candleStick:
            return .range
        case .customizeableHeatMap, .gitContributions:
            return .heatMap
        case .scatter, .vectorField:
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
        case .animatingLine:
            AnimatingLineOverview()
        case .gradientLine:
            GradientLine(isOverview: true)
        case .multiLine:
            MultiLine(isOverview: true)
        case .singleBar:
            SingleBarOverview()
        case .singleBarThreshold:
            SingleBarThresholdOverview()
        case .twoBars:
            TwoBarsOverview()
        case .candleStick:
            CandleStickChartOverview()
        case .oneDimensionalBar:
            OneDimensionalBarOverview()
        case .timeSheetBar:
            TimeSheetBarOverview()
        case .soundBar:
            SoundBars(isOverview: true)
        case .pyramid:
            PyramidChartOverview()
        case .areaSimple:
            AreaSimpleOverview()
        case .stackedArea:
            StackedArea(isOverview: true)
        case .rangeSimple:
            RangeSimpleOverview()
        case .rangeHeartRate:
            HeartRateRangeChartOverview()
        case .customizeableHeatMap:
            HeatMapOverview()
        case .gitContributions:
            GitHubContributionsGraph(isOverview: true)
        case .scatter:
            ScatterChartOverview()
        case .vectorField:
            VectorFieldOverview()
        }
    }

    @ViewBuilder
    var detailView: some View {
        switch self {
        case .singleLine:
            SingleLine()
        case .singleLineLollipop:
            SingleLineLollipop()
        case .heartBeat:
            HeartBeat()
        case .animatingLine:
            AnimatingLine()
        case .gradientLine:
            GradientLine()
        case .multiLine:
            MultiLine()
        case .singleBar:
            SingleBar()
        case .singleBarThreshold:
            SingleBarThreshold()
        case .twoBars:
            TwoBars()
        case .candleStick:
            CandleStickChart()
        case .oneDimensionalBar:
            OneDimensionalBar()
        case .timeSheetBar:
            TimeSheetBar()
        case .soundBar:
            SoundBars()
        case .pyramid:
            PyramidChart()
        case .areaSimple:
            AreaSimple()
        case .stackedArea:
            StackedArea()
        case .rangeSimple:
            RangeSimple()
        case .rangeHeartRate:
            HeartRateRangeChart()
        case .customizeableHeatMap:
            HeatMap()
        case .gitContributions:
            GitHubContributionsGraph()
        case .scatter:
            ScatterChart()
        case .vectorField:
            VectorField()
        }
    }
}

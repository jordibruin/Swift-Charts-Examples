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
        case .singleBar, .singleBarThreshold, .twoBars, .pyramid, .oneDimensionalBar, .timeSheetBar:
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
            SingleLine(isOverview: true)
        case .singleLineLollipop:
            SingleLineLollipop(isOverview: true)
        case .heartBeat:
            HeartBeat(isOverview: true)
        case .animatingLine:
            AnimatingLine(isOverview: true)
		case .gradientLine:
			GradientLine(isOverview: true)
        case .singleBar:
            SingleBar(isOverview: true)
        case .singleBarThreshold:
			SingleBarThreshold(isOverview: true)
        case .twoBars:
            TwoBars(isOverview: true)
        case .candleStick:
			CandleStickChart(isOverview: true)
        case .oneDimensionalBar:
            OneDimensionalBar(isOverview: true)
        case .timeSheetBar:
            TimeSheetBar(isOverview: true)
        case .pyramid:
            PyramidChart(isOverview: true)
        case .areaSimple:
			AreaSimple(isOverview: true)
      case .stackedArea:
          StackedArea(isOverview: true)
        case .rangeSimple:
            RangeSimple(isOverview: true)
        case .rangeHeartRate:
            HeartRateRangeChart(isOverview: true)
        case .customizeableHeatMap:
			HeatMap(isOverview: true)
      case .gitContributions:
          GitHubContributionsGraph(isOverview: true)
        case .scatter:
			ScatterChart(isOverview: true)
        case .vectorField:
			VectorField(isOverview: true)

        }
    }

    @ViewBuilder
    var detailView: some View {
        switch self {
        case .singleLine:
            SingleLine(isOverview: false)
        case .singleLineLollipop:
            SingleLineLollipop()
        case .heartBeat:
            HeartBeat(isOverview: false)
        case .animatingLine:
            AnimatingLine(isOverview: false)
		case .gradientLine:
			GradientLine(isOverview: false)
        case .singleBar:
            SingleBar(isOverview: false)
        case .singleBarThreshold:
            SingleBarThreshold(isOverview: false)
        case .twoBars:
            TwoBars(isOverview: false)
        case .candleStick:
            CandleStickChart(isOverview: false)
        case .oneDimensionalBar:
            OneDimensionalBar(isOverview: false)
        case .timeSheetBar:
            TimeSheetBar(isOverview: false)
        case .pyramid:
            PyramidChart(isOverview: false)
        case .areaSimple:
            AreaSimple(isOverview: false)
            case .stackedArea:
                StackedArea(isOverview: false)
        case .rangeSimple:
            RangeSimple(isOverview: false)
        case .rangeHeartRate:
            HeartRateRangeChart(isOverview: false)
        case .customizeableHeatMap:
            HeatMap(isOverview: false)
            case .gitContributions:
                GitHubContributionsGraph(isOverview: false)
        case .scatter:
			ScatterChart(isOverview: false)
        case .vectorField:
            VectorField(isOverview: false)
        }
    }
}

//
//  ChartType.swift
//  Swift Charts Examples
//
//  Created by Jordi Bruin on 12/06/2022.
//

import Foundation
import SwiftUI

enum ChartCategory: String, CaseIterable, Hashable, Identifiable {
    case line
    case bar
    case area
    
    var id: String { self.rawValue }
}

enum ChartType: String, Identifiable, CaseIterable {
    
    // Line Charts
    case lineSimple
    
    // Bar Charts
    case barSimple
    case twoBarsSimple
    
    // Area Charts
    case areaSimple
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .lineSimple:
            return "Single Line"
        case .barSimple:
            return "Single Bar"
        case .twoBarsSimple:
            return "Two Bars"
        case .areaSimple:
            return "Simple Area"
        }
    }
    
    var category: ChartCategory {
        switch self {
        case .lineSimple:
            return .line
        case .barSimple:
            return .bar
        case .twoBarsSimple:
            return .bar
        case .areaSimple:
            return .area
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .lineSimple:
            LineChartSimpleOverview()
        case .barSimple:
            BarChartSimpleOverview()
        case .twoBarsSimple:
            TwoBarsSimpleOverview()
        case .areaSimple:
            AreaChartSimpleOverview()
        }
    }
}

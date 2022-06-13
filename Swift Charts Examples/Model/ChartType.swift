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
            return "Line Chart Simple"
        case .barSimple:
            return "Bar Chart Simple"
        case .twoBarsSimple:
            return "Two Bars Chart Simple"
        case .areaSimple:
            return "Area Chart Simple"
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

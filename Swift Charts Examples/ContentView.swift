//
//  ContentView.swift
//  Swift Charts Examples
//
//  Created by Jordi Bruin on 12/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        NavigationStack() {
            List(ChartType.allCases) { chart in
                NavigationLink(value: chart) {
                    Text(chart.title)
                }
            }
            .navigationDestination(for: ChartType.self) { chart in
                chart.view
            }
            .navigationTitle("Charts")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum ChartType: String, Identifiable, CaseIterable {
    case lineChartSimple
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .lineChartSimple:
            return "Line Chart Simple"
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .lineChartSimple:
            LineChartSimpleView()
        }
    }
}

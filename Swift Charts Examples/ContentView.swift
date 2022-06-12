//
//  ContentView.swift
//  Swift Charts Examples
//
//  Created by Jordi Bruin on 12/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedChartType: ChartType?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedChartType) {
                ForEach(ChartType.allCases) { chart in
                    Section {
                        NavigationLink(value: chart) {
                            chart.view
                        }
                    }
                }
            }
        } detail: {
            NavigationStack {
                switch selectedChartType {
                case .none:
                    Text("Select a chart to view")
                case .lineChartSimple:
                    LineChartSimpleView()
                }
            }
        }
        .navigationTitle("Charts")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

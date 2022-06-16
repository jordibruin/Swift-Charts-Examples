//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI

struct ContentView: View {
    @State private var selectedChartType: ChartType?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedChartType) {
                ForEach(ChartCategory.allCases) { category in
                    Section {
                        ForEach(ChartType.allCases.filter { $0.category == category }) { chart in
                            NavigationLink(value: chart) {
                                chart.view
                            }
                        }
                    } header: {
                        Text("\(category.rawValue)")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Charts")
        } detail: {
            NavigationStack {
                if let selectedChartType {
                    selectedChartType.detailView
                } else {
                    Text("Select a chart")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI

struct ContentView: View {
    @State private var selectedChartType: ChartType?
    
    private var cachedChartImages: [String: UIImage] = [:]
    
    @MainActor
    init() {
        ChartType.allCases.forEach { chart in
            let view = chart.view
                .frame(width: 300)
                .background(.white)
            let renderer = ImageRenderer(content: view)
            if let image = renderer.cgImage {
                cachedChartImages[chart.id] = UIImage(cgImage: image)
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedChartType) {
                ForEach(ChartCategory.allCases) { category in
                    Section {
                        ForEach(ChartType.allCases.filter { $0.category == category }) { chart in
                            NavigationLink(value: chart) {
                                // causes UI to hang for several seconds when scrolling
                                // from 100% CPU usage when cells are reloaded
//                                chart.view
                                
                                // workaround to address hanging UI
                                cachedView(chart: chart)
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
    
    private func cachedView(chart: ChartType) -> AnyView {
        guard let image = cachedChartImages[chart.id] else {
            return AnyView(Text(chart.title))
        }
        return AnyView(
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

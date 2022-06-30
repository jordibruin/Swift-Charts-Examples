//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI

struct ContentView: View {
    @State private var selectedChartType: ChartType?
    @State var filterCategory: ChartCategory = .all
    
    private var cachedChartImages: [String: UIImage] = [:]
    
    @MainActor
    init() {
        ChartType.allCases.forEach { chart in
            let view = chart.view
                .padding(10)
                .frame(width: 300)
                .background {
                    if chart.category == .apple {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                    }
                }
            let renderer = ImageRenderer(content: view)
            renderer.scale = UIScreen.main.scale
            if let image = renderer.uiImage {
                cachedChartImages[chart.id] = image
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedChartType) {
                ForEach(displayedCategories) { category in
                    Section {
                        ForEach(ChartType.allCases.filter { $0.category == category }) { chart in
                            NavigationLink(value: chart) {
                                preview(chart: chart)
                            }
                        }
                    } header: {
                        Text("\(category.rawValue)")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Charts")
            .toolbar {
                toolbarItems
            }
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

    private var displayedCategories: [ChartCategory] {
        var categories = ChartCategory.allCases.filter { $0 != .all }
        if filterCategory != .all {
            categories = ChartCategory.allCases.filter { $0 == filterCategory }
        }
        return categories
    }

    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Picker(selection: $filterCategory, label: Text("Filter")) {
                    ForEach(ChartCategory.allCases.filter { $0 != .all }) { category in
                        Label("\(category.rawValue.capitalized)", systemImage: category.sfSymbolName)
                            .tag(category)
                    }
                    Divider()
                    Text("Show all")
                        .tag(ChartCategory.all)
                }
            } label: {
                Text("Filter")
            }
        }
    }
    
    private func preview(chart: ChartType) -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                Text(chart.title)
                
                // causes UI to hang for several seconds when scrolling
                // from 100% CPU usage when cells are reloaded
                //                chart.view
                
                // workaround to address hanging UI
                // Reported FB10335209
                if let image = cachedChartImages[chart.id] {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 320)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

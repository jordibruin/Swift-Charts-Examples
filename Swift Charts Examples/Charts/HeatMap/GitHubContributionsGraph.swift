//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct GitHubContributionsGraph: View {
    var isOverview: Bool

    private let data = GitHubData.contributions.suffix(7 * 20 - 1)

    var body: some View {
        if isOverview {
            chart
        } else {
            List {
                Section {
                    chart
                }
            }
            .navigationBarTitle(ChartType.gitContributions.title, displayMode: .inline)
        }
    }

    private var chart: some View {
        Chart(data) { contribution in
            RectangleMark(
                xStart: .value("xStart", relativeWeek(date: contribution.date)),
                xEnd: .value("xEnd", relativeWeek(date: contribution.date) + 1),
                yStart: .value("yStart", dayOfTheWeek(date: contribution.date)),
                yEnd: .value("yEnd", dayOfTheWeek(date: contribution.date) + 1)
            )
            .foregroundStyle(by: .value("Level", contribution.level))
            .interpolationMethod(.cardinal)
        }
        .chartForegroundStyleScale(range: Gradient(colors: [.white, .green]))
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 7,
                                         roundLowerBound: false,
                                         roundUpperBound: false)) { _ in
                AxisGridLine()
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 20,
                                         roundLowerBound: false,
                                         roundUpperBound: false)) { _ in
                AxisGridLine()
            }
        }
        .chartYScale(domain: .automatic(reversed: true))
        .aspectRatio(20.0/7.0, contentMode: .fit)
    }

    private func dayOfTheWeek(date: Date) -> Int {
        (Calendar.current.dateComponents([.weekday], from: date).weekday ?? 1) - 1
    }

    private func relativeWeek(date: Date) -> Int {
        let firstDate = data.first!.date
        let daysApart = Calendar.current.dateComponents([.day], from: firstDate, to: date).day!
        return daysApart / 7
    }
}

struct GitHubContributionsGraph_Previews: PreviewProvider {
    static var previews: some View {
        GitHubContributionsGraph(isOverview: true)
        GitHubContributionsGraph(isOverview: false)
    }
}

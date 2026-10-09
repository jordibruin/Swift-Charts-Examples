//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

/// Sleep stages chart from the Health app.
///
/// Swift Charts has no API for connecting lines between marks, so the whole chart is built from `RectangleMark`s
/// drawn in a specific order:
/// 1. Outline: a darker mark under each bar, wider than the bar by the border width.
/// 2. Connector: a fixed width mark from the center of one bar to the center of the next one.
/// 3. Fillet: a square in the outline color and a circle in the background color on top of it,
///    which gives a concave corner between a connector and a bar.
/// 4. Fill: the bar itself.
struct SleepStages: View {
    var isOverview: Bool

    @State private var showsConnectors = true
    @State private var showsFillets = true

    var body: some View {
        if isOverview {
            chart
                .padding(12)
                .background(Color.black, in: RoundedRectangle(cornerRadius: 10))
        } else {
            List {
                Section(header: header, footer: footer) {
                    chart
                        .listRowBackground(Color.black)
                }

                customisation
            }
            .navigationBarTitle(ChartType.sleepStages.title, displayMode: .inline)
        }
    }

    private var chart: some View {
        SleepStagesChart(
            segments: SleepData.lastNight,
            domain: SleepData.nightStart...SleepData.nightEnd,
            showsConnectors: showsConnectors,
            showsFillets: showsFillets,
            isInteractive: !isOverview
        )
        .accessibilityChartDescriptor(self)
        .environment(\.colorScheme, .dark)
        .frame(height: isOverview ? 200 : Constants.detailChartHeight)
    }

    private var customisation: some View {
        Section {
            Toggle("Connectors", isOn: $showsConnectors)
            Toggle("Rounded Fillets", isOn: $showsFillets)
                .disabled(!showsConnectors)
        }
    }

    private var header: some View {
        VStack(alignment: .leading) {
            Text("Time Asleep")
            Text(SleepData.timeAsleep.hoursAndMinutes)
                .font(.system(.title, design: .rounded))
                .foregroundColor(.primary)
            Text(SleepData.nightStart, format: .dateTime.weekday(.wide).month().day())
        }
        .fontWeight(.semibold)
    }

    private var footer: some View {
        #if os(iOS) || os(macOS)
        Text("Pinch to zoom, drag to scroll, double-tap to reset.")
        #else
        EmptyView()
        #endif
    }
}

// MARK: - Chart

private struct SleepStagesChart: View {
    let segments: [SleepSegment]
    let domain: ClosedRange<Date>
    var showsConnectors = true
    var showsFillets = true
    var isInteractive = true
    /// Used to carve fillets, must match the background behind the chart.
    var backgroundColor: Color = .black

    @Environment(\.locale) private var locale

    /// Visible part of the domain, `nil` shows the whole night.
    @State private var visibleRange: ClosedRange<Date>?
    @State private var zoomStartRange: ClosedRange<Date>?
    @State private var dragStartRange: ClosedRange<Date>?
    /// Set by a pinch, so the drag recognized together with it doesn't scroll or fling.
    @State private var isZooming = false
    @State private var isDragging = false
    /// Inertia and reset are animated frame by frame: animating the scale domain with `withAnimation`
    /// moves marks but snaps the axis.
    @State private var animationTask: Task<Void, Never>?

    private let minimumVisibleDuration: TimeInterval = 20 * 60
    private let borderWidth: CGFloat = 5 / 3
    private var connectorWidth: CGFloat { borderWidth * 2 }
    private let filletRadius: CGFloat = 4
    private let cornerRadius: CGFloat = 6.75
    private let fillCornerRadius: CGFloat = 6
    private let gridLineWidth: CGFloat = 1 / 3
    private let tickLength: CGFloat = 46 / 3
    private let gridColor = Color(red: 0.557, green: 0.553, blue: 0.576)
    private let verticalGridColor = Color(red: 0.212, green: 0.212, blue: 0.220)
    private let axisLabelColor = Color(red: 0.275, green: 0.271, blue: 0.290)

    var body: some View {
        GeometryReader { proxy in
            chart(plotWidth: proxy.size.width)
        }
    }

    private func chart(plotWidth: CGFloat) -> some View {
        Chart {
            let corners = showsConnectors && showsFillets ? fillets(plotWidth: plotWidth).filter { isVisible($0.date, $0.date) } : []
            let visibleSegments = segments.filter { isVisible($0.start, $0.end) }
            let visibleTransitions = showsConnectors ? transitions.filter { isVisible($0.date, $0.date) } : []

            ForEach(corners) { fillet in
                cornerPatch(for: fillet)
                filletSquare(for: fillet)
            }
            ForEach(corners) { fillet in
                filletCutout(for: fillet)
            }
            ForEach(visibleTransitions) { transition in
                connector(for: transition)
            }
            ForEach(visibleSegments) { segment in
                outline(for: segment)
            }
            ForEach(visibleSegments) { segment in
                fill(for: segment)
            }

            // Row lines go on top: they cross connectors (like in Health) and hide fillet cutouts.
            ForEach(SleepStage.allCases) { stage in
                RuleMark(y: .value("Row", stage.row + 1))
                    .foregroundStyle(stage == .awake ? .clear : gridColor)
                    .lineStyle(StrokeStyle(lineWidth: gridLineWidth))
                    .accessibilityHidden(true)
            }
            RuleMark(y: .value("Row", 0))
                .foregroundStyle(gridColor)
                .lineStyle(StrokeStyle(lineWidth: gridLineWidth))
                .accessibilityHidden(true)
        }
        .chartXScale(domain: currentRange)
        .chartYScale(domain: 0...4)
        .chartYAxis(.hidden)
        .chartPlotStyle { $0.clipped() }
        .chartXAxis {
            AxisMarks(values: gridDates) { value in
                let stroke = StrokeStyle(lineWidth: 0.5, dash: [2, 2], dashPhase: 4 / 3)
                AxisGridLine(stroke: stroke)
                    .foregroundStyle(verticalGridColor)
                AxisTick(length: tickLength, stroke: stroke)
                    .foregroundStyle(verticalGridColor)
                if let date = value.as(Date.self) {
                    AxisValueLabel(anchor: .topLeading, horizontalSpacing: 3, verticalSpacing: 0) {
                        Text(hourLabel(for: date))
                            .font(.system(size: 13))
                            .foregroundStyle(axisLabelColor)
                    }
                }
            }
        }
        .chartOverlay { proxy in
            ZStack(alignment: .topLeading) {
                edgeMarks(proxy: proxy)
                stageLabels(proxy: proxy)
            }
        }
        // A single Metal layer instead of hundreds of separate shape layers.
        .drawingGroup()
        .modifier(ZoomAndScroll(isEnabled: isInteractive, plotWidth: plotWidth, chart: self))
    }

    // MARK: - Overlay

    /// Solid lines at the start and the end of the night, and the first time label.
    /// Charts randomly drops axis marks on the scale boundary, so they're drawn here.
    private func edgeMarks(proxy: ChartProxy) -> some View {
        GeometryReader { geometry in
            let frame = geometry[proxy.plotAreaFrame]
            ForEach([domain.lowerBound, domain.upperBound], id: \.self) { date in
                // A point of tolerance keeps the edge visible in the last frames of an animated reset.
                if let x = proxy.position(forX: date), x >= -1, x <= frame.width + 1 {
                    Rectangle()
                        .fill(verticalGridColor)
                        .frame(width: 0.5, height: frame.height + tickLength)
                        .offset(x: frame.minX + x - 0.25, y: frame.minY)
                    if date == domain.lowerBound {
                        Text(hourLabel(for: date))
                            .font(.system(size: 13))
                            .foregroundStyle(axisLabelColor)
                            .fixedSize()
                            .offset(x: frame.minX + x + 3, y: frame.maxY)
                    }
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    /// Pinned to the leading edge of the plot, so they stay in place while scrolling.
    private func stageLabels(proxy: ChartProxy) -> some View {
        GeometryReader { geometry in
            let frame = geometry[proxy.plotAreaFrame]
            ForEach(SleepStage.allCases) { stage in
                if let y = proxy.position(forY: stage.row + 1) {
                    Text(stage.title)
                        .font(.system(size: 13))
                        .foregroundStyle(gridColor)
                        .fixedSize()
                        .offset(x: frame.minX + 17 / 3, y: frame.minY + y + 10 / 3)
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    // MARK: - Connectors

    private var transitions: [SleepTransition] {
        zip(segments, segments.dropFirst()).map { previous, next in
            SleepTransition(date: next.start, from: previous, to: next)
        }
    }

    @ChartContentBuilder
    private func connector(for transition: SleepTransition) -> some ChartContent {
        let top = transition.upper.stage
        let bottom = transition.lower.stage
        RectangleMark(
            x: .value("Time", transition.date),
            yStart: .value("Stage", bottom.barCenter),
            yEnd: .value("Stage", top.barCenter),
            width: .fixed(connectorWidth)
        )
        .foregroundStyle(BorderGradient.gradient(from: top.barCenter, to: bottom.barCenter))
        .accessibilityHidden(true)
    }

    // MARK: - Fillets

    private func fillets(plotWidth: CGFloat) -> [SleepFillet] {
        let pointsPerSecond = plotWidth / currentDuration
        return segments.indices.flatMap { index -> [SleepFillet] in
            let segment = segments[index]
            let previous = index > 0 ? segments[index - 1] : nil
            let next = index < segments.count - 1 ? segments[index + 1] : nil
            let width = segment.duration * pointsPerSecond
            let neighbors: [(SleepSegment?, SleepSegment?, Date, CGFloat)] = [
                (previous, next, segment.start, 1),
                (next, previous, segment.end, -1)
            ]
            return neighbors.compactMap { neighbor, opposite, date, horizontal in
                guard let neighbor else {
                    return nil
                }
                let isUpper = segment.stage.rawValue > neighbor.stage.rawValue
                // Connectors on both ends leave the same edge, so they share the free space.
                let sharesEdge = opposite.map { (segment.stage.rawValue > $0.stage.rawValue) == isUpper } ?? false
                let available = (width - connectorWidth) / (sharesEdge ? 2 : 1)
                let radius = min(filletRadius, available)
                guard radius > 0.3 else {
                    return nil
                }
                return SleepFillet(
                    date: date,
                    segment: segment,
                    radius: radius,
                    horizontal: horizontal,
                    vertical: isUpper ? 1 : -1
                )
            }
        }
    }

    /// Squares off the bar's rounded corner next to the connector. Covers the nearest quarter of the bar.
    @ChartContentBuilder
    private func cornerPatch(for fillet: SleepFillet) -> some ChartContent {
        let segment = fillet.segment
        let middle = segment.start.addingTimeInterval(segment.duration / 2)
        let isLeading = fillet.horizontal > 0
        let bottom = fillet.vertical > 0 ? segment.stage.barStart : segment.stage.barCenter
        let top = fillet.vertical > 0 ? segment.stage.barCenter : segment.stage.barEnd
        RectangleMark(
            xStart: .value("Start", isLeading ? segment.start : middle),
            xEnd: .value("End", isLeading ? middle : segment.end),
            yStart: .value("Stage", bottom),
            yEnd: .value("Stage", top)
        )
        .foregroundStyle(BorderGradient.gradient(from: top, to: bottom))
        .offset(xStart: isLeading ? -borderWidth : 0, xEnd: isLeading ? 0 : borderWidth)
        .accessibilityHidden(true)
    }

    @ChartContentBuilder
    private func filletSquare(for fillet: SleepFillet) -> some ChartContent {
        RectangleMark(
            x: .value("Time", fillet.date),
            y: .value("Stage", fillet.edge),
            width: .fixed(fillet.radius),
            height: .fixed(fillet.radius)
        )
        .foregroundStyle(fillet.color)
        .offset(
            x: fillet.horizontal * (connectorWidth + fillet.radius) / 2,
            y: fillet.vertical * fillet.radius / 2
        )
        .accessibilityHidden(true)
    }

    @ChartContentBuilder
    private func filletCutout(for fillet: SleepFillet) -> some ChartContent {
        RectangleMark(
            x: .value("Time", fillet.date),
            y: .value("Stage", fillet.edge),
            width: .fixed(fillet.radius * 2),
            height: .fixed(fillet.radius * 2)
        )
        .foregroundStyle(backgroundColor)
        .cornerRadius(fillet.radius)
        .offset(
            x: fillet.horizontal * (connectorWidth / 2 + fillet.radius),
            y: fillet.vertical * fillet.radius
        )
        .accessibilityHidden(true)
    }

    // MARK: - Bars

    @ChartContentBuilder
    private func outline(for segment: SleepSegment) -> some ChartContent {
        let stage = segment.stage
        RectangleMark(
            xStart: .value("Start", segment.start),
            xEnd: .value("End", segment.end),
            yStart: .value("Stage", stage.barStart),
            yEnd: .value("Stage", stage.barEnd)
        )
        .foregroundStyle(BorderGradient.gradient(from: stage.barEnd, to: stage.barStart))
        .cornerRadius(cornerRadius, style: .continuous)
        .offset(xStart: -borderWidth, xEnd: borderWidth)
        .accessibilityHidden(true)
    }

    @ChartContentBuilder
    private func fill(for segment: SleepSegment) -> some ChartContent {
        let stage = segment.stage
        RectangleMark(
            xStart: .value("Start", segment.start),
            xEnd: .value("End", segment.end),
            yStart: .value("Stage", stage.barStart),
            yEnd: .value("Stage", stage.barEnd)
        )
        .foregroundStyle(stage.color)
        .cornerRadius(fillCornerRadius, style: .continuous)
        .offset(yStart: 1.5, yEnd: -borderWidth)
        .accessibilityLabel(stage.title)
        .accessibilityValue("\((segment.start..<segment.end).formatted(.interval.hour().minute())), \(segment.duration.durationDescription)")
    }

    // MARK: - Visible range

    private var totalDuration: TimeInterval {
        domain.upperBound.timeIntervalSince(domain.lowerBound)
    }

    private var currentRange: ClosedRange<Date> {
        visibleRange ?? domain
    }

    private var currentDuration: TimeInterval {
        currentRange.upperBound.timeIntervalSince(currentRange.lowerBound)
    }

    /// Marks outside of the visible range are skipped, the margin keeps connectors and fillets at the edges.
    private func isVisible(_ start: Date, _ end: Date) -> Bool {
        let margin = currentDuration * 0.05
        return end >= currentRange.lowerBound.addingTimeInterval(-margin)
            && start <= currentRange.upperBound.addingTimeInterval(margin)
    }

    /// Grid values aligned to the stride, without the edges of the night.
    private var gridDates: [Date] {
        let stride = TimeInterval(gridStrideInMinutes * 60)
        let offset = currentRange.lowerBound.timeIntervalSince(domain.lowerBound)
        var date = domain.lowerBound.addingTimeInterval((offset / stride).rounded(.up) * stride)
        var dates: [Date] = []
        while date <= currentRange.upperBound {
            dates.append(date)
            date = date.addingTimeInterval(stride)
        }
        return dates.filter { $0 != domain.lowerBound && $0 != domain.upperBound }
    }

    /// Denser grid when zoomed in.
    private var gridStrideInMinutes: Int {
        switch currentDuration {
        case (4 * 3600)...:
            return 120
        case (2 * 3600)...:
            return 60
        case 3600...:
            return 30
        default:
            return 15
        }
    }

    /// "12 AM" with a regular space, like in Health, instead of the narrow one from the formatter.
    private func hourLabel(for date: Date) -> String {
        let hour = Date.FormatStyle.Symbol.Hour.defaultDigits(amPM: .abbreviated)
        let hasMinutes = Calendar.current.component(.minute, from: date) != 0
        let style = hasMinutes ? Date.FormatStyle.dateTime.hour(hour).minute() : .dateTime.hour(hour)
        return date.formatted(style.locale(locale))
            .replacingOccurrences(of: "\u{202F}", with: " ")
    }

    // MARK: - Zoom and scroll

    // Charts' own scrolling loses the scroll position when the visible length changes in the same update,
    // so the visible range is driven manually through the x scale domain.

    fileprivate func zoom(by magnification: CGFloat, anchor: CGFloat) {
        animationTask?.cancel()
        isZooming = true
        let start = zoomStartRange ?? currentRange
        zoomStartRange = start
        let startDuration = start.upperBound.timeIntervalSince(start.lowerBound)
        let duration = min(max(startDuration / magnification, minimumVisibleDuration), totalDuration)
        // Keeps the time under the fingers in place.
        let anchorDate = start.lowerBound.addingTimeInterval(startDuration * anchor)
        let lowerBound = anchorDate.addingTimeInterval(-duration * anchor)
        visibleRange = clamped(lowerBound...lowerBound.addingTimeInterval(duration))
    }

    fileprivate func endZoom() {
        zoomStartRange = nil
        if !isDragging {
            isZooming = false
        }
    }

    fileprivate func scroll(by translation: CGFloat, plotWidth: CGFloat) {
        isDragging = true
        guard !isZooming, visibleRange != nil else {
            return
        }
        animationTask?.cancel()
        let start = dragStartRange ?? currentRange
        dragStartRange = start
        let secondsPerPoint = currentDuration / plotWidth
        visibleRange = clamped(shifted(start, by: -translation * secondsPerPoint))
    }

    fileprivate func endScroll(momentum: CGFloat, plotWidth: CGFloat) {
        isDragging = false
        dragStartRange = nil
        guard !isZooming else {
            isZooming = false
            return
        }
        guard visibleRange != nil else {
            return
        }
        // Inertia: continue to the predicted end of the drag.
        let secondsPerPoint = currentDuration / plotWidth
        animate(to: clamped(shifted(currentRange, by: -momentum * secondsPerPoint)), duration: 0.6)
    }

    fileprivate func resetZoom() {
        guard visibleRange != nil else {
            return
        }
        animate(to: domain, duration: 0.45) {
            visibleRange = nil
        }
    }

    private func animate(to target: ClosedRange<Date>, duration: TimeInterval, completion: @escaping () -> Void = {}) {
        animationTask?.cancel()
        let start = currentRange
        animationTask = Task {
            let clock = ContinuousClock()
            let startTime = clock.now
            while !Task.isCancelled {
                let progress = min(startTime.duration(to: clock.now) / .seconds(duration), 1)
                if progress >= 1 {
                    visibleRange = target
                    completion()
                    return
                }
                // Ease out cubic.
                visibleRange = interpolated(from: start, to: target, by: 1 - pow(1 - progress, 3))
                try? await Task.sleep(for: .milliseconds(8))
            }
        }
    }

    private func interpolated(from start: ClosedRange<Date>, to end: ClosedRange<Date>, by fraction: Double) -> ClosedRange<Date> {
        func value(_ from: Date, _ to: Date) -> Date {
            from.addingTimeInterval(to.timeIntervalSince(from) * fraction)
        }
        return value(start.lowerBound, end.lowerBound)...value(start.upperBound, end.upperBound)
    }

    private func shifted(_ range: ClosedRange<Date>, by interval: TimeInterval) -> ClosedRange<Date> {
        range.lowerBound.addingTimeInterval(interval)...range.upperBound.addingTimeInterval(interval)
    }

    /// Moves the range inside the domain keeping its duration.
    private func clamped(_ range: ClosedRange<Date>) -> ClosedRange<Date> {
        let duration = range.upperBound.timeIntervalSince(range.lowerBound)
        let latestStart = domain.upperBound.addingTimeInterval(-duration)
        let lowerBound = min(max(range.lowerBound, domain.lowerBound), latestStart)
        return lowerBound...lowerBound.addingTimeInterval(duration)
    }
}

/// Pinch to zoom, drag to scroll and double-tap to reset.
private struct ZoomAndScroll: ViewModifier {
    let isEnabled: Bool
    let plotWidth: CGFloat
    let chart: SleepStagesChart

    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS)
        if isEnabled {
            zoomable(
                content
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 5)
                            .onChanged { chart.scroll(by: $0.translation.width, plotWidth: plotWidth) }
                            .onEnded { chart.endScroll(momentum: $0.predictedEndTranslation.width - $0.translation.width, plotWidth: plotWidth) }
                    )
            )
            .onTapGesture(count: 2, perform: chart.resetZoom)
        } else {
            content
        }
        #else
        content
        #endif
    }

    #if os(iOS) || os(macOS)
    @ViewBuilder
    private func zoomable(_ content: some View) -> some View {
        if #available(iOS 17, macOS 14, *) {
            content.simultaneousGesture(
                MagnifyGesture()
                    .onChanged { chart.zoom(by: $0.magnification, anchor: $0.startAnchor.x) }
                    .onEnded { _ in chart.endZoom() }
            )
        } else {
            content.simultaneousGesture(
                MagnificationGesture()
                    .onChanged { chart.zoom(by: $0, anchor: 0.5) }
                    .onEnded { _ in chart.endZoom() }
            )
        }
    }
    #endif
}

// MARK: - Layout

private extension SleepStage {
    /// Bottom of the row band.
    var row: Double { Double(rawValue) }
    var barStart: Double { row + 0.127 }
    var barEnd: Double { row + 0.651 }
    var barCenter: Double { (barStart + barEnd) / 2 }

    /// Outline colors from the top edge of the bar (0) to the bottom one (1), sampled from the Health app.
    var borderStops: [(location: Double, color: RGB)] {
        switch self {
        case .deep:
            return [(0, RGB(0x1B1C54)), (1, RGB(0x1B1B51))]
        case .core:
            return [(0, RGB(0x0F4B81)), (0.52, RGB(0x064280)), (0.79, RGB(0x0A3B77)), (1, RGB(0x0C336C))]
        case .rem:
            return [(0, RGB(0x31687E)), (1, RGB(0x205A80))]
        case .awake:
            return [(0, RGB(0x803427)), (1, RGB(0x803427))]
        }
    }
}

private struct SleepTransition: Identifiable {
    let date: Date
    let from: SleepSegment
    let to: SleepSegment

    var id: UUID { to.id }
    var upper: SleepSegment { from.stage.rawValue > to.stage.rawValue ? from : to }
    var lower: SleepSegment { from.stage.rawValue > to.stage.rawValue ? to : from }
}

/// Concave corner between a connector and a bar edge.
private struct SleepFillet: Identifiable {
    let date: Date
    let segment: SleepSegment
    let radius: CGFloat
    /// -1 — left of the connector, 1 — right.
    let horizontal: CGFloat
    /// -1 — above the edge, 1 — below (screen space).
    let vertical: CGFloat

    var id: String { "\(segment.id)-\(horizontal)" }
    var edge: Double { vertical > 0 ? segment.stage.barStart : segment.stage.barEnd }
    var color: Color { BorderGradient.color(at: edge).color }
}

private struct RGB {
    let red: Double
    let green: Double
    let blue: Double

    init(_ hex: UInt32) {
        red = Double((hex >> 16) & 0xFF) / 255
        green = Double((hex >> 8) & 0xFF) / 255
        blue = Double(hex & 0xFF) / 255
    }

    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    var color: Color { Color(red: red, green: green, blue: blue) }

    func mixed(with other: RGB, by fraction: Double) -> RGB {
        RGB(
            red: red + (other.red - red) * fraction,
            green: green + (other.green - green) * fraction,
            blue: blue + (other.blue - blue) * fraction
        )
    }
}

/// Vertical gradient shared by all outlines and connectors, defined in chart y values.
/// Each mark gets its own slice, so together they look like one continuous gradient.
private enum BorderGradient {
    /// Sorted from top to bottom.
    static let stops: [(y: Double, color: RGB)] = SleepStage.allCases.reversed().flatMap { stage in
        stage.borderStops.map { stop in
            (stage.barEnd - stop.location * (stage.barEnd - stage.barStart), stop.color)
        }
    }

    static func color(at y: Double) -> RGB {
        for (upper, lower) in zip(stops, stops.dropFirst()) where y >= lower.y {
            guard y < upper.y else {
                return upper.color
            }
            return upper.color.mixed(with: lower.color, by: (upper.y - y) / (upper.y - lower.y))
        }
        return stops[stops.count - 1].color
    }

    static func gradient(from top: Double, to bottom: Double) -> LinearGradient {
        let height = top - bottom
        let inner = stops
            .filter { $0.y < top && $0.y > bottom }
            .map { Gradient.Stop(color: $0.color.color, location: (top - $0.y) / height) }
        let stops = [Gradient.Stop(color: color(at: top).color, location: 0)]
            + inner
            + [Gradient.Stop(color: color(at: bottom).color, location: 1)]
        return LinearGradient(stops: stops, startPoint: .top, endPoint: .bottom)
    }
}

private extension TimeInterval {
    var hoursAndMinutes: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: self) ?? ""
    }
}

// MARK: - Accessibility

extension SleepStages: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let segments = SleepData.lastNight
        let start = SleepData.nightStart

        let xAxis = AXNumericDataAxisDescriptor(
            title: "Time",
            range: 0...SleepData.nightEnd.timeIntervalSince(start),
            gridlinePositions: []
        ) { value in
            start.addingTimeInterval(value).formatted(date: .omitted, time: .shortened)
        }

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Stage",
            range: 0...Double(SleepStage.allCases.count - 1),
            gridlinePositions: SleepStage.allCases.map { Double($0.rawValue) }
        ) { value in
            SleepStage(rawValue: Int(value.rounded()))?.title ?? ""
        }

        let series = AXDataSeriesDescriptor(
            name: "Last Night",
            isContinuous: false,
            dataPoints: segments.map {
                .init(
                    x: $0.start.timeIntervalSince(start),
                    y: Double($0.stage.rawValue),
                    label: "\($0.stage.title), \($0.duration.durationDescription)"
                )
            }
        )

        return AXChartDescriptor(
            title: "Sleep Stages",
            summary: "Time asleep: \(SleepData.timeAsleep.durationDescription)",
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
}

// MARK: - Preview

struct SleepStages_Previews: PreviewProvider {
    static var previews: some View {
        SleepStages(isOverview: true)
        NavigationStack {
            SleepStages(isOverview: false)
        }
    }
}

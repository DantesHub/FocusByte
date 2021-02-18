//
//  focuswidget.swift
//  focuswidget
//
//  Created by Dante Kim on 2/17/21.
//  Copyright © 2021 Steve Ink. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import SwiftUICharts

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), timeData: ["0"], pet: "heroCat", noData: true, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), timeData: ["0"], pet: "heroCat", noData: true, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let userDefaults = UserDefaults(suiteName: "group.co.byteteam.focusbyte")
        let time2: [String] = userDefaults?.stringArray(forKey: "timeData") ?? ["0","0","0","0","0","0","0"]
        let pet2: String = userDefaults?.string(forKey: "pet") ?? "nopets"
        let noData: Bool = userDefaults?.bool(forKey: "noData") ?? true
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date:entryDate, timeData: time2, pet: pet2, noData: noData, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let timeData: [String]
    let pet: String
    let noData: Bool
    let configuration: ConfigurationIntent
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
//TODO
//update when finish timer and equip new pet, add total minutes and shortcut
// add notifications slider
// add default time
struct focuswidgetEntryView : View {
    var entry: Provider.Entry
    let chartStyle = ChartStyle(backgroundColor: Color(hex: "#ABA9FF"), accentColor: Color(hex: "#5351C0"), secondGradientColor: Color(hex: "#5351C0"), textColor: Color.black, legendTextColor: Color.white, dropShadowColor: Color.gray)
    var body: some View {
        ZStack {
            Color(hex: "#E3DAFA").edgesIgnoringSafeArea(.all)
            HStack {
                Spacer(minLength: 25)
                VStack {
                    Text("fds")
                    Image(entry.pet).resizable().aspectRatio(contentMode: .fit).frame(width: 40, height: 40, alignment: .center)
                }
                let data = entry.timeData.map { (str) -> Float in
                    let num = Float(str) ?? 0
                    print(num, "sejeong")
                    return num
                }
                ZStack {
                    BarChartView(data:ChartData(points: data), title: "Sun - Sat", style: chartStyle, form: ChartForm.small)
                    if entry.noData {
                        VStack {
                            Text("No Data Yet!").font(Font.custom("Menlo-Bold", size: 15)).foregroundColor(Color.black.opacity(0.5)).padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
                            Text("😢 📊").padding(4)
                        }
                    }
                }
                
                Spacer(minLength: 25)
            }
        }
    }
}

@main
struct focuswidget: Widget {
    let kind: String = "focuswidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            focuswidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Time Distribution")
        .description("Monitor how you spend your time and stay motivated")
        .supportedFamilies([.systemMedium])
    }
}


struct focuswidget_Previews: PreviewProvider {
    static var previews: some View {
        focuswidgetEntryView(entry: SimpleEntry(date: Date(),timeData: ["0"], pet: "heroCat", noData: true, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

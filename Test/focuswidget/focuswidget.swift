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
        SimpleEntry(date: Date(), timeData: ["0"], pet: "gray cat",  totalMins: 0, noData: true, coins: 0, tagName: "unset", tagColor: "gray",level: 1,defaultTime:25, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), timeData: ["0"], pet: "gray cat",totalMins: 0, noData: true, coins: 0,  tagName: "unset", tagColor: "gray",  level: 1,defaultTime:25,configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let userDefaults = UserDefaults(suiteName: "group.co.byteteam.focusbyte")
        let time2: [String] = userDefaults?.stringArray(forKey: "timeData") ?? ["0","0","0","0","0","0","0"]
        let pet2: String = userDefaults?.string(forKey: "pet") ?? "gray cat"
        let totalMins: Int = userDefaults?.integer(forKey: "totalMins") ?? 0
        let noData: Bool = userDefaults?.bool(forKey: "noData") ?? true
        let tagName: String = userDefaults?.string(forKey: "tagName") ?? "unset"
        let tagColor: String = userDefaults?.string(forKey: "tagColor") ?? "gray"
        let coins: Int = userDefaults?.integer(forKey: "coins") ?? 0
        let level: Int = userDefaults?.integer(forKey: "level") ?? 1
        let defaultTime: Int = userDefaults?.integer(forKey: "defaultTime") ?? 25
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date:entryDate, timeData: time2, pet: pet2,totalMins: totalMins,  noData: noData, coins: coins,tagName: tagName, tagColor: tagColor, level: level, defaultTime:defaultTime, configuration: configuration)
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
    let totalMins: Int
    let noData: Bool
    let coins: Int
    let tagName: String
    let tagColor: String
    let level: Int
    let defaultTime: Int
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
    static func getColor(color: String) -> Color {
        switch color {
        case "blue":
            return .blue
        case "black":
            return .black
        case "brown":
            return Color.init(hex: "964B00")
        case "pink":
            return Color.pink.opacity(0.5)
        case "orange":
            return Color.orange.opacity(0.5)
        case "yellow":
            return Color.init(hex: "#F5EB53")
        case "tan":
            return Color.init(hex: "#F9AA71")
        case "turq":
            return Color.init(hex: "#3CAEA2")
        case "skyblue":
            return Color.blue.opacity(0.5)
        case "lightgreen":
            return Color.green.opacity(0.5)
        case "red":
            return Color.red
        case "green":
            return Color.init(hex: "#165C12")
        case "gray":
            return Color.gray
        case "purple":
            return Color.init(hex: "#5351C0")
        default:
            return Color.white
        }
    }
}
//TODO
//update when finish timer and equip new pet, add total minutes and shortcut
// add notifications slider
// add default time
struct focuswidgetEntryView : View {
    var entry: Provider.Entry
    private static let deeplinkURL: URL = URL(string: "widget-deeplink://")!

    var body: some View {
          let data = entry.timeData.map { (str) -> Float in
              let num = Float(str) ?? 0
              return num
          }
        ZStack {
            Color(hex: "#D4C2FF").edgesIgnoringSafeArea(.all)
            HStack {
                GeometryReader { geo in
                    VStack {
                        Link(destination: URL(string: "widget://link3")!)  {
                            HStack {
                                Image("chest")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35, alignment: .leading)
                                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 20, trailing: -5))
                                HStack {
                                    VStack {
                                        Text("⏱")
                                            .font(Font.custom("Menlo", size: 13))
                                            .scaledToFill()
                                            .minimumScaleFactor(0.5)
                                            .lineLimit(1)
                                            .multilineTextAlignment(.leading)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: -5, trailing: 0))
                                        Circle().foregroundColor(Color.getColor(color: entry.tagColor))
                                            .frame(width: 10, height: 10, alignment: .leading)
                                    }.padding(EdgeInsets(top:0, leading: 0, bottom: 10, trailing: -7))
                                    VStack {
                                        Text(String(entry.defaultTime))
                                            .font(Font.custom("Menlo", size: 13))
                                            .scaledToFit()
                                            .minimumScaleFactor(0.5)
                                            .lineLimit(1)
                                            .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: 10))
                                        Text(entry.tagName)
                                            .font(Font.custom("Menlo", size: 13))
                                            .scaledToFit()
                                            .minimumScaleFactor(0.5)
                                            .lineLimit(1)

                                    }  .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 5))
                                }
                            }.padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 5))
                        }
                        .widgetURL(focuswidgetEntryView.deeplinkURL)
                        .frame(width: geo.size.width, height: geo.size.height/2.5, alignment: .center)
                        .background(Color(hex: "#DBCCFF"))
                        .cornerRadius(15)


                        HStack {
                            Link(destination: URL(string: "pets://link3")!)  {
                                Spacer(minLength: 10)
                                Image(entry.pet)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50, alignment: .trailing)
                            }
                            VStack {
                                HStack {
                                    Image("exp").resizable().scaledToFit()
                                        .frame(width: 25, height: 25, alignment: .leading)
                                        .padding(EdgeInsets(top: 0, leading: -17, bottom: 0, trailing: -5))

                                    Text(String(entry.level)).font(Font.custom("Menlo-Bold", size: 17)).scaledToFill()
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(1)
                                }.padding(EdgeInsets(top: 0, leading: 0, bottom: -5, trailing: 0))
                                HStack {
                                    Image("coins").resizable().scaledToFit().frame(width: 18, height: 18, alignment: .leading).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    Text(String(entry.coins)).font(Font.custom("Menlo-Bold", size: 17)).scaledToFill()
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(1)
                                }
                            }
                            Spacer(minLength: 5)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 10))
                        .frame(width: geo.size.width, height: geo.size.height/2.5, alignment: .center)

                    }
                }.padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 30))

                GeometryReader { geo in

                VStack {
                    Link(destination: URL(string: "stats://link3")!)  {
                        ZStack {
                            BarChartView(data:ChartData(points: data), title: "Sun - Sat", style: ChartStyle(backgroundColor: Color(hex: "#B3B1FA"), accentColor: Color(hex: "#5351C0"), secondGradientColor: Color(hex: "#5351C0"), textColor: Color.black, legendTextColor: Color.white, dropShadowColor: Color.gray.opacity(0.5)), form: ChartForm.small).scaledToFit()
                            if entry.noData {
                                VStack {
                                    Text("No Data Yet!").font(Font.custom("Menlo-Bold", size: 15)).foregroundColor(Color.black.opacity(0.5)).padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
                                    Text("😢 📊").padding(4)
                                    }
                            } else {
                                Text("Total: \(Int(entry.totalMins)) mins").font(Font.custom("Menlo", size: 13)).scaledToFill()
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 40))
                            }
                        }.frame(width: geo.size.width * 0.80, height: geo.size.height * 0.80, alignment: .center).padding(EdgeInsets(top: 0, leading: 0, bottom: -5, trailing: 0))
                    }
                }.padding(EdgeInsets(top: 15, leading: 5, bottom: 10, trailing: 10))
                }
                Spacer(minLength: 20)
            }
        }.environment(\.colorScheme, .light)
    }
}

@main
struct focuswidget: Widget {
    let kind: String = "focuswidget"
    let description: String = "Monitor how you spend your time and stay motivated"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            focuswidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Time Distribution")
        .description(description)
        .supportedFamilies([.systemMedium])
    }
}


struct focuswidget_Previews: PreviewProvider {
    static var previews: some View {
        focuswidgetEntryView(entry: SimpleEntry(date: Date(),timeData: ["0"], pet: "gray cat", totalMins: 0, noData: true, coins: 0, tagName: "unset", tagColor: "gray", level: 1,defaultTime:25, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

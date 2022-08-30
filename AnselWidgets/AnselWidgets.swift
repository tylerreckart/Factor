//
//  AnselWidgets.swift
//  AnselWidgets
//
//  Created by Tyler Reckart on 8/30/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct AnselWidgetEntryView : View {
    var entry: Provider.Entry
    let image: String
    let label: String
    let background: Color
    let url: URL

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: image)
                .imageScale(.large)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
            Text(label)
                .font(.system(.body))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .foregroundColor(.white)
        .background(background)
        .overlay(LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
        .widgetURL(url)
    }
}

struct NotesWidget: Widget {
    let kind: String = "NotesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AnselWidgetEntryView(
                entry: entry,
                image: "bookmark.circle.fill",
                label: "Notes",
                background: Color(.systemYellow),
                url: URL(string: "ansel:notes")!
            )
        }
        .configurationDisplayName("Ansel Notebook")
        .description("Access the Ansel notebook directly from your home screen.")
        .supportedFamilies([.systemSmall])
    }
}

struct ReciprocityWidget: Widget {
    let kind: String = "ReciprocityWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AnselWidgetEntryView(
                entry: entry,
                image: "moon.stars.circle.fill",
                label: "Reciprocity",
                background: Color(.systemPurple),
                url: URL(string: "ansel:reciprocity")!
            )
        }
        .configurationDisplayName("Recirprocity Factor")
        .description("Access the Ansel reciprocity calculator directly from your home screen.")
        .supportedFamilies([.systemSmall])
    }
}

struct FilterWidget: Widget {
    let kind: String = "FilterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AnselWidgetEntryView(
                entry: entry,
                image: "cloud.circle.fill",
                label: "Filter Factor",
                background: Color(.systemGreen),
                url: URL(string: "ansel:filterfactor")!
            )
        }
        .configurationDisplayName("Filter Factor")
        .description("Access the Ansel filter factor calculator directly from your home screen.")
        .supportedFamilies([.systemSmall])
    }
}

struct BellowsWidget: Widget {
    let kind: String = "BellowsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AnselWidgetEntryView(
                entry: entry,
                image: "arrow.up.backward.and.arrow.down.forward.circle.fill",
                label: "Bellows Extension Factor",
                background: Color(.systemBlue),
                url: URL(string: "ansel:bellowsfactor")!
            )
        }
        .configurationDisplayName("Bellows Extension Factor")
        .description("Access the Ansel filter factor calculator directly from your home screen.")
        .supportedFamilies([.systemSmall])
    }
}

@main
struct AnselWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        NotesWidget()
        ReciprocityWidget()
        FilterWidget()
        BellowsWidget()
    }
}

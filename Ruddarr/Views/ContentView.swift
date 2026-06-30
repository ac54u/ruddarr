import SwiftUI

#if os(iOS)
struct ContentView: View {
    @EnvironmentObject var settings: AppSettings
    @Environment(\.deviceType) private var deviceType

    var body: some View {
        TabView(selection: selectedTab) {
            MoviesView()
                .tabItem { Label(movies.label, image: movies.icon) }
                .tag(TabItem.movies)

            SeriesView()
                .tabItem { Label(series.label, image: series.icon) }
                .tag(TabItem.series)

            CalendarView()
                .tabItem { Label(calendar.label, systemImage: calendar.icon) }
                .tag(TabItem.calendar)

            ActivityView()
                .tabItem { Label(activity.label, systemImage: activity.icon) }
                .tag(TabItem.activity)
                .badge(Queue.shared.itemsWithIssues)

            if deviceType == .pad {
                HistoryView()
                    .tabItem { Label(history.label, systemImage: history.icon) }
                    .tag(TabItem.history)
            }

            SettingsView()
                .tabItem { Label(TabItem.settings.label, systemImage: TabItem.settings.icon) }
                .tag(TabItem.settings)
        }
        .onAppear {
            if !isRunningIn(.preview) {
                dependencies.router.selectedTab = settings.tab
            }

            UITabBarItem.appearance().badgeColor = UIColor(settings.theme.tint)
        }
        .onBecomeActive(perform: handleScenePhaseChange)
        .displayToasts()
        .whatsNewSheet()
        .reportBugSheet()
    }

    var movies: TabItem { .movies }
    var series: TabItem { .series }
    var calendar: TabItem { .calendar }
    var activity: TabItem { .activity }
    var history: TabItem { .history }

    var selectedTab: Binding<TabItem> {
        Binding<TabItem>(
            get: {
                dependencies.router.selectedTab
            },
            set: {
                let from = dependencies.router.selectedTab
                dependencies.router.selectedTab = $0
                handleTabChange(from, $0)
            }
        )
    }

    func handleScenePhaseChange() async {
        Telemetry.maybePing(with: settings)
        Notifications.maybeUpdateWebhooks(settings)
    }

    func handleTabChange(_ from: TabItem, _ to: TabItem) {
        guard from == to else { return }

        switch to {
        case .calendar: NotificationCenter.default.post(name: .scrollToToday)
        default: break
        }
    }
}
#endif

#Preview {
    ContentView()
        .withAppState()
}

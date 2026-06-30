import SwiftUI

struct DeviceTypeKey: EnvironmentKey {
    static let defaultValue: DeviceType = .unspecified
}

struct PresentBugSheetKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

// swiftlint:disable:next implicit_optional_initialization
struct InCalendarSheetKey: EnvironmentKey {
    static let defaultValue: CalendarSheetContext? = nil
}

extension EnvironmentValues {
    var deviceType: DeviceType {
        get { self[DeviceTypeKey.self] }
        set { self[DeviceTypeKey.self] = newValue }
    }

    var presentBugSheet: Binding<Bool> {
        get { self[PresentBugSheetKey.self] }
        set { self[PresentBugSheetKey.self] = newValue }
    }

    var inCalendarSheet: CalendarSheetContext? {
        get { self[InCalendarSheetKey.self] }
        set { self[InCalendarSheetKey.self] = newValue }
    }
}

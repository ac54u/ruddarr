import Foundation
import Sentry

class Migrations {
    static let key = "schemaVersion"

    static func run() {
        guard let current = currentBuild() else { return }

        let stored = storedSchema()

        if stored != current {
            migrateFrom(stored ?? 0, to: current)
            save(current)
        }
    }

    private static func migrateFrom(_ from: Int, to: Int) {
        Occurrence.forget("telemetryUploaded")

        // ...
    }

    private static func currentBuild() -> Int? {
        let rawVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String

        guard let string = rawVersion, let build = Int(string) else {
            leaveBreadcrumb(.fatal, category: "migrations", message: "Could not parse CFBundleVersion", data: ["version": rawVersion ?? "nil"])

            return nil
        }

        return build
    }

    private static func storedSchema() -> Int? {
        let value = dependencies.store.integer(forKey: key)
        return value > 0 ? value : nil
    }

    private static func save(_ build: Int) {
        dependencies.store.set(build, forKey: key)
    }
}

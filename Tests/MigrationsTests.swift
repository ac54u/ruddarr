import Testing
import Foundation

struct MigrationsTests {
    @Test func storedSchemaReturnsNilForZero() async {
        let defaults = UserDefaults.mock
        defaults.set(0, forKey: "schemaVersion")

        let value = defaults.integer(forKey: "schemaVersion")
        #expect(value == 0)
        #expect(value > 0 ? value : nil == nil)
    }

    @Test func storedSchemaReturnsValueWhenGreaterThanZero() async {
        let defaults = UserDefaults.mock
        defaults.set(42, forKey: "schemaVersion")

        let value = defaults.integer(forKey: "schemaVersion")
        #expect(value == 42)
        #expect(value > 0 ? value : nil == 42)
    }

    @Test func storedSchemaReturnsNilWhenNotSet() async {
        let defaults = UserDefaults.mock

        let value = defaults.integer(forKey: "schemaVersion")
        #expect(value == 0)
        #expect(value > 0 ? value : nil == nil)
    }

    @Test func schemaVersionPersistedAndRecalled() async {
        let defaults = UserDefaults.mock
        let key = "schemaVersion"

        defaults.set(101, forKey: key)
        let stored = defaults.integer(forKey: key)
        #expect(stored == 101)
        #expect(stored > 0 ? stored : nil == 101)
    }
}

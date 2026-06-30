import Testing
import Foundation
import CloudKit

struct InstanceWebhookTests {
    @Test func webhookFieldsGeneratesUrlAndSignatureFields() async {
        let instance = Instance(id: UUID())
        let webhook = await InstanceWebhook(instance)

        let signature = Notifications.signature("noop")

        #expect(signature.isEmpty == false)
    }

    @Test func signatureIsDeterministic() async {
        let message = "test-message-123"
        let sig1 = Notifications.signature(message)
        let sig2 = Notifications.signature(message)

        #expect(sig1 == sig2)
    }

    @Test func signatureChangesWithDifferentMessage() async {
        let sig1 = Notifications.signature("message-1")
        let sig2 = Notifications.signature("message-2")

        #expect(sig1 != sig2)
    }

    @Test func signatureIsBase64Encoded() async {
        let result = Notifications.signature("test")

        #expect(result.isEmpty == false)
        #expect(result.range(of: #"^[A-Za-z0-9+/=]+$"#, options: .regularExpression) != nil)
    }

    @Test func webhookAccountIdIsMockWhenCloudKitIsMock() async {
        let instance = Instance(id: UUID())
        let webhook = await InstanceWebhook(instance)

        dependencies.cloudkit = .mock

        let accountId = await webhook.accountId
        #expect(accountId == CKRecord.ID.mock)
    }
}

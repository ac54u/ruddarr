import Testing
import Foundation

struct APIErrorTests {
    @Test func voidErrorHasDescription() async {
        let error: API.Error = .void
        #expect(error.errorDescription != nil)
    }

    @Test func invalidUrlErrorIncludesUrlInRecoverySuggestion() async {
        let error: API.Error = .invalidUrl("bad url")
        #expect(error.errorDescription != nil)
        let recovery = error.recoverySuggestion
        #expect(recovery != nil)
        #expect(recovery!.contains("bad url"))
    }

    @Test func badStatusCodeErrorIncludesCode() async {
        let error: API.Error = .badStatusCode(code: 500)
        #expect(error.recoverySuggestion != nil)
        #expect(error.recoverySuggestion!.contains("500"))
    }

    @Test func errorResponseIncludesCodeAndMessage() async {
        let error: API.Error = .errorResponse(code: 404, message: "Not Found")
        let recovery = error.recoverySuggestion
        #expect(recovery != nil)
        #expect(recovery!.contains("404"))
        #expect(recovery!.contains("Not Found"))
    }

    @Test func notConnectedToInternetHasDescription() async {
        let error: API.Error = .notConnectedToInternet
        #expect(error.errorDescription == NoInternet.Title)
    }

    @Test func timeoutOnPrivateIpRecoveryIsHelpful() async {
        let urlError = URLError(.timedOut)
        let error: API.Error = .timeoutOnPrivateIp(urlError)
        let recovery = error.recoverySuggestion
        #expect(recovery != nil)
        #expect(recovery!.contains("private IP"))
    }

    @Test func decodingErrorIncludesCodingPath() async {
        let context = DecodingError.Context(
            codingPath: [],
            debugDescription: "Expected String but found Int"
        )
        let decodingError = DecodingError.typeMismatch(String.self, context)
        let error: API.Error = .decodingError(decodingError)
        #expect(error.recoverySuggestion != nil)
        #expect(error.recoverySuggestion!.contains("Expected String"))
    }

    @Test func urlErrorIncludesUnderlyingDescription() async {
        let urlError = URLError(.badServerResponse)
        let error: API.Error = .urlError(urlError)
        #expect(error.recoverySuggestion == urlError.localizedDescription)
    }

    @Test func nsErrorIncludesLocalizedDescription() async {
        let nsError = NSError(domain: "Test", code: 42, userInfo: [NSLocalizedDescriptionKey: "test failure"])
        let error: API.Error = .nsError(nsError)
        #expect(error.recoverySuggestion == "test failure")
    }

    @Test func genericErrorIncludesUnderlyingError() async {
        let appError = AppError("some error occurred")
        let error: API.Error = .error(appError)
        #expect(error.recoverySuggestion != nil)
        #expect(error.recoverySuggestion!.contains("some error occurred"))
    }

    @Test func allErrorCasesHaveNonNilDescriptions() async {
        let cases: [API.Error] = [
            .void,
            .invalidUrl(""),
            .badStatusCode(code: 0),
            .errorResponse(code: 0, message: ""),
            .notConnectedToInternet,
            .timeoutOnPrivateIp(URLError(.timedOut)),
            .decodingError(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: ""))),
            .appError(AppError("")),
            .localizedError(AppError("")),
            .urlError(URLError(.unknown)),
            .nsError(NSError(domain: "", code: 0)),
            .error(AppError("")),
        ]

        for error in cases {
            #expect(error.errorDescription != nil, "\(error) has nil errorDescription")
            #expect(error.recoverySuggestionFallback.isEmpty == false, "\(error) has empty recoverySuggestionFallback")
        }
    }
}

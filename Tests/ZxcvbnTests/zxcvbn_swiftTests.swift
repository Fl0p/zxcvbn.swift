import XCTest
@testable import Zxcvbn

final class ZxcvbnTests: XCTestCase {
    func testSurnames() {
        let matcher = Matcher()
        let matches = matcher.omnimatch(password: "mary", userInputs: [])
        XCTAssert(matches.contains { $0.dictionaryName == "female_names" })
        XCTAssert(matches.contains { $0.pattern == "dictionary" })
        XCTAssertFalse(matches.contains { $0.l33t })
    }

    func testL33tSpeak() {
        let matcher = Matcher()
        let matches = matcher.omnimatch(password: "P455w0RD", userInputs: [])
        XCTAssert(matches.contains { $0.l33t })
        XCTAssertFalse(matches.contains { $0.dictionaryName == "surnames" })
    }

    func testSpatialMatch() {
        let matcher = Matcher()
        let matches = matcher.omnimatch(password: "qwerty", userInputs: [])
        XCTAssert(matches.contains { $0.pattern == "spatial" })
    }

    func testRepeatMatch() {
        let matcher = Matcher()
        let matches = matcher.omnimatch(password: "aaaaaaaa", userInputs: [])
        XCTAssert(matches.contains { $0.pattern == "repeat" })
    }

    func testSequenceMatch() {
        let matcher = Matcher()
        let matches = matcher.omnimatch(password: "rstuvwx", userInputs: [])
        XCTAssert(matches.contains { $0.pattern == "sequence" })
    }
}

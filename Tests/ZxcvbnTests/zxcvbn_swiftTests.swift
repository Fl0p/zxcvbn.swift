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

    func testDigitsMatch() {
        let matcher = Matcher()
        let matches = matcher.omnimatch(password: "43207+o[n{}enoenctds+)*420420", userInputs: [])
        XCTAssert(matches.contains { $0.pattern == "digits" })
    }

    func testYearMatch() {
        let matcher = Matcher()
        let matches = matcher.omnimatch(password: "iosnhtpdrnteon1984oshentos", userInputs: [])
        XCTAssert(matches.contains { $0.pattern == "year" })
    }

    func testDateMatch() {
        let matcher = Matcher()
        let matches = matcher.omnimatch(password: "iosnhtpdrnteon25-05-1984sohe", userInputs: [])
        XCTAssert(matches.contains { $0.pattern == "date" })
    }

    func testEasyPassword() {
        let zxcvbn = Zxcvbn()
        XCTAssertEqual(zxcvbn.passwordStrength("easy password").value, 0)
    }

    func testEasyPassword1() {
        let zxcvbn = Zxcvbn()
        let score = zxcvbn.passwordStrength("easy password2")
        XCTAssertEqual(score.value, 1)
        XCTAssertEqual(score.entropy, "21.011")
    }

    func testStrongPassword() {
        let zxcvbn = Zxcvbn()
        let result = zxcvbn.passwordStrength("dkgit dldig394595 &&(3")
        XCTAssertEqual(result.value, 4)
        XCTAssertEqual(result.entropy, "100.877")
    }

    func testEmptyPassword() {
        let zxcvbn = Zxcvbn()
        XCTAssertEqual(zxcvbn.passwordStrength("").value, 0)
    }

    func testPasswordCompare() {
        let zxcvbn = Zxcvbn()
        let result1 = zxcvbn.passwordStrength("PSabcdrvst2025")
        let result2 = zxcvbn.passwordStrength("PSabcdrvst2025$")

        XCTAssertGreaterThan(result2.crackTime, result1.crackTime)

        XCTAssertEqual(result1.entropy, "49.761")
        XCTAssertEqual(result2.entropy, "60.025")
    }
}

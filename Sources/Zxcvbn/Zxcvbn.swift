
import QuartzCore

public struct Zxcvbn {

    public func passwordStrength(_ password: String, userInputs: [String] = []) -> Score {
        let start = CACurrentMediaTime()
        let matches = Matcher().omnimatch(password: password, userInputs: userInputs)
        var score = Scorer().minimumEntropyMatch(password: password, matches: matches)
        let end = CACurrentMediaTime()

        score.calcTime = (end - start) * 1000
        return score
    }
}

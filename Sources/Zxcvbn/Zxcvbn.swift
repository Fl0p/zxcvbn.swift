import Foundation
#if os(iOS)
import QuartzCore
#endif


public struct Zxcvbn {
    public init() {
    }

    public func passwordStrength(_ password: String, userInputs: [String] = []) -> Score {
        
        let start = getCurrentTime()
        let matches = Matcher().omnimatch(password: password, userInputs: userInputs)
        var score = Scorer().minimumEntropyMatch(password: password, matches: matches)
        let end = getCurrentTime()

        score.calcTime = (end - start) * 1000
        return score
    }
    
    private func getCurrentTime() -> TimeInterval {
        #if os(iOS)
        return CACurrentMediaTime()
        #elseif os(watchOS)
        return ProcessInfo.processInfo.systemUptime
        #else
        return 0
        #endif
    }
}


import Foundation

public struct Score {
    let password: String
    let entropy: String
    let crackTime: String
    let crackTimeDisplay: String
    let value: Int
    let matchSequence: [Any]
    let calcTime: Double
}

public struct Scorer {
    public func minimumEntropyMatch(password: String, matches: [String]) -> Score {
        let bruteforceCardinality = calculateBruteforceCardinality(password: password)
        var upToK = [Double]()

        fatalError("Not implemented")


    }
}

private extension Scorer {
    func calculateBruteforceCardinality(password: String) -> Double {
        var digits = 0.0
        var upper = 0.0
        var lower = 0.0
        var symbols = 0.0

        password.utf8.forEach { char in
            let scalar = Unicode.Scalar(char)
            if CharacterSet.decimalDigits.contains(scalar) {
                digits = 10
            } else if CharacterSet.uppercaseLetters.contains(scalar) {
                upper = 26
            } else if CharacterSet.lowercaseLetters.contains(scalar) {
                lower = 26
            } else {
                symbols = 33
            }
        }

        return digits + upper + lower + symbols
    }

}


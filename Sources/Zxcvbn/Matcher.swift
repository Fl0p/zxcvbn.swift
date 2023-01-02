
import Foundation

typealias MatcherBlock = (String) -> [Match]

public struct MatchResources {
    let dictionaryMatchers: [Any]
    let graphs: [String: [String: [String]]]

    static var shared: Self = MatchResources(dictionaryMatchers: [], graphs: [:])
}

public struct Match {
    let pattern: String
    let token: String
    let i: Int
    let j: Int
    let entropy: Double
    let cardinality: Int

    // Dictionary
    let matchedWord: String
    let dictionaryName: String
    let rank: Int
    let baseEntropy: Double
    let upperCaseEntropy: Double

    // l33t
    let l33t: Bool
    let sub: [AnyHashable: Any]
    let subDisplay: String
    let l33tEntropy: Int

    // Spatial
    let graph: String
    let turns: Int
    let shiftedCount: Int

    // Repeat
    let repeatedChar: String

    // Sequence
    let sequenceName: String
    let sequenceSpace: Int
    let ascending: Bool

    // Date
    let day: Int
    let month: Int
    let year: Int
    let separator: String
}

public struct Matcher {

    public let keyboardAverageDegree: Double
    public let keypadAverage: Double
    public let keyboardStartingPositions: Int
    public let keypadStartingPositions: Int
    private let dictionaryMatchers: [Any]
    private let graphs: [String: [String: [String]]]
    private let matchers: [MatcherBlock]

    public init() {
        let resource = MatchResources.shared
        dictionaryMatchers = resource.dictionaryMatchers
        graphs = resource.graphs
        keyboardAverageDegree = Self.calculateAverageDegree(graph: resource.graphs["qwerty"]!)
        keypadAverage = Self.calculateAverageDegree(graph: resource.graphs["keypad"]!)

        keyboardStartingPositions = resource.graphs["qwerty"]!.count
        keypadStartingPositions = resource.graphs["keypad"]!.count

        matchers = [Self.l33tMatch]
    }
}

public extension Matcher {

    func omnimatch(password: String, userInputs: [Any]) -> [Any] {
        return []
    }
}

private extension Matcher {

    // returns the list of possible 1337 replacement dictionaries for a given password
    static func enumerateL33tSubs(table: [String: String]) -> [[String: String]] {
        var subs: [[[String]]] = [[]]

        func dedup(subs: [[[String]]]) -> [[[String]]] {
            var deduped = [[[String]]]()
            var members = [String]()

            for sub in subs {
                let assoc = sub.sorted(by: { $0[0].caseInsensitiveCompare($1[0]) == .orderedAscending })

                var kvs = [String]()
                for kv in assoc {
                    kvs.append(kv.joined(separator: ","))
                }
                let label = kvs.joined(separator: "-")
                if !members.contains(label) {
                    members.append(label)
                    deduped.append(sub)
                }
            }
            return deduped
        }
        return []
    }

    static func l33tMatch(_ password: String) -> [Match] {
        var matches = [Any]()

        return []
    }

    static var l33tTable: [String: [String]] {
        [
        "a": ["4", "@"],
        "b": ["8"],
        "c": ["(", "{", "[", "<"],
        "e": ["3"],
        "g": ["6", "9"],
        "i": ["1", "!", "|"],
        "l": ["1", "|", "7"],
        "o": ["0"],
        "s": ["$", "5"],
        "t": ["+", "7"],
        "x": ["%"],
        "z": ["2"]
        ]
    }
}

private extension Matcher {
    static func calculateAverageDegree(graph: [String: [String]]) -> Double {
        // on qwerty, 'g' has degree 6, being adjacent to 'ftyhbv'. '\' has degree 1.
        // this calculates the average over all keys.

        var average = 0.0

        for key in graph.keys {
            var neighbors = [String]()
            for n in (graph[key] ?? []) {
                neighbors.append(n)
            }
            average += Double(neighbors.count)
        }
        average /= Double(graph.count)
        return average
    }
}

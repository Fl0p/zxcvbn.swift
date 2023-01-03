
import Foundation

typealias MatcherBlock = (String) -> [Match]

public struct MatchResources {
    let dictionaryMatchers: [MatcherBlock]
    let graphs: [String: [String: [String]]]

    static var shared: Self = MatchResources(dictionaryMatchers: [], graphs: [:])
}

public struct Match {
    let pattern: String
    var token: String
    let i: String.Index
    let j: String.Index
    let entropy: Double
    let cardinality: Int

    // Dictionary
    let matchedWord: String
    let dictionaryName: String
    let rank: Int
    let baseEntropy: Double
    let upperCaseEntropy: Double

    // l33t
    var l33t: Bool
    var sub: [AnyHashable: Any]
    var subDisplay: String
    var l33tEntropy: Int

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

class Box<Value> {
    var value: Value
    init(_ value: Value) {
        self.value = value
    }
}

public struct Matcher {

    private let dictionaryMatchers: [MatcherBlock]
    private let graphs: [String: [String: [String]]]
    private var matchers: Box<[MatcherBlock]>

    public init() {
        let resource = MatchResources.shared
        dictionaryMatchers = resource.dictionaryMatchers
        graphs = resource.graphs

        matchers = Box([])
        matchers.value = [l33tMatch]
    }

    public var keyboardAverageDegree: Double {
        calculateAverageDegree(graph: graphs["qwerty"]!)
    }
    public var keypadAverage: Double {
        calculateAverageDegree(graph: graphs["keypad"]!)
    }

    public var keyboardStartingPositions: Int {
        graphs["qwerty"]!.count
    }

    public var keypadStartingPositions: Int {
        graphs["keypad"]!.count
    }
}

public extension Matcher {

    func omnimatch(password: String, userInputs: [Any]) -> [Any] {
        return []
    }
}

private extension Matcher {

    // returns the list of possible 1337 replacement dictionaries for a given password
    func enumerateL33tSubs(table: [String: [String]]) -> [[String: String]] {
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

        var keys = Array(table.keys)

        while keys.count > 0 {
            let firstKey = keys[0]
            let restKeys = Array(keys.dropFirst())
            var nextSubs = [[[String]]]()

            for l33tChar in (table[firstKey] ?? []) {
                for sub in subs {
                    var dupL33tIndex = -1
                    for i in 0..<sub.count {
                        if sub[i][0] == l33tChar {
                            dupL33tIndex = i
                            break
                        }
                    }

                    if dupL33tIndex == -1 {
                        var subExtension = sub
                        subExtension.append([String(l33tChar), firstKey])
                        nextSubs.append(subExtension)
                    } else {
                        var subAlternative = sub
                        subAlternative.remove(at: dupL33tIndex)
                        subAlternative.append([String(l33tChar), firstKey])
                        nextSubs.append(sub)
                        nextSubs.append(subAlternative)
                    }
                }
            }

            subs = dedup(subs: nextSubs)
            keys = restKeys
        }

        // Convert from assoc lists to dicts
        var subDicts = [[String: String]]()
        for sub in subs {
            var subDict = [String: String]()
            for pair in sub {
                subDict[pair[0]] = pair[1]
            }

            subDicts.append(subDict)
        }

        return subDicts
    }

    // makes a pruned copy of l33t_table that only includes password's possible substitutions
    func relevantL33tSubtable(for password: String) -> [String: [String]] {
        var filtered = [String: [String]]()

        for letter in Self.l33tTable.keys {
            let subs = Self.l33tTable[letter]!
            var relevantSubs = [String]()

            for sub in subs {
                if password.contains(sub) {
                    relevantSubs.append(sub)
                }
            }
            if !relevantSubs.isEmpty {
                filtered[String(letter)] = relevantSubs
            }
        }
        return filtered
    }

    func l33tMatch(_ password: String) -> [Match] {
        var matches = [Match]()

        for sub in enumerateL33tSubs(table: relevantL33tSubtable(for: password)) {
            if sub.isEmpty {
                break
            }

            let subbedPassword = translate(password, characterMap: sub)

            for matcher in dictionaryMatchers {
                for match in matcher(subbedPassword) {
                    let token = password[match.i..<match.j]
                    // only return the matches that contain an actual substitution
                    if token.lowercased() == match.matchedWord {
                        continue
                    }

                    var matchSub = [String: String]()
                    var subDisplay = [String]()

                    for (subbedChar, char) in sub {
                        if token.contains(subbedChar) {
                            matchSub[subbedChar] = char
                            subDisplay.append("\(subbedChar) -> \(char)")
                        }
                    }

                    var match = match

                    match.l33t = true
                    match.token = String(token)
                    match.subDisplay = subDisplay.joined(separator: ",")
                    matches.append(match)
                }
            }

        }

        return matches
    }

    func translate(_ string: String, characterMap: [String: String]) -> String {
        var string = string
        for (key, value) in characterMap {
            string = string.replacingOccurrences(of: key, with: value)
        }
        return string
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
    func calculateAverageDegree(graph: [String: [String]]) -> Double {
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

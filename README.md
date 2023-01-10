# zxcvbn.swift

A description of this package.
```
.................................................bbb....................
.zzzzzzzzzz..xxx....xxx....cccccccc..vvv....vvv..bbb.........nnnnnnn....
.....zzzz......xxxxxx....cccc........vvv....vvv..bbbbbbbb....nnn...nnn..
...zzzz........xxxxxx....cccc..........vvvvvv....bbb....bb...nnn...nnn..
.zzzzzzzzzz..xxx....xxx....cccccccc......vv......bbbbbbbb....nnn...nnn..
........................................................................
```

An swift port of zxcvbn, a password strength estimation library, designed for iOS.

`Zxcvbn` attempts to give sound password advice through pattern matching
and conservative entropy calculations. It finds 10k common passwords,
common American names and surnames, common English words, and common
patterns like dates, repeats (aaa), sequences (abcd), and QWERTY
patterns.

Check out the original [Objective-c](https://github.com/dropbox/zxcvbn-ios) or the [Python port](https://github.com/dropbox/python-zxcvbn).

For full motivation, see [zxcvbn: realistic password strength estimation](https://blogs.dropbox.com/tech/2012/04/zxcvbn-realistic-password-strength-estimation/).

# Use

```swift
import Zxcvbn

let zxcvbn Zxcvbn()
let score = zxcvbn.passwordStrength(password, userInputs: userInputs)
```

The `Score` includes a few properties:

``` objc
score.entropy           // bits

score.crackTime         // estimation of actual crack time, in seconds.

score.crackTimeDisplay  // same crack time, as a friendlier string:
                        // "instant", "6 minutes", "centuries", etc.

score.value             // [0,1,2,3,4] if crack time is less than
                        // [10**2, 10**4, 10**6, 10**8, Infinity].
                        // (useful for implementing a strength bar.)

score.matchSequence     // the list of patterns that zxcvbn based the
                        // entropy calculation on.

score.calcTime          // how long it took to calculate an answer,
                        // in milliseconds. usually only a few ms.
````

The optional `userInputs` argument is an array of strings that `Zxcvbn`
will add to its internal dictionary. This can be whatever list of
strings you like, but is meant for user inputs from other fields of the
form, like name and email. That way a password that includes the user's
personal info can be heavily penalized. This list is also good for
site-specific vocabulary.

# Acknowledgments

A huge thanks to [Dan Wheeler](https://github.com/lowe) for the original [CoffeeScript implementation](https://github.com/dropbox/zxcvbn). Thanks to [Ryan Pearl](https://github.com/dropbox/python-zxcvbn) for his [Python port](). I've enjoyed copying your code :)

Echoing the acknowledgments from earlier libraries...

Many thanks to Mark Burnett for releasing his 10k top passwords list:

http://xato.net/passwords/more-top-worst-passwords

and for his 2006 book,
"Perfect Passwords: Selection, Protection, Authentication"

Huge thanks to Wiktionary contributors for building a frequency list
of English as used in television and movies:
http://en.wiktionary.org/wiki/Wiktionary:Frequency_lists


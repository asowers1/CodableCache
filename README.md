<p align="center">
  <img src="https://raw.githubusercontent.com/asowers1/CodableCache/master/CodableCache.png">
</p>

<br>

![](https://travis-ci.org/asowers1/CodableCache.svg?branch=master)
![Platforms](https://img.shields.io/badge/platforms-iOS%20|%20watchOS%20|%20macOS%20|%20tvOS-blue.svg)
![Languages](https://img.shields.io/badge/languages-Swift%204-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-green.svg?style=flat)][Carthage]
[![Cocoapods compatible](https://img.shields.io/badge/Cocoapods-compatible-green.svg)][Cocoapods]
![License](https://img.shields.io/badge/license-MIT-blue.svg)

[Carthage]: https://github.com/carthage/carthage
[Cocoapods]: https://cocoapods.org

# 📦📲 CodableCache
What is `CodableCache`? It's a framework that allows for seamless memory caching and disk persistence of your plain old Swift structs. Simply define a model and conform to [Codable](https://developer.apple.com/documentation/swift/codable) – you're ready to use `CodableCache`.

# 📋🧐 Features

- [x] Simple to use transparent cache based on keys and generic types
- [x] Anything that's `Codable` works automatically
- [x] No serializers to write other than optional custom `Codable` encode/decode
- [x] Works with images via codable wrapper
- [x] Easy to integrate into existing workflows
- [x] backed by battle tested NSCache and NSKeyedArchiver
- [ ] batteries included - by design, it's up to you to create workflows and handle cache errors

# 🎓📕 Some History
Codable Cache is a drop in replacement for my [LeanCache](https://github.com/asowers1/LeanCache) framework, which was backed by specifying generic types conforming to `NSCoding`. It afforded workflows like `let x: NSNumber? = Cache<NSNumber>("some interesting key")` and that's still great, but writing serializers for `NSCoding` is a pain. Hence, `CodableCache` was born.

# 👩‍💻👨‍💻 Example Code

To get started, just import CodableCache, define a model that conforms to codable, and get coding. These are just a few examples of how you could use CodableCache.

#### Create a person manager backed by a persistent cache:

```swift
import CodableCache

struct Person: Codable {
    let name: String
    let age: Double // kids are half ages if you recall 😜
}

final class PersonManager {

    let cache: CodableCache<Person>

    init(cacheKey: AnyHashable) {
        cache = CodableCache<Person>(key: cacheKey)
    }

    func getPerson() -> Person? {
        return cache.get()
    }

    func set(person: Person) throws {
        cache.set(value: person)
    }


}


```
##### And later use it like so:
```swift

var myPerson = Person(name: "Andrew", age: 26)

let personManager = PersonManager(cacheKey: "myPerson")

try? personManager.set(value: myPerson)

if let person = personManager.get() {
    print(person.name) // "Andrew"
    print(person.age) // 26
}
```
#### Cache JSON with confidence:

```swift

import CodableCache

//...

struct TestData: Codable {
  let testing: [Int]
}

func saveJSON() {

    let json = """
        {
            "testing": [
                1,
                2,
                3
            ]
        }
    """

    guard let data = json.data(using: .utf8) else {
        return
    }

    let decodedTestData: TestData
    do {
        decodedTestData = try decoder.decode(TestData.self, from: data)
        try codableCache.set(value: decodedTestData)
    } catch {
        // do something else
        return
    }
}

```



#### Get your cached JSON for later use:


```swift
import CodableCache


final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let appSettings = CodableCache<Settings>(key: "com.myApp.settings")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if let settings = appSettings.get() {
            doSomethingUseful(with: settings)
        }

        return true
    }

    // ...
}

```

#### Specify a different storage directory:

```swift
import CodableCache

struct Person: Codable {
    let name: String
    let age: Double
}

// this data will not be purged by the system like .cachesDirectory would
let persistentPersonStorage = CodableCache<Person>(key: "myPerson", directory: .applicationSupportDirectory)


```

#### Creating a generic cache:

```swift
import CodableCache

final class GenericCache<Cacheable: Codable> {

    let cache: CodableCache<Cacheable>

    init(cacheKey: AnyHashable) {
        self.cache = CodableCache<Cacheable>(key: cacheKey)
    }

    func get() -> Cacheable? {
        return self.cache.get()
    }

    func set(value: Cacheable) throws {
        try self.cache.set(value: value)
    }

    func clear() throws {
        try self.cache.clear()
    }
}
```

##### And later use it like so:
```swift
let myCache = GenericCache<MyType>(cacheKey: String(describing: MyType.self))
```

## 😓🙃 Gotchas

##### Custom Encoders/Decoders
Make sure you're decoding as optional if your values are optionally typed

```swift
    func testCustomDecoder() {
        struct Foo: Codable {
            var bar: String? = ""
            
            private enum CodingKeys: String, CodingKey {
                case bar
            }
            
            init(bar: String?) {
                self.bar = bar
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.bar = try container.decode(String.self, forKey: .bar)
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.bar, forKey: .bar)
            }
        }
        
        let foo0 = Foo(bar: "Hello World")
        
        let foo1 = Foo(bar: nil)
        
        let fooCache = CodableCache<Foo>(key: String(describing: Foo.self))
        
        try? fooCache.set(value: foo0)
        // this is not nil because decoder expected `String`
        XCTAssertNotNil(fooCache.get())
        
        try? fooCache.set(value: foo1)
        // this is nil because decoder expected `String`, but it was given what we'd expect for `String?`
        XCTAssertNil(fooCache.get())
    }
```
To make the decoder work in this scenario, you would want to decode `Foo.bar` as `String?` like so:
```swift
self.bar = try container.decode(String?.self, forKey: .bar)
```

## 👩‍🔬 👨‍🎨 Philosophy

Using something heavyweight like CoreData, Realm, or SQLite is often overkill. More often than not we're just backing up some local state based on some JSON interface – using a spaceship for a walk down the block 🚀. Typically, we display this data to the user if it isn't stale and update it from the network if need be. Sorting and reordering is often a server side task, so relational databases and object graphs might be too expensive in terms of upstart modeling and your management time. With `CodableCache` we take a different approach by allowing you to quickly define models, skip boilerplate / serializers, and start saving your data at a lightning pace.

## 💻 🚀 Installation

#### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build CodableCache.

To integrate CodableCache into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
use_frameworks!

target '<Your Target Name>' do
    pod 'CodableCache'
end
```

Then, run the following command:

```bash
$ pod install
```


#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate CodableCache into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "asowers1/CodableCache" "master"
```

Run

```
carthage update
```
In your application targets “General” tab under the “Linked Frameworks and Libraries” section, drag and drop CodableCache-iOS.framework from the Carthage/Build/iOS directory that `carthage update` produced.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but Alamofire does support its use on supported platforms. 

Once you have your Swift package set up, adding CodableCache as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.


```swift
dependencies: [
    .Package(url: "https://github.com/asowers1/CodableCache.git")
]
```

## 🙋 🙋‍♂️ Contributing

Feel free to open an issue or pull request – I would be happy to help.


## 👩‍🔧 👨‍🔧 Authors and Contributors

[Andrew Sowers](http://asowers.net)

[Joe Fabisevich](https://fabisevi.ch)



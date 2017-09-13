<center>
![](https://raw.githubusercontent.com/asowers1/CodableCache/master/CodableCache.png)
</center>
<br>
<br>

![Platforms](https://img.shields.io/badge/platforms-iOS%20|%20watchOS%20|%20macOS%20|%20tvOS-blue.svg)
![Languages](https://img.shields.io/badge/languages-Swift%204-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-orange.svg?style=flat)][Carthage]
[![Cocoapods compatible](https://img.shields.io/badge/Cocoapods-compatible-red.svg
)][Cocoapods]
![License](https://img.shields.io/badge/license-MIT-blue.svg)

[Carthage]: https://github.com/carthage/carthage
[Cocoapods]: https://cocoapods.org


# 📦📲 CodableCache
What is Codable Cache? It's a framework that allows for seamless memory caching and disk persistence of your plain old Swift structs. Simply define a model and conform to [Encodable](https://developer.apple.com/documentation/swift/encodable) – you're ready to use Codable Cache.

# 🎓📕 Some History
Codable Cache is a drop in replacement for my [LeanCache](https://github.com/asowers1/LeanCache) framework, which was backed by specifying generic types conforming to `NSCoding`. It afforded workflows like `let x: NSNumber? = Cache<NSNumber>("some interesting key")` and that's still great, but writing serializers for `NSCoding` is a pain. Hence, `CodableCache` was born.

# 👩‍💻👨‍💻 Example Code

To get started, just import CodableCache, define a model that conforms to codable, and get coding. These are just a few examples of how you could use CodableCache.

##### Create a person manager backed by a persistent cache:

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

    func getPerson() throws -> Person {
        cache.get()
    }
    
    func set(person: Person) throws {
        cache.set(value: person)
    }


}


```

##### Cache JSON with confidence:

```swift

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
            doErrorStuff()
            return
        }

```



##### Get your cached JSON for later use:


```swift
import CodableCache


final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let appSettings = CodableCache<Settings>(key: "com.myApp.settings")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        do {
            let settings = try appSettings.get()
            doSomethingUseful(with: settings)
        } catch {
            // do something else
        }
        
        return true
    }
    
    // ...
}

```
        

## 💻 🚀 Installation

#### Cocoapods

```
pod install CodableCache
```

#### Carthage

Get [Carthage](https://github.com/Carthage/Carthage)

Add CodableCache to your Cartfile

```
github "asowers1/CodableCache" "master"
```

run

```
carthage update
```
In your application targets “General” tab under the “Linked Frameworks and Libraries” section, drag and drop CodableCache-iOS.framework from the Carthage/Build/iOS directory that `carthage update` produced.


## 🙋 🙋‍♂️ Contributing

Feel free to open and issue or pull request – I would be happy to help.


## 👩‍🔧 👨‍🔧 Authors and Contributors

[Andrew Sowers](http://asowers.net)


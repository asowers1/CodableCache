[logo]: ./CodableCache.svg "CodableCache Logo"

<center>
![alt text][logo]
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
What is Codable Cache? It's a framework that allows for seamless memory caching and disk persistence of your plain old Swift structs. Simply define a model and conform to `Encodable` – you're ready to use Codable Cache.

#🎓📕 Some History
Codable Cache is a drop in replacement for my [LeanCache](https://github.com/asowers1/LeanCache) framework, which was backed by specifying generic types conforming to `NSCoding`. It afforded workflows like `let x: NSNumber? = Cache<NSNumber>("some interesting key")` and that's still great, but writing serializers for `NSCoding` is a pain. Hence, `CodableCache` was born.

# 👩‍💻👨‍💻 Example Code

To get started, just import CodableCache, define a model that conforms to codable, and get coding.

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


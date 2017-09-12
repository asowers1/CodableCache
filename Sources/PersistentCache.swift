//
//  PersistentCache.swift
//  CodableCache
//
//  Created by Andrew Sowers on 9/10/17.
//  Copyright © 2017 CodableCache. All rights reserved.
//

import Foundation

struct PersistentCache<T: Codable> {
    
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    private let fileManager: FileManager
    private let cacheDirectory: URL

    private let key: AnyHashable
    
    init(key: AnyHashable, encoder: JSONEncoder, decoder: JSONDecoder) {
        self.encoder = encoder
        self.decoder = decoder
        self.fileManager = FileManager.default
        let cachesDirectory = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.cacheDirectory = cachesDirectory.appendingPathComponent(key.description)
        self.key = key
    }
    
    
}

// MARK - Filemanager helpers

extension PersistentCache {    
    func filePathForKey(_ key: AnyHashable) -> String {
        return self.cacheDirectory.appendingPathComponent(key.description).path
    }
}

// MARK: - workflow operations

extension PersistentCache {
    
    func get(_ key: AnyHashable) throws -> T {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: self.filePathForKey(key)) as? Data else {
            throw CodableCacheError<T>.valueNotFound(withKey: key)
        }
        return try decoder.decode(T.self, from: data)
    }
    
    func set(_ value: T, forKey key: AnyHashable)  throws {
        let data = try encoder.encode(value)
        try self.fileManager.createDirectory(at: self.cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        NSKeyedArchiver.archiveRootObject(data, toFile: self.filePathForKey(key))
    }
    
    func clear() {
        do {
            try self.fileManager.removeItem(at: self.cacheDirectory)
        } catch _ {
        }
    }
    
    
}

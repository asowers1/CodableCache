//
//  PersistentCache.swift
//  CodableCache
//
//  Created by Andrew Sowers on 9/10/17.
//  Copyright © 2017 CodableCache. All rights reserved.
//

import Foundation

struct PersistentCache<T: Codable> {
    
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    
    let fileManager: FileManager
    let cacheDirectory: URL

    let key: AnyHashable
    
    init(key: AnyHashable, encoder: JSONEncoder, decoder: JSONDecoder, directory: FileManager.SearchPathDirectory, searchPathDomainMask: FileManager.SearchPathDomainMask) {
        self.encoder = encoder
        self.decoder = decoder
        self.fileManager = FileManager.default
        let cachesDirectory = self.fileManager.urls(for: directory, in: searchPathDomainMask).first!
        self.cacheDirectory = cachesDirectory.appendingPathComponent(String(key.description))
        self.key = key
    }
    
    
}

// MARK - Filemanager helpers

extension PersistentCache {    
    public func filePathForKey(_ key: AnyHashable) -> String {
        return self.cacheDirectory.appendingPathComponent(String(key.description)).path
    }
}

// MARK: - workflow operations

extension PersistentCache {
    
    public func get(_ key: AnyHashable) -> T? {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: self.filePathForKey(key)) as? Data else {
            return nil
        }
        
        guard let decoded = try? decoder.decode(T.self, from: data) else {
            return nil
        }

        return decoded
    }
    
    public func set(_ value: T, forKey key: AnyHashable) throws {
        let data = try encoder.encode(value)
        try self.fileManager.createDirectory(at: self.cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        NSKeyedArchiver.archiveRootObject(data, toFile: self.filePathForKey(key))
    }
    
    public func set(_ value: [T], forKey key: AnyHashable) throws {
        let encodedValues = try value.map { try encoder.encode($0) }
        try self.fileManager.createDirectory(at: self.cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        NSKeyedArchiver.archiveRootObject(encodedValues, toFile: self.filePathForKey(key))
    }
    
    public func clear() throws {
        try self.fileManager.removeItem(at: self.cacheDirectory)
    }

}

//
//  CodableCacheError.swift
//  CodableCache
//
//  Created by Andrew Sowers on 9/11/17.
//  Copyright © 2017 CodableCache. All rights reserved.
//

import Foundation

public enum CodableCacheError<T: Codable>: Error {
    case valueNotFound(withKey: AnyHashable)
}


//
//  SwingStoreSingleton.swift
//  SwingWatch WatchKit Extension
//
//  Created by Rob Andrews on 3/8/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation

class SwingStore{
    static let singleton = SwingStore()
    var _store : [String: Swing]
    var _lastId : String
    
    init() {
        self._store = [String: Swing]()
        self._lastId = ""
    }
    
    func addSwingToStore(swing: Swing, cacheKey: String) -> Void
    {
        self._lastId = cacheKey
        self._store[cacheKey] = swing
    }
    
    func getSwingFromStore(cacheKey: String) -> Swing?
    {
        return self._store[cacheKey]
    }
    
    func getLastSwingFromStore() -> Swing?
    {
        return self._store[self._lastId]
    }
}

//
//  ApiCacheManager.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/4/23.
//

import Foundation

//Manages in memory api caches
final class ApiCacheManger {
    private var cacheDictionary : [
        AstellaEndpoints : NSCache<NSString, NSData>
    ] = [:]
    
    //Cache by API url
    private var cache = NSCache<NSString, NSData>()
    
    init() {
        setUpCache()
    }
    
    private func setUpCache() {
        AstellaEndpoints.allCases.forEach({ endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        })
    }
    
    //MARK: - get cache items
    public func cacheResponse(for endpoint : AstellaEndpoints, url : URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url, endpoint != AstellaEndpoints.ADD_USER_TO_EVENT,
              endpoint != AstellaEndpoints.GET_EVENTS_MEMBER_OF, endpoint != AstellaEndpoints.GET_EVENT_BY_CITY
        else {
            return nil
        }
        return targetCache.object(forKey: url.absoluteString as NSString) as? Data
    }
    
    public func setCache(for endpoint : AstellaEndpoints, url : URL?, data : Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return
        }
        targetCache.setObject(data as NSData, forKey: url.absoluteString as NSString) 
    }
}

///The more we have specific cache managers, we wll reduce how much stuff is removed from cache

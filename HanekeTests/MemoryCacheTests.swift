//
//  MemoryCacheTests.swift
//  Haneke
//
//  Created by Luis Ascorbe on 23/07/14.
//  Copyright (c) 2014 Haneke. All rights reserved.
//

import Foundation
import UIKit
import XCTest
import Haneke

class MemoryCacheTests: XCTestCase {
    
    var sut : MemoryCache?
    
    override func setUp() {
        super.setUp()
        sut = MemoryCache("test")
    }
    
    func testInit() {
        let name = "name"
        let sut = MemoryCache(name)
        
        XCTAssertNotNil(sut.memoryWarningObserver)
        XCTAssertEqual(name, sut.name)
    }
    
    func testDeinit() {
        weak var sut = MemoryCache("test")
    }
    
    func testSetImage () {
        let sut = self.sut!
        let image = UIImage()
        let key = "key"
        
        sut.setImage(image, key)
    }
    
    func testFetchImage () {
        let sut = self.sut!
        let key = "key"
        
        XCTAssert(sut.fetchImage(key) == nil, "MemoryCache is empty")
        
        let image = UIImage()
        sut.setImage(image, key)
        
        XCTAssert(sut.fetchImage(key) != nil, "MemoryCache is not empty")
    }
    
    func testFetchImageWithNilKey () {
        let sut = self.sut!
        
        XCTAssert(sut.fetchImage(nil) == nil, "nil key should returns nil image")
    }
    
    func testFetchImageEqualImage () {
        let sut = self.sut!
        
        let image = UIImage.imageWithColor(UIColor.cyanColor(), CGSizeMake(30, 30), true)
        let key = "key"
        
        sut.setImage(image, key)
        
        XCTAssert(image.isEqualPixelByPixel(sut.fetchImage(key)), "Fetched image is equal to the original one.")
    }
    
    func testRemoveImageExisting() {
        let sut = self.sut!
        let key = "key"
        sut.setImage(UIImage(), key)
        
        sut.removeImage(key)
        
        XCTAssertNil(sut.fetchImage(key))
    }
    
    func testRemoveImageInexisting() {
        let sut = self.sut!
        
        sut.removeImage("key")
    }
    
    func testOnMemoryWarning() {
        let sut = self.sut!
        let key = "key"
        sut.setImage(UIImage(), key)
        XCTAssertNotNil(sut.fetchImage(key))
        
        sut.onMemoryWarning()
        
        XCTAssertNil(sut.fetchImage(key))
    }
    
    func testUIApplicationDidReceiveMemoryWarningNotification() {
        let expectation = expectationWithDescription("onMemoryWarning")
        
        class MemoryCacheMock : MemoryCache {
            
            var expectation : XCTestExpectation?
            
            override func onMemoryWarning() {
                super.onMemoryWarning()
                expectation!.fulfill()
            }
        }
        
        let sut = MemoryCacheMock("test")
        sut.expectation = expectation // XCode crashes if we use the original expectation directly
        
        NSNotificationCenter.defaultCenter().postNotificationName(UIApplicationDidReceiveMemoryWarningNotification, object: nil)
        
        waitForExpectationsWithTimeout(0, nil)
    }
}

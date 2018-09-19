//
//  DynamicValue.swift
//  Review
//
//  Created by Badrinath on 9/19/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//



//Purpose: First, to be able to bind values from our ViewModel to our View, we need element with an observable pattern. In iOS, we could use KVO pattern to add and remove observers, but I think we can do a bit better with “didSet” observer.

import Foundation

typealias CompletionHandler = (() -> Void)

class DynamicValue<T>{
    
    var value : T {
        didSet {
            self.notify()
        }
    }
    
    private var observers = [String: CompletionHandler]()
    
    init(_ value: T) {
        self.value = value
    }
    
    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }
    
    public func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }
    
    private func notify() {
        observers.forEach({ $0.value() })
    }
    
    deinit {
        observers.removeAll()
    }
}

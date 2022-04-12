//
//  Box.swift
//  MyLocation
//
//  Created by Mohammed Ibrahim on 12/4/22.
//

import Foundation

public final class Box<T>{
    typealias Listener = (T) -> Void
    var listener : Listener?
    
    var value : T {
        didSet{
            listener?(value)
        }
    }
    
    init(_ value: T){
        self.value = value
    }
    
    func bind (listener : Listener?){
        self.listener = listener
        listener?(value)
    }
}

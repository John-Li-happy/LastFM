//
//  ReusableCellProtocol.swift
//  Last.fm
//
//  Created by Tong Yi on 9/4/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation

@objc protocol ReusableCellProtocolObjC {
    static var reuseIdentifier: String { get }
}

protocol ReusableCellProtocol {
    static var reuseIdentifier: String { get }
}

extension ReusableCellProtocol {
    
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension ReusableCellProtocolObjC {
    
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

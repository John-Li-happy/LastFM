//
//  String+Ext.swift
//  Last.fm
//
//  Created by Amol Prakash on 11/08/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}

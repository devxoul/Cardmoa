//
//  LocalizedString.swift
//  StyleShare
//
//  Created by 전수열 on 11/6/14.
//  Copyright (c) 2014 StyleShare Inc. All rights reserved.
//

import Foundation

public func __(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

//
//  PropertyLoopable.swift
//  Meetup
//
//  Created by Kevin Nguyen on 7/9/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import UIKit

protocol PropertyLoopable {
    func allProperties() throws -> [String: Any]
}

extension PropertyLoopable {
    func allProperties() throws -> [String: Any] {
        var result: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        
        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }
            result[property] = value
        }
        return result
    }
}

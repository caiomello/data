//
//  Endpoint.swift
//  Services
//
//  Created by Caio on 6/27/19.
//  Copyright © 2019 Caio Mello. All rights reserved.
//

import Foundation

public protocol Endpoint {
    var url: String? { get }
    var parameters: [String: String]? { get }
}

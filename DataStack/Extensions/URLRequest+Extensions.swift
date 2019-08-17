//
//  URLRequest+Extensions.swift
//  DataStack
//
//  Created by Caio on 6/27/19.
//  Copyright © 2019 Caio Mello. All rights reserved.
//

import Foundation

extension URLRequest {
    public init(endpoint: Endpoint) {
        self.init(url: URL(endpoint: endpoint), cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
    }
}

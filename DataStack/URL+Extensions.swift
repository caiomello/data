//
//  URL+Extensions.swift
//  DataStack
//
//  Created by Caio on 6/27/19.
//  Copyright © 2019 Caio Mello. All rights reserved.
//

import Foundation

extension URL {
    init(endpoint: Endpoint) {
        guard let endpointURL = endpoint.url else { fatalError("Endpoint has no URL") }

        let url: String = {
            if let parameters = endpoint.parameters {
                return endpointURL + "?" + parameters.queryString()
            }

            return endpointURL
        }()

        self.init(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
}

extension Dictionary {
    fileprivate func queryString() -> String {
        let fields = map({ "\($0.key)=\($0.value)" })
        return fields.joined(separator: "&")
    }
}

//
//  String+HTML.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/18/21.
//

import Foundation


extension String {
    func strippingHTML() -> String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

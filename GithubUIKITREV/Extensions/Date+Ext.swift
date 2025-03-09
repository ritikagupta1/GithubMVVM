//
//  Date+Ext.swift
//  GithubUIKITREV
//
//  Created by Ritika Gupta on 08/03/25.
//

import Foundation
extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}

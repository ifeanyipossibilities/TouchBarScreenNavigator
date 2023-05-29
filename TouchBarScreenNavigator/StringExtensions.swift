//
//  SupportHelpers.swift
//  took this file from https://github.com/Toxblh/MTMR
//
//  Created by Anton Palgunov on 13/04/2018.
//  Copyright © 2018 Anton Palgunov. All rights reserved.
//

import Cocoa
import Foundation

extension String {
    var ifNotEmpty: String? {
        return count > 0 ? self : nil
    }
    
    
    func trim() -> String {
        return trimmingCharacters(in: NSCharacterSet.whitespaces)
    }

    func stripComments() -> String {
        // ((\s|,)\/\*[\s\S]*?\*\/)|(( |, ")\/\/.*)
        return replacingOccurrences(of: "((\\s|,)\\/\\*[\\s\\S]*?\\*\\/)|(( |, \\\")\\/\\/.*)", with: "", options: .regularExpression)
    }

    var hexColor: NSColor? {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6: // RGB (24-bit)
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        return NSColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}





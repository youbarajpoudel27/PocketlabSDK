//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 25/11/2023.
//

import SwiftUI

public extension UIColor {
    var color: Color {
        Color(uiColor: self)
    }
}

public extension Color {
    var uiColor: UIColor {
        UIColor(self)
    }
}

public extension UIColor {
    static var globalTintColor: UIColor?

    static public func setGlobalTintColor(_ color: Color) {
        globalTintColor = UIColor(color)
    }
}

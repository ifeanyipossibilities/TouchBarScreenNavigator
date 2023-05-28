//
//  MouseKey.swift
//  TouchBarScreenNavigator
//
//  Created by ifeanyi on 5/27/23.
//

import Foundation
//keyboard and mouse monitor
struct KeyboardEvent {
    var KeyCode = 0
    var Status = 0
}
struct CursorPosition {
    var PosX = 0.0
    var PosY = 0.0
    var MouseLeftStatus = 0
    var Keys = [KeyboardEvent]()
}

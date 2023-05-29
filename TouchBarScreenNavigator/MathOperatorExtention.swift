//
//  MathOperatorExtention.swift
//  TouchBarScreenNavigator
//
//  Created by ifeanyi on 5/29/23.
//

import Cocoa
import Foundation


//Custom Exponentiation operator in Swift
//derived from https://stackoverflow.com/questions/24065801/exponentiation-operator-in-swift
precedencegroup ExponeniationPrecedence {
    associativity: right  // This makes Towers of Powers work correctly
    higherThan: MultiplicationPrecedence
}


infix operator ** : ExponeniationPrecedence
public func **(_ x: Decimal, _ y: Int) -> Decimal {
    //print("_ \(x): Decimal, _ \(y): Int")
       var res = Decimal()
        var num = x
        NSDecimalPower(&res, &num, y, .plain)
        return res
    
}
public func **(_ base: Double, _ exponent: Double) -> Double {
    //print("_ \(base): Double, _ \(exponent): Double")
    return pow(base, exponent)
}
public func **(_ base: Float, _ exponent: Float) -> Float {
    //print("_ \(base): Float, _ \(exponent): Float")
    return powf(base, exponent)
}
public func **(_ base: Int, _ exponent: Int) -> Int {
    var result = 0
    //print("_ \(base): Int, _ \(exponent): Int")
    let test = pow(Decimal(base), exponent)
    let k = NSDecimalNumber(decimal: test)
    guard let nsDecimal = NSDecimalNumber(decimal: test) as? NSDecimalNumber,
                nsDecimal != NSDecimalNumber.notANumber else {
                
                return result
            }
    
    result = Int(truncating: k)
    return result
}

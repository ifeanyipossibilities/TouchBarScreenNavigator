
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




#if swift(>=4.1)
    // compactMap supported
#else
    extension Sequence {
        func compactMap<ElementOfResult>(_ transform: (Self.Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
            return try flatMap(transform)
        }
    }
#endif

extension String {
    var ifNotEmpty: String? {
        return count > 0 ? self : nil
    }
}




//extended
extension NSImage {
    
//    to save png
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    
    func DrwawImageAtPoint(anotherImage: NSImage,  atPoint point:NSPoint, toSize imSize: NSSize) -> NSImage {

            self.lockFocus()
            //draw your stuff here

            self.draw(in: CGRect(origin: .zero, size: size))
           let frame2 = CGRect(x: point.x, y: point.y, width: imSize.width, height: imSize.height)
            anotherImage.draw(in: frame2)

            self.unlockFocus()
            return self
        }

    

}

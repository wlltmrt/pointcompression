//
//  PointCompression
//
//  Copyright (c) 2020 Wellington Marthas
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import CoreLocation

public enum PointCompression {
    private static let lookupTable = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-")
    
    public static func encode(_ coordinates: [CLLocationCoordinate2D]) -> String {
        var value = String()
        
        var xlast: Int64 = 0
        var ylast: Int64 = 0
        
        for coordinate in coordinates {
            let xnew = Int64((coordinate.longitude * 100000).rounded())
            let ynew = Int64((coordinate.latitude * 100000).rounded())
            
            var dx = xnew - xlast
            var dy = ynew - ylast
            
            xlast = xnew
            ylast = ynew
            
            dx = (dx << 1) ^ (dx >> 31)
            dy = (dy << 1) ^ (dy >> 31)
            
            var i = ((dy + dx) * (dy + dx + 1) / 2) + dy
            
            while i > 0 {
                var rem = Int64(i & 31)
                i = (i - rem) / 32
                
                if (i > 0) {
                    rem += 32
                }
                
                value.append(lookupTable[Int(rem)])
            }
            
        }
        
        return value
    }
    
    public static func decode(_ value: String) -> [CLLocationCoordinate2D]? {
        var coordinates = [CLLocationCoordinate2D]()
        
        var i = 0
        var xsum = 0
        var ysum = 0
        
        while i < value.count {
            var n: Int64 = 0
            var k = 0
            
            while true {
                guard i >= value.count else {
                    return nil
                }
                
                guard let b = lookupTable.firstIndex(of: value[i]) else {
                    return nil
                }
                
                n |= (Int64(b) & 31) << k
                k += 5
                
                if b < 32 {
                    break
                }
                
                i = i + 1
            }
            
            let diagonal = Int(((8 * n + 5).squareRoot() - 1) / 2)
            
            n = n - Int64(diagonal * (diagonal + 1) / 2)
            
            var ny = Int(n)
            var nx = diagonal - ny
            
            nx = (nx >> 1) ^ -(nx & 1)
            ny = (ny >> 1) ^ -(ny & 1)
            
            xsum += nx
            ysum += ny
            
            coordinates.append(CLLocationCoordinate2D(latitude: Double(ysum) * 0.00001, longitude: Double(xsum) * 0.00001))
        }
        
        return coordinates
    }
}

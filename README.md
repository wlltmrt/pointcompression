# PointCompression

[![Build Status](https://travis-ci.org/wellmart/pointcompression.svg?branch=master)](https://travis-ci.org/wellmart/pointcompression)
[![Swift 5](https://img.shields.io/badge/swift-5-blue.svg)](https://developer.apple.com/swift/)
![Version](https://img.shields.io/badge/version-0.1.0-blue)
[![Software License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![Swift Package Manager Compatible](https://img.shields.io/badge/swift%20package%20manager-compatible-blue.svg)](https://github.com/apple/swift-package-manager)

A compression algorithm to encodes/decodes a collection of CLLocationCoordinate2D into a string. check out the post: [microsoft.com](https://docs.microsoft.com/en-us/bingmaps/v8-web-control/map-control-api/pointcompression-class).

## Requirements

Swift 5 and beyond.

## Usage

```swift
import CoreLocation
import PointCompression

extension CLLocationCoordinate2D {
    static func random() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(arc4random_uniform(140)) * 0.00001,
                                      longitude: Double(arc4random_uniform(140)) * 0.00001)
    }
}

func main() {
    var coordinates = [CLLocationCoordinate2D]()

    for _ in 0...3000 {
        coordinates.append(.random())
    }

    let stringValue = PointCompression.Encode(coordinates)
    let decodedCoordinates = PointCompression.Decode(stringValue)
}
```

## License

[MIT](https://choosealicense.com/licenses/mit/)

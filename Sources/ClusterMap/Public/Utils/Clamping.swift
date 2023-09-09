//
//  Clamping.swift
//
//
//  Created by Mikhail Vospennikov on 26.08.2023.
//

import Foundation

/// A property wrapper that clamps a `Comparable` value within a specified range.
///
/// Example:
/// ```swift
/// @Clamping(to: 1.0...5.0)
/// var value: Double = 1.0
///
/// value = 7  // `value` will be clamped to 5.0
/// value = 0  // `value` will be clamped to 1.0
/// ```
@propertyWrapper
public struct Clamping<Value: Comparable> {
    private var value: Value
    private var range: ClosedRange<Value>

    public var wrappedValue: Value {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }

    public init(wrappedValue defaultValue: Value, to range: ClosedRange<Value>) {
        value = defaultValue
        self.range = range
    }

    public init(wrappedValue defaultValue: Value, to range: Range<Value>) {
        let closedRange = range.lowerBound...range.upperBound
        self.init(wrappedValue: defaultValue, to: closedRange)
    }
}

public extension Clamping where Value: FloatingPoint {
    init(wrappedValue defaultValue: Value, to range: PartialRangeFrom<Value>) {
        let closedRange = range.lowerBound...Value.infinity
        self.init(wrappedValue: defaultValue, to: closedRange)
    }

    init(wrappedValue defaultValue: Value, to range: PartialRangeUpTo<Value>) {
        let closedRange = -Value.infinity...range.upperBound.nextDown
        self.init(wrappedValue: defaultValue, to: closedRange)
    }

    init(wrappedValue defaultValue: Value, to range: PartialRangeThrough<Value>) {
        let closedRange = -Value.infinity...range.upperBound
        self.init(wrappedValue: defaultValue, to: closedRange)
    }
}

public extension Clamping where Value: FixedWidthInteger {
    init(wrappedValue defaultValue: Value, to range: PartialRangeFrom<Value>) {
        let closedRange = range.lowerBound...Value.max
        self.init(wrappedValue: defaultValue, to: closedRange)
    }

    init(wrappedValue defaultValue: Value, to range: PartialRangeUpTo<Value>) {
        let closedRange = (Value.min)...(range.upperBound - 1)
        self.init(wrappedValue: defaultValue, to: closedRange)
    }

    init(wrappedValue defaultValue: Value, to range: PartialRangeThrough<Value>) {
        let closedRange = Value.min...range.upperBound
        self.init(wrappedValue: defaultValue, to: closedRange)
    }
}
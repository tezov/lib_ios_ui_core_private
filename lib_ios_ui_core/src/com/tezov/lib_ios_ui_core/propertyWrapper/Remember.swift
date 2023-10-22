import lib_ios_core
import SwiftUI

@propertyWrapper public struct Remember<T: Any>: DynamicProperty {
    @State @Lazy private var value: T

    public var wrappedValue: T {
        get { value }
        nonmutating set { value = newValue }
    }

    public init(wrappedValue: @escaping @autoclosure () -> T) {
        self._value = State(wrappedValue: Lazy(wrappedValue))
    }
    
    public init(_ value: @escaping () -> T) {
        self._value = State(wrappedValue: Lazy(value))
    }
    
}




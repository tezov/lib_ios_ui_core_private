import lib_ios_core
import SwiftUI
import Combine

open class ObservableFlow: ObservableObject {
    private var publishCancellable: Set<AnyCancellable> = []
    
    public init() {}
    
    public func publish<T>(_ publisher:Published<T>.Publisher){
        publisher.sink(
            receiveValue: { [weak self] values in
                guard let self else { return }
                objectWillChange.send()
            }
        ).store(in: &publishCancellable)
    }
    
}

@propertyWrapper public struct StateFlow<T: ObservableFlow>: DynamicProperty {
    @State private var state: Int = 0
    @ClassWrapper private var cancellable: AnyCancellable? = .none
    @ClassWrapper private var initializer: (() -> T)?
    @ClassWrapper private var value: T? = .none
    public var wrappedValue: T {
        value ?? {
            guard let initializer else { fatalError("RememberState initializer is nil") }
            _ = state //enfore install state in view else update doesn't work
            let value = initializer()
            self.initializer = .none
            self.value = value
            self.cancellable = value.objectWillChange.sink(
                receiveValue: { [$state] _ in $state.wrappedValue &+= 1 }
            )
            return value
        }()
    }
    
    public init(wrappedValue: @escaping @autoclosure () -> T) {
        self.initializer = wrappedValue
    }
    
    public init(_ initializer: @escaping () -> T) {
        self.initializer = initializer
    }

}

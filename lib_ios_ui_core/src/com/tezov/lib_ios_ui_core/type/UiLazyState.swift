import Foundation

public class UiLazyState<T:NSObject> {
    private var lazyValue:(()->T)?
    private var _value:T? = nil
    
    public init(_ lazyValue: @escaping ()->T) {
        self.lazyValue = lazyValue
    }
    
    public func get() -> T {
        return _value ?? {
            _value = lazyValue!()
            lazyValue = nil
            return _value!
        }()
    }
    
}

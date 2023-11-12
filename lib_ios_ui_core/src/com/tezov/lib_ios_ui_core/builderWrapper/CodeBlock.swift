import SwiftUI


@resultBuilder
public enum CodeBlockProperty {
    public static func buildBlock(_: Void...) -> EmptyView { EmptyView() }
}

@CodeBlockProperty
public func CodeBlock(_ block: () -> Void) -> EmptyView { block() }

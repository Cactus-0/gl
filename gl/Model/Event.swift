import Foundation

class Event<T> {
    typealias EventHandler = (T) -> ()

    private var eventHandlers: [EventHandler] = []

    func listen(_ handler: @escaping EventHandler) {
        eventHandlers.append(handler)
    }

    func emit(data: T) {
        eventHandlers.forEach { handler in handler(data) }
    }
}

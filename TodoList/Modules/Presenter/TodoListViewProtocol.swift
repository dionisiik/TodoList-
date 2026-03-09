import Foundation

protocol TodoListViewProtocol: AnyObject {
    func displayItems(_ items: [TodoItem])
    func displayError(_ message: String)
    func setLoading(_ isLoading: Bool)
}

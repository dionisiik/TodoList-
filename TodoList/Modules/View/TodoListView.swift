import SwiftUI

struct TodoListView: View {
    @StateObject private var presenter: TodoListPresenter
    @ObservedObject private var router: TodoListRouter
    @State private var searchText = ""
    
    init(presenter: TodoListPresenter, router: TodoListRouter) {
        _presenter = StateObject(wrappedValue: presenter)
        _router = ObservedObject(wrappedValue: router)
    }
    
    var body: some View {
        let p = presenter
        return NavigationStack {
            Group {
                if presenter.isLoading {
                    ProgressView("Загрузка...")
                } else {
                    List {
                        ForEach(presenter.items, id: \.id) { item in
                            listRow(for: item)
                        }
                    }
                }
            }
            
            .searchable(text: $searchText, prompt: "Поиск")
            .onChange(of: searchText) { _, newValue in
                presenter.searchChanged(newValue)
            }
            .navigationTitle("Задачи")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    ZStack(alignment: .center) {
                        Text("\(presenter.items.count) Задач")
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                        HStack {
                            Spacer(minLength: 0)
                            Button {
                                presenter.addTapped()
                            } label: {
                                Image(systemName: "square.and.pencil")
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .alert("Ошибка", isPresented: Binding(
                get: { p.errorMessage != nil },
                set: { if !$0 { p.clearError() } }
            )) {
                Button("OK") { p.clearError() }
            } message: {
                if let msg = p.errorMessage { Text(msg) }
            }
            .fullScreenCover(item: $router.presentedRoute) { route in
                switch route {
                case .add:
                    TodoTaskFormView(mode: .add,
                                     onDismiss: {router.dismiss()},
                                     onSaveNew: { title, taskDescription in
                        presenter.submitNewTask(title: title, taskDescription: taskDescription)
                    },
                                     onSaveEdit: { _ in }
                    )
                case .view(let item):
                    TodoTaskFormView(
                        mode: .view(item),
                        onDismiss: { router.dismiss() },
                        onSaveNew: { _, _ in },
                        onSaveEdit: { updated in
                            presenter.submitUpdatedTask(updated)
                        }
                    )
                case .edit(let item):
                    TodoTaskFormView(
                        mode: .edit(item),
                        onDismiss: { router.dismiss() },
                        onSaveNew: { _, _ in },
                        onSaveEdit: { updated in
                            presenter.submitUpdatedTask(updated)
                        }
                    )
                }
            }
        }
        .simultaneousGesture(
            TapGesture().onEnded { _ in
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
        )
        .onAppear { presenter.onAppear() }
    }
    
    @ViewBuilder
    private func listRow(for item: TodoItem) -> some View {
        let shareText = [item.title, item.taskDescription ?? ""].filter { !$0.isEmpty }.joined(separator: "\n\n")
        TodoListRowView(
            item: item,
            onToggleCompleted: { presenter.toggleCompleted(item) },
            onTapRow: { presenter.viewTapped(item: item) }
        )
        .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
        .alignmentGuide(.listRowSeparatorTrailing) { d in d[.trailing] }
        .listRowBackground(Color(uiColor: .systemBackground))
        .contextMenu {
            Button {
                presenter.editTapped(item: item)
            } label: {
                Label("Редактировать", image: "edit")
            }
            ShareLink(item: shareText, subject: Text(item.title), message: Text(item.taskDescription ?? "")) {
                Label("Поделиться", image: "export")
            }
            Button(role: .destructive) {
                presenter.deleteTapped(item)
            } label: {
                Label("Удалить", image: "trash")
            }
        }
        
    }
}

// MARK: - Preview
#Preview("Список задач") {
    TodoListModule.build()
}


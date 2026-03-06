

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
        NavigationStack {
            Group {
                if presenter.isLoading {
                    ProgressView("Загрузка...")
                } else {
                    List {
                        ForEach(presenter.items, id: \.id) { item in
                            TodoListRowView(item: item)
                                .contentShape(Rectangle())
                                .onTapGesture { presenter.editTapped(item: item) }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) { presenter.deleteTapped(item) } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .searchable(text: $searchText, prompt: "Поиск")
                    .onChange(of: searchText) { _, newValue in
                        presenter.searchChanged(newValue)
                    }
                }
            }
            .navigationTitle("Задачи")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { presenter.addTapped() } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Ошибка", isPresented: Binding(
                get: { presenter.errorMessage != nil },
                set: { if !$0 { presenter.clearError() } }
            )) {
                Button("OK") { presenter.clearError() }
            } message: {
                if let msg = presenter.errorMessage { Text(msg) }
            }
            .sheet(item: $router.presentedRoute) { route in
                switch route {
                case .add:
                    Text("Экран добавления — этап 8")
                case .edit(let item):
                    Text("Редактирование: \(item.title)")
                }
            }
        }
        .onAppear { presenter.onAppear() }
    }
}


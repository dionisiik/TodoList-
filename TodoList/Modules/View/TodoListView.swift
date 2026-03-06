

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
                    VStack(spacing: 0) {
                        HStack(spacing: 10) {
                            Image(systemName: "mic.fill")
                                .foregroundStyle(.secondary)
                                .font(.body)
                            TextField("Поиск", text: $searchText)
                                .textFieldStyle(.plain)
                                .onChange(of: searchText) { _, newValue in
                                    presenter.searchChanged(newValue)
                                }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(uiColor: .tertiarySystemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        .padding(.vertical, 8)

                        List {
                            ForEach(presenter.items, id: \.id) { item in
                                TodoListRowView(
                                    item: item,
                                    onToggleCompleted: { presenter.toggleCompleted(item) },
                                    onTapRow: { presenter.editTapped(item: item) }
                                )
                                .listRowBackground(Color(uiColor: .systemBackground))
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) { presenter.deleteTapped(item) } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }
                                }
                            }
                        }
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
                get: { p.errorMessage != nil },
                set: { if !$0 { p.clearError() } }
            )) {
                Button("OK") { p.clearError() }
            } message: {
                if let msg = p.errorMessage { Text(msg) }
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

// MARK: - Preview
#Preview("Список задач") {
    TodoListModule.build()
}


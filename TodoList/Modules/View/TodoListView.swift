

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
                            TodoListRowView(
                                item: item,
                                onToggleCompleted: { presenter.toggleCompleted(item) },
                                onTapRow: { presenter.editTapped(item: item) }
                            )
                            .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color(uiColor: .systemBackground))
                            .swipeActions(edge: .trailing, allowsFullSwipe: true)
                            {
                                Button(role: .destructive) { presenter.deleteTapped(item) } label: {
                                    Label("Удалить", systemImage: "trash")
                            
                                }
                            }
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
            .sheet(item: $router.presentedRoute) { route in
                switch route {
                case .add:
                    Text("Экран добавления — этап 8")
                case .edit(let item):
                    Text("Редактирование: \(item.title)")
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
}

// MARK: - Preview
#Preview("Список задач") {
    TodoListModule.build()
}


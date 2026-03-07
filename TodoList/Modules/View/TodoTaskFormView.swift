//
//  TodoTaskFormView.swift
//  TodoList
//
//  Created by Дионисий Коневиченко on 07.03.2026.
//

import SwiftUI

enum TodoTaskFormMode {
    case add
    case view(TodoItem)
    case edit(TodoItem)
}

struct TodoTaskFormView: View {
    let mode: TodoTaskFormMode
    let onDismiss: () -> Void
    let onSaveNew: (String, String?) -> Void
    let onSaveEdit: (TodoItem) -> Void

    private var initialItem: TodoItem? {
        switch mode {
        case .add: return nil
        case .view(let item), .edit(let item): return item
        }
    }
    
    private var isReadOnly: Bool {
        if case .view = mode { return !isEditing}
        return false
    }

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var isEditing = false
    
    

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if isReadOnly {
                        Text(title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    } else {
                        TextField("Название", text: $title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }

                    Text(AppDateFormatters.ddMMyy.string(from: date))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if isReadOnly {
                        Text(description.isEmpty ? "Без описания" : description)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                    } else {
                        TextEditor(text: $description)
                            .frame(minHeight: 200)
                            .scrollContentBackground(.hidden)
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding()
            }
            .padding(.trailing, 20)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if case .edit = mode {
                            onDismiss()
                        } else if isReadOnly {
                            onDismiss()
                        } else {
                            isEditing = false
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Назад")
                        }
                        .foregroundStyle(.yellow)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if isReadOnly {
                        Button("Изменить") {
                            isEditing = true
                        }
                        .foregroundStyle(.yellow)
                    } else {
                        Button("Сохранить") {
                            saveIfNeeded()
                            onDismiss()
                        }
                        .foregroundStyle(.yellow)
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
            .onAppear {
                if let item = initialItem {
                    title = item.title
                    description = item.taskDescription ?? ""
                    date = item.createdAt
                }
                if case .edit = mode {
                    isEditing = true
                }
            }
        }
    }

    private func saveIfNeeded() {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }

        let desc = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let descOrNil = desc.isEmpty ? nil : desc

        switch mode {
        case .add:
            onSaveNew(t, descOrNil)
        case .view(let item), .edit(let item):
            let updated = TodoItem(
                id: item.id,
                title: t,
                taskDescription: descOrNil,
                createdAt: date,
                completed: item.completed
            )
            onSaveEdit(updated)
        }
    }
}

//
//  TodoListRowView.swift
//  TodoList
//
//  Created by Дионисий Коневиченко on 06.03.2026.
//

import SwiftUI


struct TodoListRowView: View {
    let item: TodoItem
    var onToggleCompleted: (() -> Void)? = nil
    var onTapRow: (() -> Void)? = nil
    

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                onToggleCompleted?()
            } label: {
                Image( item.completed ? "marked" : "unmarked")
                    .foregroundStyle(item.completed ? .green : .secondary)
                    .frame(width: 24, height: 24)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 16, weight: .medium))
                if let desc = item.taskDescription, !desc.isEmpty {
                    Text(desc)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text(AppDateFormatters.ddMMyy.string(from: item.createdAt))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture { onTapRow?() }
        }
        .frame(maxWidth: .infinity, minHeight: 90)
        
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview("Ячейка задачи") {
    List {
        TodoListRowView(
            item: TodoItem(
                id: 1,
                title: "Пример задачи",
                taskDescription: "Описание для превью",
                createdAt: Date(),
                completed: false
            ),
            onToggleCompleted: {},
            onTapRow: {}
        )
        TodoListRowView(
            item: TodoItem(
                id: 2,
                title: "Выполненная задача",
                taskDescription: nil,
                createdAt: Date().addingTimeInterval(-86400),
                completed: true
            ),
            onToggleCompleted: {},
            onTapRow: {}
        )
    }
}


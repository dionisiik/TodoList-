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
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                if let desc = item.taskDescription, !desc.isEmpty {
                    Text(desc)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(item.createdAt, style: .date)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture { onTapRow?() }
        }
        .padding(.vertical, 4)
    }}


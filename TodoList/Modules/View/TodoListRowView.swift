//
//  TodoListRowView.swift
//  TodoList
//
//  Created by Дионисий Коневиченко on 06.03.2026.
//

import SwiftUI


struct TodoListRowView: View {
    let item: TodoItem
    
    var body: some View {
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
            HStack {
                Spacer()
                Image(systemName: item.completed ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(item.completed ? .green : .secondary)
            }
        }
        .padding(.vertical, 4)
    }
}


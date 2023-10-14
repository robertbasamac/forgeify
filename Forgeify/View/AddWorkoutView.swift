//
//  AddWorkoutView.swift
//  Forgeify
//
//  Created by Robert Basamac on 28.09.2023.
//

import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var exercises: [WorkoutExercise] = []
    @State private var showAddExercise: Bool = false
    
    var body: some View {
        Form {
            titleSection()
            exercisesSection()
            addButton()
        }
        .navigationTitle("Create new Workout")
        .toolbar {
            toolbarItems()
        }
        .navigationDestination(for: WorkoutExercise.self) { exercise in
            ExerciseDetailView(exercise: exercise)
        }
        .navigationDestination(isPresented: $showAddExercise) {
            ExerciseSelectionView(selections: $exercises)
        }
    }
}

// MARK: - Helper Methods
extension AddWorkoutView {
    private func isSaveButtonDisabled() -> Bool {
        return title.isEmpty
    }
    
    private func delete(at offsets: IndexSet) {
        withAnimation {
            exercises.remove(atOffsets: offsets)
        }
    }
    
    private func move(fromOffsets source: IndexSet, toOffsets destination: Int) {
        withAnimation {
            exercises.move(fromOffsets: source, toOffset: destination)
        }
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving the context.")
        }
    }
}


// MARK: - View Components
extension AddWorkoutView {
    @ViewBuilder
    private func titleSection() -> some View {
        Section(header: Text("Workout Title")) {
            TextField("Enter title here…", text: $title)
                .padding(.trailing, 30)
                .overlay(alignment: .trailing) {
                    Button {
                        title = ""
                    } label: {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .opacity(title.isEmpty ? 0 : 1)
                }
        }
    }
    
    @ViewBuilder
    private func exercisesSection() -> some View {
        if !exercises.isEmpty {
            Section {
                ForEach(exercises) { exercise in
                    ExerciseListItem(exercise: exercise)
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            } header: {
                Text("Exercises")
            }
        }
    }
    
    @ViewBuilder
    private func addButton() -> some View {
        Button {
            showAddExercise.toggle()
        } label: {
            Label("Add Exercises", systemImage: "plus")
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                dismiss()
            }
        }
        
        ToolbarItemGroup(placement: .topBarTrailing) {
            EditButton()
            
            Button("Save") {
                let workout = Workout(title: title, exercises: exercises)
                
                modelContext.insert(workout)
                
                do {
                    try modelContext.save()
                } catch {
                    print("Error saving the context.")
                }
                
                dismiss()
            }
            .disabled(isSaveButtonDisabled())
        }
    }
}

// MARK: - Preview
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            AddWorkoutView()
        }
    }
}

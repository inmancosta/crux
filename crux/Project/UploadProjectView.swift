import SwiftUI

struct CreateProjectView: View {
    @StateObject private var viewModel = ProjectViewModel()
    @Environment(\.dismiss) private var dismiss

    // Define the available difficulty levels
    let difficultyLevels = ["Easy", "Medium", "Hard"]
    
    // Define available tags
    let availableTags = ["Software", "Data Science", "AI", "App Dev", "Web Dev", "Machine Learning", "Backend", "Frontend"]

    var body: some View {
        VStack {
            // Project Name
            TextField("Project Name", text: $viewModel.name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            // Project Description
            TextField("Description", text: $viewModel.description, axis: .vertical)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .frame(height: 100) // Adjust to make multiline
            

            // Difficulty Picker
            Picker("Difficulty", selection: $viewModel.difficultyLevel) {
                ForEach(difficultyLevels, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(WheelPickerStyle()) // Optional: You can use SegmentedPickerStyle or DefaultPickerStyle based on preference
            .padding()

            // Tags (Multiple Selection)
            VStack(alignment: .leading) {
                Text("Tags")
                    .font(.headline)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(availableTags, id: \.self) { tag in
                            Button(action: {
                                toggleTagSelection(tag: tag)
                            }) {
                                Text(tag)
                                    .padding(8)
                                    .background(viewModel.tags.contains(tag) ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            
            // Skills (Simple text input for now, could later be expanded)
            TextField("Skills (comma separated)", text: $viewModel.skillsInput)

                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            // Upload Button
            Button(action: {
                Task {
                    do {
                        try await viewModel.uploadProject()
                        print("Project uploaded successfully")
                        dismiss()
                    } catch {
                        print("Failed to upload project: \(error)")
                    }
                }
            }) {
                Text("Upload Project")
                    .font(.headline)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
        }
        .padding()
    }
    
    // Function to toggle tag selection
    private func toggleTagSelection(tag: String) {
        if let index = viewModel.tags.firstIndex(of: tag) {
            viewModel.tags.remove(at: index)
        } else {
            viewModel.tags.append(tag)
        }
    }
}

struct CreateProjectView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProjectView()
    }
}

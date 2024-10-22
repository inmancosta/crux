import SwiftUI

struct CreateProjectView: View {
    @StateObject private var viewModel = ProjectViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            TextField("Project Name", text: $viewModel.name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            TextField("Description", text: $viewModel.description)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            TextField("Difficulty Level", text: $viewModel.difficultyLevel)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            // Add input fields for skills and tags as needed
            
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
}

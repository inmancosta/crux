import SwiftUI

struct ProjectListView: View {
    @StateObject private var viewModel = ProjectViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {  // Use ScrollView instead of List for more control over the background
                VStack(spacing: 0) {
                    ForEach(viewModel.projects) { project in
                        Button(action: {
                            // Navigation action when card is tapped
                        }) {
                            NavigationLink(destination: ProjectDetailView(project: project)) {
                                                        ProjectCardView(project: project)
                                                    }
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove any button styling (like arrows)
                    }
                }
                .padding()
            }
            .background(Color(.systemGray6)) // Set your desired background color
            .navigationTitle("Projects")
            .onAppear {
                Task {
                    do {
                        try await viewModel.fetchProjects()
                    } catch {
                        print("Failed to fetch projects: \(error)")
                    }
                }
            }
        }
    }
}

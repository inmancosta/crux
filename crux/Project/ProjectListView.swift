import SwiftUI

struct ProjectListView: View {
    @StateObject private var viewModel = ProjectViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                Text("Projects")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    //.padding(.leading)
                                    //.padding(.top)
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    
                    // Web Dev Section
                    Text("Web Development")
                        .font(.headline)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.projects.filter { $0.tags.contains("Web Dev") }) { project in
                                NavigationLink(destination: ProjectDetailView(project: project)) {
                                    ProjectCardView(project: project)
                                        .frame(width: 200) // Adjust card width as needed
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // App Dev Section
                    Text("App Development")
                        .font(.headline)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.projects.filter { $0.tags.contains("App Dev") }) { project in
                                NavigationLink(destination: ProjectDetailView(project: project)) {
                                    ProjectCardView(project: project)
                                        .frame(width: 200) // Adjust card width as needed
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // AI Section
                    Text("AI")
                        .font(.headline)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.projects.filter { $0.tags.contains("AI") }) { project in
                                NavigationLink(destination: ProjectDetailView(project: project)) {
                                    ProjectCardView(project: project)
                                        .frame(width: 200) // Adjust card width as needed
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGray6))
            //.navigationTitle("Projects")
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

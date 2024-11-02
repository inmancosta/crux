import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                Button(action: {
                    Task {
                        try await ProjectManager.shared.requestToJoinProject(projectId: project.id)
                    }
                }) {
                    Text("Request to Join Project")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                }

                Text(project.name)
                    .font(.largeTitle)
                    .bold()
                
                Text("Created by: \(project.createdBy)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Difficulty Level: \(project.difficultyLevel)")
                    .font(.subheadline)
                
                Text("Date Created: \(project.dateCreated, formatter: dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Description")
                    .font(.headline)
                    .padding(.top, 10)
                
                Text(project.description)
                    .font(.body)
                
                Text("Skills")
                    .font(.headline)
                    .padding(.top, 10)
                
                ForEach(project.skills, id: \.self) { skill in
                    Text(skill)
                        .font(.body)
                        .padding(.vertical, 2)
                }
            }
            .padding()
        }
        .navigationTitle(project.name)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                
                // Request to Join Button
                Button(action: {
                    Task {
                        try await ProjectManager.shared.requestToJoinProject(projectId: project.id)
                    }
                }) {
                    Text("Request to Join Project")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                
                // Project Name
                Text(project.name)
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundColor(.primary)
                
                // Creator and Difficulty Level
                Text("Created by: \(project.createdBy)")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.secondary)
                
                Text("Difficulty Level: \(project.difficultyLevel)")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.secondary)
                
                // Date Created
                Text("Date Created: \(project.dateCreated, formatter: dateFormatter)")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.secondary)
                
                // Description Section
                Text("Description")
                    .font(.system(size: 18, weight: .semibold, design: .monospaced))
                    .padding(.top, 10)
                
                Text(project.description)
                    .font(.system(size: 14, design: .monospaced))
                    .padding(.top, 2)
                
                // Skills Section
                Text("Skills")
                    .font(.system(size: 18, weight: .semibold, design: .monospaced))
                    .padding(.top, 10)
                
                // Skill Tags
                HStack {
                    ForEach(project.skills, id: \.self) { skill in
                        Text(skill)
                            .font(.system(size: 12, design: .monospaced))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.15))
                            .foregroundColor(.blue)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding(.top, 5)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
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

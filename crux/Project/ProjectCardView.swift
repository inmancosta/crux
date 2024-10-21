import SwiftUI

struct ProjectCardView: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(project.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Created by: \(project.createdBy)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Difficulty: \(project.difficultyLevel)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(project.description)
                .font(.body)
                .lineLimit(3)
                .padding(.top, 5)
            
            HStack {
                ForEach(project.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(5)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(5)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

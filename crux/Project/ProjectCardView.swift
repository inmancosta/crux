import SwiftUI

struct ProjectCardView: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Project Name
            Text(project.name)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(.primary)
                .lineLimit(1)
            
            // Creator and Difficulty Level
            Text("Created by: \(project.createdBy)")
                .font(.system(size: 14, weight: .regular, design: .monospaced))
                .foregroundColor(.secondary)
            
            Text("Difficulty: \(project.difficultyLevel)")
                .font(.system(size: 14, weight: .regular, design: .monospaced))
                .foregroundColor(.secondary)
            
            // Project Description
            Text("Description: \(project.description)")
                .font(.system(size: 14, weight: .regular, design: .monospaced))
                .lineLimit(2)
                .padding(.top, 2)
            
            // Tags
            HStack {
                ForEach(project.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 12, weight: .regular, design: .monospaced))
                        .padding(5)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(5)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
        .frame(width: 180, height: 220, alignment: .topLeading)  // Consistent width and height for card layout
    }
}

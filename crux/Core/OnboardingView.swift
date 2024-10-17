import SwiftUI

struct OnboardingView: View {
    @State private var name = ""
    @State private var githubUsername = ""
    @State private var schoolGradYear = ""
    @State private var preferences: [String] = []
    
    @Binding var showOnboarding: Bool
    let userId: String
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            
            TextField("GitHub Username", text: $githubUsername)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            
            TextField("School/Grad Year", text: $schoolGradYear)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            
            // Example preferences list (replace with your actual options)
            List {
                Toggle("Mobile Development", isOn: Binding(
                    get: { preferences.contains("Mobile Development") },
                    set: { newValue in
                        if newValue {
                            preferences.append("Mobile Development")
                        } else {
                            preferences.removeAll { $0 == "Mobile Development" }
                        }
                    }
                ))
                
                Toggle("Web Development", isOn: Binding(
                    get: { preferences.contains("Web Development") },
                    set: { newValue in
                        if newValue {
                            preferences.append("Web Development")
                        } else {
                            preferences.removeAll { $0 == "Web Development" }
                        }
                    }
                ))
            }
            .frame(height: 150)
            
            Button("Complete Onboarding") {
                Task {
                    try await UserManager.shared.updateUserDetails(
                        userId: userId,
                        name: name,
                        githubUsername: githubUsername,
                        schoolGradYear: schoolGradYear,
                        preferences: preferences
                    )
                    showOnboarding = false
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

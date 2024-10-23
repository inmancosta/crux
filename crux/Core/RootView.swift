import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false

    var body: some View {
        ZStack {
            if !showSignInView {
                // Show the MainTabView when the user is authenticated
                MainTabView()
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil // Show sign-in if user is not authenticated
        }
        .fullScreenCover(isPresented: $showSignInView) {
            // Show the AuthenticationView when sign-in is needed
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

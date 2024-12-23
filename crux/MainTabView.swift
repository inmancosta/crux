import SwiftUI

struct MainTabView: View {
    @Binding var showSignInView: Bool // Bind showSignInView

    var body: some View {
        TabView {
            // Profile View Tab
            NavigationView {
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }

            // Project List View Tab
            NavigationView {
                ProjectListView()
            }
            .tabItem {
                Label("Projects", systemImage: "list.bullet")
            }
        }
    }
}

//struct MainTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainTabView()
//    }
//}

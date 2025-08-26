import SwiftUI

struct AppContentView: View {
    @ObservedObject private var dbObj = DBManager.shared;
    
    // index of displayed tab element
    @State private var selected = 1
    var body: some View {
        TabView(selection: $selected){
            ProfileView()
                .tabItem{
                    Image(systemName: "person.fill")
                    Text("Account")
                }
                .tag(0)
            ContentView(dataM: dbObj.dataManager, title: "All Icebreakers")
                .tabItem{
                    Image(systemName: "house.fill")
                    Text("Main page")
                }
                .tag(1)
            ContentView(dataM: dbObj.dataManager, title: "Favourites", isOnlyF: true)
                .tabItem{
                    Image(systemName: "star.fill")
                    Text("Favourites")
                }
                .tag(2)
        }
    }
}

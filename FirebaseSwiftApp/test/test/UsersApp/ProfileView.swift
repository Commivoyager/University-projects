import SwiftUI

final class ProfileViewModel : ObservableObject{
    var dbManager = DBManager.shared
    
    func getUserAnswer(answ: String?){
        if let answer = answ {
            print(answer) //! output to user
        }
    }
    func signOut(){ //! think about error logic
        AuthenticationManager.shared.signOut(resFunc: getUserAnswer)
    }
    func deleteUser(){
        DBManager.shared.deleteUser()
        AuthenticationManager.shared.deleteUser(resFunc: getUserAnswer)
    }
    
    init(){
        print("ProfileViewModel init") //! for debug
    }
}


struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @ObservedObject private var dataMngr = DBManager.shared.dataManager
    
    @State private var showAlert = false
    init(){
        print("ProfileView init") //! for debug
    }
    
    var body: some View {
        
        VStack{
            Text("Profile info")
                .font(.largeTitle)
                .bold()
                .padding()
            Spacer()
            
            UserDataView(userInfo: dataMngr.userInfoBinding, isRegistration: false)
                .padding(.bottom, 20)
            
            // for upload data to Firebase
            /*
             Button(action: {
             ItemsInitializator.shared.uploadData()
             }) {
             Text("Upload Data")
             .font(.title)
             .padding()
             .background(Color.blue)
             .foregroundColor(.white)
             .cornerRadius(10)
             }
             */
            
            Button(action: {
                viewModel.dbManager.updateUser()
            }){
                Text("Save data")
                    .iceControlStyle()
            }
            
            Button(action: {
                viewModel.signOut()
            }){
                Text("Sign out")
            }
            Button(action: {showAlert = true}){
                Text("Delete account")
            }
            .alert(isPresented: $showAlert){
                Alert(
                    title: Text("Account deleting?"),
                    message: Text("All data will be destroyed"),
                    primaryButton: .cancel(
                        Text("Cancel"),
                        action: {showAlert = false}
                    ),
                    secondaryButton: .destructive(
                        Text("Delete"),
                        action: {viewModel.deleteUser()}
                    )
                )
            }
        }.padding(5)
    }
}

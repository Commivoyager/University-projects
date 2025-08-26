import SwiftUI

struct RootView: View {
    @ObservedObject var authObj = AuthenticationManager.shared
    
    init(){
        print("RootView init") //! for debug
    }
    
    var body: some View {
        VStack{
            if authObj.isAuthManagerCreated{
                if authObj.isAuthorized{
                    AppContentView()
                }
                else{
                    AuthView()
                }
            }else{
                Image("icebrake")
                    .resizable() // Если нужно изменить размер
                    .scaledToFit() // Масштабирование
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 50)
            }
        }
    }
}

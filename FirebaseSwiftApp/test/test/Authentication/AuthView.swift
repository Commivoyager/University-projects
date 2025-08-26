import SwiftUI

// ObservableObject - all views, that subscribed on this class will update when some of @Published fields are changed
final class AuthViewModel: ObservableObject{
    var email = ""
    var password = ""
    var repeatedPassword = ""
    
    @Published var userInfo = UserModel()
    
    // provides userInfo used as a Binding
    var userInfoBinding: Binding<UserModel>{
        Binding(
            get: {self.userInfo},
            set: {self.userInfo = $0}
        )
    }
    
    @Published var errorMes: String = ""
    @Published var registrationMode = false
    
    func getAuthAnswer(Info: AuthInfo?, Mes: String?){
        if(Info == nil){
            if(Mes == nil){
                errorMes = "Unknown problems, try again later"
            }else{
                errorMes = Mes!
            }
        }else{
            if(Mes != nil){
                errorMes = Mes!
            }else{
                errorMes = ""
                //! logic for AuthInfo
            }
        }
    }
    func signIn(){
        guard !email.isEmpty && !password.isEmpty else{
            errorMes = "Email or password can not be empty"
            return
        }
        AuthenticationManager.shared.signIn(email: email, password: password, resFunc: getAuthAnswer)
    }
    func signUp(){
        guard !email.isEmpty && !password.isEmpty && !repeatedPassword.isEmpty else{
            errorMes = "Email or password can not be empty"
            return
        }
        guard password == repeatedPassword else{
            errorMes = "Passwords don't match"
            return
        }
        DBManager.shared.dataManager.userInfo = userInfo
        AuthenticationManager.shared.signUp(email: email, password: password, resFunc: getAuthAnswer)
    }
    
    init(){
        print("AuthViewModel init") //! for debug
    }
}


struct AuthView: View {
    
    @StateObject var viewModel = AuthViewModel() //.
    //this view thanks to @StateObject subscribes to AuthViewModel class
    //where there are @Published fields so when their value is changed - View
    //representation is updates
    // Also AuthViewModel is not recreated when this view is reprinted
    
    var body: some View {
        VStack{
            if(viewModel.registrationMode){
                RegistrationView(viewModel: viewModel)
            }else{
                AuthorizationView(viewModel: viewModel)
            }
        }
        .iceScreenStyle()
        
    }
    
    init(){
        print("AuthView init") //! for debug
    }
    
}


struct AuthorizationView : View{
    
    @ObservedObject var viewModel: AuthViewModel
    
    var body : some View{
        Text("Authorization")
            .font(.largeTitle)
            .bold()
            .padding(.top, 15)
        Spacer()
        VStack{
            Image("icebrake")
                .resizable() // Если нужно изменить размер
                .scaledToFit() // Масштабирование
                .frame(width: 150, height: 150)
                .padding(.bottom, 50)
            
            Text(viewModel.errorMes)
                .foregroundColor(.red)
                .frame(minHeight: 50)
                .multilineTextAlignment(.center)
            
            VStack{
                TextField("Enter email", text: $viewModel.email)
                    .iceControlStyle()
                    .disableAutocorrection(true)
                
                IcePasswordField("Enter password", password: $viewModel.password)
            }
            .padding(.bottom, 20)
            
            Button(action:
                    {
                        viewModel.errorMes = ""
                        viewModel.signIn()
                    })
            {
                Text("Sign in")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .contentShape(Rectangle())
            .iceControlStyle()
            
            Button(action: {withAnimation{
                viewModel.errorMes = ""
                viewModel.repeatedPassword = ""
                viewModel.registrationMode = true
            }}){
                Text("Create account")
            }
        }//main VStack
        Spacer()
    }
}


struct RegistrationView : View{
    
    @ObservedObject var viewModel: AuthViewModel
    var body : some View{
        VStack{
            
            Text("Registration")
                .font(.largeTitle)
                .bold()
                .padding(.top, 15)
            
            UserDataView(userInfo: viewModel.userInfoBinding, isRegistration: true)
                .padding(.bottom, 20)
            
            VStack{
                TextField("Enter email", text: $viewModel.email)
                    .iceControlStyle()
                    .disableAutocorrection(true)
                
                IcePasswordField("Enter password", password: $viewModel.password)
                IcePasswordField("Repeat password", password: $viewModel.repeatedPassword)
            }
            .padding(.bottom, 20)
            
            Button(action:
                    {
                        viewModel.errorMes = ""
                        viewModel.signUp()
                    })
            {
                Text("Sign up")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .contentShape(Rectangle())
            .iceControlStyle()
            
            if !viewModel.errorMes.isEmpty{
                Text(viewModel.errorMes)
                    .foregroundColor(.red)
                    //.frame(minHeight: 50)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {withAnimation{
                viewModel.errorMes = ""
                viewModel.registrationMode = false
                
            }}){
                Text("Authorize")
            }
        }
    }
}

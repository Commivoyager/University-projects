import Foundation
import FirebaseAuth

struct AuthInfo{
    public var email: String?
    public var userID: String
    public init(user: User){
        self.email = user.email
        self.userID = user.uid
        
        print("AuthInfo init") //! for debug
    }
}

final class AuthenticationManager : ObservableObject{
    static let shared = AuthenticationManager()
    
    @Published var isAuthManagerCreated = false
    var isRegistration = false
    @Published var isAuthorized = false
    private var user: User? = nil;
    private var handle: AuthStateDidChangeListenerHandle?
    private init(){
        isAuthorized = isAuthenticated()
        user = Auth.auth().currentUser
        handle = Auth.auth().addStateDidChangeListener{[weak self] auth, user in
            self?.user = user
            self?.isAuthorized = user != nil
        }
        isAuthManagerCreated = true
        
        print("AuthenticationManager init") //! for debug
    }
    deinit{
        if let hndl = handle{
            Auth.auth().removeStateDidChangeListener(hndl)
        }
        print("AuthenticationManager deinit") //! for debug
    }
    
    private func checkAnswVal(authResult: AuthDataResult?, error: Error?, resFunc: @escaping (AuthInfo?, String?) -> Void ){
        guard error == nil else{
            if let err = error{
                let errCode = (err as NSError).code
                if errCode == AuthErrorCode.wrongPassword.rawValue || errCode == AuthErrorCode.internalError.rawValue {
                    resFunc(nil, "Wrong password or unregistered email")
                }
                else{
                    resFunc(nil, err.localizedDescription)
                }
            }
            else{
                resFunc(nil, error?.localizedDescription)
            }
            return
        }
        guard authResult != nil else{
            resFunc(nil, "Unable to log in due to incorrect server behavior, try again later")
            return
        }
        resFunc(AuthInfo(user: authResult!.user), nil)
    }
    
    func signUp (email: String, password: String, resFunc: @escaping (AuthInfo?, String?) -> Void){
        isRegistration = true;
        Auth.auth().createUser(withEmail: email, password: password) /*next curly braces - trailing clouser (it is parameter of createUser method). This clouser will be called after createUser will execute*/{[weak self] authResult, error in
            guard let self = self else { return }
            self.checkAnswVal(authResult: authResult, error: error, resFunc: resFunc)
        }
    }
    
    func signIn(email: String, password: String, resFunc: @escaping (AuthInfo?, String?) -> Void){
        isRegistration = false;
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            self.checkAnswVal(authResult: authResult, error: error, resFunc: resFunc)
        }
    }
    
    func isAuthenticated() -> Bool{
        return Auth.auth().currentUser != nil
    }
    
    func signOut(resFunc: @escaping (String?) -> Void){
        do{
            try Auth.auth().signOut()
            resFunc(nil)
        }catch{
            resFunc("Sign out error: \(error.localizedDescription)")
        }
    }
    
    func deleteUser(resFunc: @escaping (String?) -> Void){
        guard let user = Auth.auth().currentUser else{
            resFunc("User is not authorized")
            return
        }
        user.delete{error in
            if let err = error{
                resFunc(err.localizedDescription)
            }else{
                resFunc(nil)
            }
        }
    }
    
    func getUserID() -> String?{
        return user?.uid
    }
}

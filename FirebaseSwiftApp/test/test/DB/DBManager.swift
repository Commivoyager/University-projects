import Foundation
import Combine
import SwiftUI
import FirebaseCore
import FirebaseFirestore

final class DBManager : ObservableObject{
    
    static let shared = DBManager()
    @Published var dataManager: DataManager
    private var authObj = AuthenticationManager.shared
    
    private static let itemsCollection = "Icebreakers"
    private static let usersCollection = "Users"
    
    private let db = Firestore.firestore()
    
    // for updating data from DB
    private var userListener: ListenerRegistration?
    private var itemsListener: ListenerRegistration?
    
    private var errMess: String = "";
    
    // this field for managing the subscription to isAuthorized field (authorization status).
    //When this factory is destroyed - this subscription will be cancelled automatically
    private var cancellables = Set<AnyCancellable>()
    
    private init(){
        self.dataManager = DataManager()
        setupObservers()
        print("DBManager init") //! for debug
    }
    
    deinit{
        stopListenDB() //!
        print("DBManager deinit") //! for debug
    }
    
    private func setupObservers(){
        authObj.$isAuthorized
            .sink{ [weak self] isAuthorized in
                guard let self = self else {return}
                if isAuthorized {
                    if self.authObj.isRegistration{
                        self.createUser()
                    } else{
                        if(self.userListener == nil || self.itemsListener == nil){
                            self.stopListenDB()
                            self.startListenDB()
                        }
                    }
                    
                }else{
                    self.stopListenDB()
                    self.dataManager.cleanData()
                }
            }
            .store(in: &cancellables)
    }
    
    func startListenDB(){
        getUserInfo()
        getItemsInfo()
    }
    
    func stopListenDB(){
        userListener?.remove()
        userListener = nil
        
        itemsListener?.remove()
        itemsListener = nil
    }
    
    private func getUserInfo(){
        guard let userID = authObj.getUserID() else {
            self.errMess = "Error message: You need to log in"
            print(self.errMess) //! for debug
            authObj.signOut{_ in}
            return
        }
        
        userListener?.remove()
        userListener = db.collection(DBManager.usersCollection)
            .document(userID)
            .addSnapshotListener{ [weak self] snapshot, error in
                guard let self = self else {return}
                if let err = error{
                    self.errMess = "Error message: Firestore error: \(err.localizedDescription)"
                    print(self.errMess) //! for debug
                    return
                }
                
                guard let document = snapshot, document.exists else {
                    self.errMess = "Error message: User doesn't exists - there is no such document"
                    print(self.errMess) //! for debug
                    return
                }
                
                let result = Result {try document.data(as: UserModel.self) }
                
                switch result{
                case .success(let user):
                    self.errMess = ""
                    print("Successful extraction of user data") //! for debug
                    self.dataManager.userInfo = user ?? UserModel()
                    
                    self.dataManager.getUsersFavourites()
                case .failure(let err):
                    self.errMess = "Error message: error during user data extraction - \(err.localizedDescription)"
                    print(self.errMess) //! for debug
                }
            }
    }
    
    private func getItemsInfo(){
        itemsListener?.remove()
        itemsListener = db.collection(DBManager.itemsCollection)
            .addSnapshotListener{ [weak self] snapshot, error in
                guard let self = self else {return}
                if let err = error{
                    self.errMess = "Error message: Firestore error: \(err.localizedDescription)"
                    print(self.errMess) //! for debug
                    return
                }
                
                guard let snapshot = snapshot else{
                    self.errMess = "Error message: No documents in \(DBManager.itemsCollection) collection"
                    print(self.errMess) //! for debug
                    return
                }
                
                for changes in snapshot.documentChanges{
                    switch changes.type {
                    case .added:
                        guard let addItem = try? changes.document.data(as: IcebreakerModel.self) else{
                            let err = error?.localizedDescription ?? "no description"
                            self.errMess = "Error message: icebreaker adding error: \(err)"
                            print(self.errMess) //! for debug
                            continue
                        }
                        let insertIndex = Int(changes.newIndex)
                        DispatchQueue.main.async {
                            self.dataManager.icebreakers.insert(addItem, at: insertIndex)
                            self.dataManager.loadFlag(item: self.dataManager.icebreakers[insertIndex])
                        }
                        
                    case .modified:
                        guard let modifItem = try? changes.document.data(as: IcebreakerModel.self) else{
                            let err = error?.localizedDescription ?? "no description"
                            self.errMess = "Error message: icebreaker modifying error: \(err)"
                            print(self.errMess) //! for debug
                            continue
                        }
                        let modificationIndex = Int(changes.oldIndex)
                        
                        DispatchQueue.main.async {
                            let areChanged = self.dataManager.arePicturesChanged(itemInd: modificationIndex, item: modifItem)
                            self.dataManager.assignItem(ind: modificationIndex, newItem: modifItem)
                            if areChanged {
                                self.dataManager.loadPictures(item: self.dataManager.icebreakers[modificationIndex])
                            }
                            self.dataManager.loadFlag(item: self.dataManager.icebreakers[modificationIndex])
                        }
                    case .removed:
                        let removeIndex = Int(changes.oldIndex)
                        DispatchQueue.main.async {
                            self.dataManager.icebreakers.remove(at: removeIndex)
                        }
                    }
                    self.errMess = ""
                }
                
                DispatchQueue.main.async {
                    self.dataManager.getUsersFavourites()
                }
            }
    }
    
    public func createUser(){
        guard let userID = authObj.getUserID() else {
            self.errMess = "Error message: You need to log in"
            print(self.errMess) //! for debug
            authObj.signOut{_ in}
            return
        }
        
        let userRef = db.collection(DBManager.usersCollection).document(userID)
        let user = dataManager.userInfo
        do{
            try userRef.setData(from: user){[weak self] error in
                guard let self = self else {return}
                if let error = error {
                    self.errMess = "Error message: Error with creating user in DB: \(error.localizedDescription)"
                    print(self.errMess) //! for debug
                }else{
                    self.authObj.isRegistration = false;
                    print("Succcessful account creation") //! for debug
                    self.stopListenDB()
                    self.startListenDB()
                }
            }
        }catch{
            self.errMess = "Error message: Error with creating user in DB: \(error.localizedDescription)"
            print(errMess) //! for debug
        }
    }
    
    public func deleteUser(){
        guard let userID = authObj.getUserID() else {
            self.errMess = "Error message: Couldn't delete user information from DB"
            print(self.errMess) //! for debug
            return
        }
        let userRef = db.collection(DBManager.usersCollection).document(userID)
        userRef.delete{ error in
            if let err = error{
                self.errMess = "Error message: Couldn't delete user information from DB (\(err.localizedDescription))"
                print(self.errMess) //! for debug
            }
        }
    }
    
    public func updateFavourites(value: String, isAdd: Bool){
        guard let userID = authObj.getUserID() else {
            self.errMess = "Error message: You need to log in"
            print(self.errMess) //! for debug
            authObj.signOut{_ in}
            return
        }
        let userRef = db.collection(DBManager.usersCollection).document(userID)
        
        if isAdd{
            userRef.updateData([
                "favourites" : FieldValue.arrayUnion([value])
            ])
        }else{
            userRef.updateData([
                "favourites" : FieldValue.arrayRemove([value])
            ])
        }
    }
    
    //    public func updateUserField<T: Encodable>(fieldName: String, fieldValue: T){
    //        guard let userID = authObj.getUserID() else {
    //            self.errMess = "Error message: You need to log in"
    //            print(self.errMess)
    //            authObj.signOut{_ in}
    //            return
    //        }
    //        let userRef = db.collection(DBManager.usersCollection).document(userID)
    //        userRef.updateData([fieldName:fieldValue]){error in
    //            if let err = error{
    //                self.errMess = "Error message: Error with user data field (\(fieldName)) updating: \(err.localizedDescription)"
    //                print(self.errMess)
    //            }
    //        }
    //    }
    
    public func updateUser(){
        guard let userID = authObj.getUserID() else {
            self.errMess = "Error message: You need to log in"
            print(self.errMess) //! for debug
            authObj.signOut{_ in}
            return
        }
        let userRef = db.collection(DBManager.usersCollection).document(userID)
        do{
            try userRef.setData(from: dataManager.userInfo, merge: true)
        } catch{
            errMess = "Error message: Error with user data updating: \(error.localizedDescription)"
            print(errMess) //! for debug
        }
    }
    
    public func putItem(item: IcebreakerModel){
        do{
            try db.collection(DBManager.itemsCollection).addDocument(from: item)
        } catch {
            errMess = "Error message: Error with items data loading to Firestore: \(error.localizedDescription)"
            print(errMess) //! for debug
        }
    }
}

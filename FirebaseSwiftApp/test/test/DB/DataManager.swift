import SwiftUI

class DataManager: ObservableObject{
    @Published var userInfo: UserModel = UserModel()
    // provides userInfo used as a Binding
    var userInfoBinding: Binding<UserModel>{
        Binding(
            get: {self.userInfo},
            set: {self.userInfo = $0}
        )
    }
    @Published var icebreakers: [IcebreakerModel] = []
    @Published private var flags: [String : UIImage] = [:]
    
    init(){
        print("DataManager init") //! for debug
    }
    
    func getUsersFavourites(){
        for item in icebreakers{
            let itemID = item.id ?? ""
            if(userInfo.favourites.contains(itemID)){
                item.isFavourite = true
            }else{
                item.isFavourite = false
            }
        }
    }
    
    func toggleFavourite(item: IcebreakerModel){
        guard let id = item.id else {
            print("Error: Can't change favourite - item id is null") //! for debug
            return
        }
        
        if userInfo.favourites.contains(id){
            userInfo.favourites.removeAll{ $0 == id }
            item.isFavourite = false
            DBManager.shared.updateFavourites(value: id, isAdd: false)
            
        }else{
            userInfo.favourites.append(id)
            item.isFavourite = true
            DBManager.shared.updateFavourites(value: id, isAdd: true)
        }
    }
    
    func getFlag(item: IcebreakerModel) -> UIImage? {
        guard let flagURL = item.countryFlag else { return nil }
        return flags[flagURL]
    }
    
    func loadPictures(item: IcebreakerModel){
        item.loadedPictures.removeAll()
        for picURL in item.pictures{
            loadImage(urlString: picURL, item: item, resFunc: addPicture)
        }
    }
    
    func addPicture(imgURL: String?, item: IcebreakerModel?, img: UIImage){
        item!.loadedPictures.append(img)
    }
    
    func loadAllFlags(){
        for item in icebreakers {
            loadFlag(item: item)
        }
    }
    
    func loadFlag(item: IcebreakerModel?){
        guard let item = item else {return}
        guard let flagURL = item.countryFlag else {return}
        if flags[flagURL] != nil { return }
        loadImage(urlString: flagURL, item: nil, resFunc: addFlag)
    }
    
    private func addFlag(imgURL: String, item: IcebreakerModel?, img: UIImage){
        flags[imgURL] = img
    }
    
    private func loadImage(
        urlString: String,
        item: IcebreakerModel?,
        resFunc: @escaping (String, IcebreakerModel?, UIImage) -> Void
    ){
        guard let url = URL(string: urlString) else {
            print("Error: URL is incorrect") //! for debug
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard self != nil else {
                print("Error: Data manager object is destroyed") //! for debug
                return
            }
            if let data = data, let uiImage = UIImage(data: data) {
                // asynchronous execution in the main thread
                DispatchQueue.main.async {
                    resFunc(urlString, item, uiImage)
                }
            } else {
                print("Error: Image has't been loaded") //! for debug
                return
            }
        }.resume() // to start task
    }
    
    func arePicturesChanged(itemInd: Int, item: IcebreakerModel) -> Bool {
        if(icebreakers[itemInd].pictures.count != item.pictures.count){
            return true
        }else{
            for i in 0..<icebreakers[itemInd].pictures.count{
                if icebreakers[itemInd].pictures[i] != item.pictures[i]{
                    return true
                }
            }
        }
        return false
    }
    
    func assignItem(ind: Int, newItem: IcebreakerModel){
        icebreakers[ind].objectWillChange.send()
        icebreakers[ind].id = newItem.id
        icebreakers[ind].name = newItem.name
        icebreakers[ind].description = newItem.description
        icebreakers[ind].releaseDate = newItem.releaseDate
        icebreakers[ind].terminationDate = newItem.terminationDate
        icebreakers[ind].countryName = newItem.countryName
        icebreakers[ind].pictures = newItem.pictures
        icebreakers[ind].countryFlag = newItem.countryFlag
        icebreakers[ind] = icebreakers[ind]
    }
    
    func cleanData(){
        userInfo = UserModel()
        icebreakers = []
        flags = [:]
    }
}

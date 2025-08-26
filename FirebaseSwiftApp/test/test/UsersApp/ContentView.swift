import SwiftUI

struct ContentView: View {
    @ObservedObject var dataMngr: DataManager
    var contentTitle: String
    var isOnlyFavourite: Bool = false
    
    var filteredContent: [IcebreakerModel]{
        print("Array filtered") //! for debug
        return isOnlyFavourite ? dataMngr.icebreakers.filter { $0.isFavourite } : dataMngr.icebreakers
    }
    
    init(dataM: DataManager, title: String, isOnlyF: Bool = false){
        contentTitle = title
        isOnlyFavourite = isOnlyF
        dataMngr = dataM
        print("ContentView init") //! for debug
    }
    
    var body: some View {
        NavigationView {
            List(filteredContent) { item in
                NavigationLink(destination: ContentDetailsView(item: item, dataMngr: dataMngr)) {
                    HStack {
                        if let flagImg = dataMngr.getFlag(item: item){
                            Image(uiImage: flagImg)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                        }
                        Text(item.name)
                            .font(.title)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Spacer()
                        
                        FavouriteButton(item: item){
                            dataMngr.toggleFavourite(item: item)
                        }
                    }
                    .iceControlStyle(hght: .infinity)
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle(contentTitle)
        }
    }
}


struct FavouriteButton: View{
    var item: IcebreakerModel
    var action: () -> Void
    var body: some View{
        Button(action: action) {
            Image(systemName: item.isFavourite ? "star.fill" : "star")
                .foregroundColor(item.isFavourite ? .yellow : .gray)
        }
        .buttonStyle(BorderlessButtonStyle()) // To avoid interfering with the NavigationLink
    }
}

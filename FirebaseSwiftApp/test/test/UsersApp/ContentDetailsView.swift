import SwiftUI

struct ContentDetailsView: View {
    @ObservedObject var item: IcebreakerModel
    var dataMngr: DataManager
    
    private let imgHeight: CGFloat = 250
    var body: some View {
        VStack{
            if !item.loadedPictures.isEmpty {
                TabView() {
                    ForEach(0..<item.loadedPictures.count, id: \.self) { index in
                        Image(uiImage: item.loadedPictures[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width - 40, height: imgHeight)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: imgHeight)
            }
            ScrollView{
                Text("""
                Name:
                \(item.name)
                            
                Country:
                \(item.countryName)
                            
                \(textDate(date: item.releaseDate, text: "Creation date: \n"))
                            
                \(textDate(date: item.terminationDate, text: "Decommissioning date: \n"))
                            
                Description:
                \(item.description)
                """)
                    .multilineTextAlignment(.leading)
            }
            .iceControlStyle(hght: .infinity)
            .padding(20)
        }
        .onAppear{
            if item.loadedPictures.count != item.pictures.count {
                dataMngr.loadPictures(item: item)
            }
        }
        .navigationTitle(item.name)
    }
    
    func textDate(date: Date?, text: String) -> String{
        guard let date = date else{return text+"-"}
        return text + date.getFormattedDate()
    }
}

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

// Identifiable - requires a unique identifier for the object
// Codable - provides protocols for encoding and decoding for DB
class IcebreakerModel: Identifiable, Codable, ObservableObject{
    // When reading from the Firestore, this field will be assigned a document ID
    @DocumentID var id: String?
    var name: String
    var description: String
    var releaseDate: Date?
    var terminationDate: Date?
    var countryName: String
    var pictures: [String]
    var countryFlag: String?
    
    @Published var loadedPictures: [UIImage] = []
    @Published var isFavourite: Bool = false;
    
    enum CodingKeys: String, CodingKey{
        case id, name, description, releaseDate, terminationDate, countryName, pictures, countryFlag
    }
    
    init(
        name: String,
        description: String,
        releaseDate: Date?,
        terminationDate: Date?,
        countryName: String,
        pictures: [String],
        countryFlag: String?
    ) {
        self.name = name
        self.description = description
        self.releaseDate = releaseDate
        self.terminationDate = terminationDate
        self.countryName = countryName
        self.pictures = pictures
        self.countryFlag = countryFlag
    }
}

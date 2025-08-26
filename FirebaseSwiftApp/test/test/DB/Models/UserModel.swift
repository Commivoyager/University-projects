import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// Identifiable - requires a unique identifier for the object
// Codable - provides protocols for encoding and decoding for DBs
struct UserModel: Identifiable, Codable{
    // When reading from the Firestore, this field will be assigned a document ID
    @DocumentID var id: String?
    var name: String = ""
    var surname: String = ""
    var country: String = ""
    var town: String = ""
    var birthDate: Date = Date()
    var notes: String = " "
    
    var favourites: [String] = []
}

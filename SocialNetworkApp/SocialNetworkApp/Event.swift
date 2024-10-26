import Foundation
import FirebaseFirestore
//event
struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var date: Date
    var time: String
    var location: String
    var createdBy: String
}

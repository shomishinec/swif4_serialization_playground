import Foundation

/*:
 ## Simple Serialization
 */

struct User: Codable {
    enum Gender: Int, Codable {
        case male
        case female
    }
    
    let firstNme: String
    let lastName: String
    let city: String
    let birthDay: Date
    let gender: Gender
}

let user = User(firstNme: "Thomas", lastName: "Anderson", city: "Zion", birthDay: Date(), gender: .male)
let rawUser = try! JSONEncoder().encode(user)
let userString = String(data: rawUser, encoding: .utf8)


/*:
 ## Custom keys Serialization
 */

struct Dog: Codable {
    enum DogBreed: Int, Codable {
        case siberianHusky
        case alaskanMalamute
    }

    let name: String
    let breed: DogBreed

    enum CodingKeys: String, CodingKey {
        case name = "dog_name"
        case breed = "dog_breed"
    }
}

let dog = Dog(name: "Flash", breed: .siberianHusky)
let rawDog = try! JSONEncoder().encode(dog)
let gogString = String(data: rawDog, encoding: .utf8)


/*:
 ## Custom Serialization
 */

enum CatCodingKeys: String, CodingKey {
    case name = "cat_name"
    case catBreed = "cat_breed"
}

enum CatBreed: Int, Codable {
    case siberian
    case norwegianForest
}

struct Cat {
    let name: String
    let breed: CatBreed
}

extension Cat: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CatCodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        let rawBreed = try values.decode(Int.self, forKey: .catBreed)
        breed = CatBreed(rawValue: rawBreed)!
    }
}

extension Cat: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CatCodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(breed.rawValue, forKey: .catBreed)
    }
}

let cat = Cat(name: "Barry", breed:.siberian)
let rawCat = try! JSONEncoder().encode(cat)
let catString = String(data: rawCat, encoding: .utf8)


/*:
 ## What if we have nested structure in our server response ? Generic force with us!
 */

struct ServerError: Codable {
    let description: String
}

struct ServerResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let error: ServerError?
}

let serverResponse = ServerResponse(success: true, data: user, error: nil)
let rawData = try! JSONEncoder().encode(serverResponse)
let jsonString = String(data:rawData , encoding: .utf8)

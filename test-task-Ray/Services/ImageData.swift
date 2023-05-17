import UIKit

struct ImageData: Codable {
    let queryText: String
    let image: UIImage
    var isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case queryText, image, isLiked
    }
    
    init(queryText: String, image: UIImage, isLiked: Bool) {
        self.queryText = queryText
        self.image = image
        self.isLiked = isLiked
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        queryText = try container.decode(String.self, forKey: .queryText)
        let imageData = try container.decode(Data.self, forKey: .image)
        guard let image = UIImage(data: imageData) else {
            throw DecodingError.dataCorruptedError(forKey: .image, in: container, debugDescription: "Invalid image data")
        }
        self.image = image
        isLiked = try container.decode(Bool.self, forKey: .isLiked)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(queryText, forKey: .queryText)
        let imageData = image.pngData()
        try container.encode(imageData, forKey: .image)
        try container.encode(isLiked, forKey: .isLiked)
    }
}

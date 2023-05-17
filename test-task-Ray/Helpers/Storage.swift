import Foundation

class Storage {
    static let shared = Storage()
    static let savedImages = "storageSavedImages"
    private let storage = UserDefaults.standard
    private var savedImages: [ImageData] = []
    
    func getImages() -> [ImageData]? {
        if let encodedImageDataArray = storage.array(forKey: Storage.savedImages) as? [Data] {
            savedImages = encodedImageDataArray.compactMap { encodedImageData in
                do {
                    let imageData = try JSONDecoder().decode(ImageData.self, from: encodedImageData)
                    return imageData
                } catch {
                    print("Failed to decode image data:", error)
                    return nil
                }
            }
        } else {
            print("No saved images found")
        }
        return savedImages
    }
    
    func saveImages(images: [ImageData]?) {
        if var savedImages = images {
            if savedImages.count > 20 {
                let numberOfImagesToRemove = savedImages.count - 20
                for _ in 0..<numberOfImagesToRemove {
                    savedImages.removeFirst()
                }
            }
            
            let encodedDataArray: [Data] = savedImages.compactMap { imageData in
                return try? JSONEncoder().encode(imageData)
            }
            storage.set(encodedDataArray, forKey: Storage.savedImages)
        }
    }
}

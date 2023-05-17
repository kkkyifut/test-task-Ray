import UIKit

class FavouriteViewController: UIViewController {
    private let storage = UserDefaults.standard
    private var savedImages = [UIImage]()
    private var savedResponse: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getImages()
    }
    
    private func getImages() {
        if let imageDataArray = storage.array(forKey: Storage.savedImages) as? [Data] {
            savedImages = imageDataArray.compactMap { imageData in
                return UIImage(data: imageData)
            }
            print("savedImages in Favourite:", savedImages)
        } else {
            print("No saved images found")
        }
    }
}



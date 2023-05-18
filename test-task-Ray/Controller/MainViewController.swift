import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    private let storage = UserDefaults.standard
    var enteredText: String?
    var savedImage: ImageData?
    var isLiked = false
    var savedImages: [ImageData]?

    @IBOutlet var textField: UITextField!
    @IBOutlet var generatedImage: UIImageView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var likeButton: UIButton!
    
    @IBAction func generateImage(_ sender: UIButton) {
        enteredText = textField.text
        textField.resignFirstResponder()
        
        if let text = enteredText?.replacingOccurrences(of: " ", with: "+"),
           let imageURL = URL(string: "https://dummyimage.com/500x500&text=\(text)") {
            indicator.startAnimating()
            
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async { [self] in
                        indicator.stopAnimating()
                        if let image = UIImage(data: imageData) {
                            let imageData = ImageData(queryText: text, image: image, isLiked: false)
                            generatedImage.image = image
                            savedImage = imageData
                            checkLikeStatus()
                            likeImageButtonHidden()
                        }
                    }
                } else {
                    DispatchQueue.main.async { [self] in
                        indicator.stopAnimating()
                        generatedImage.image = nil
                        checkLikeStatus()
                        likeImageButtonHidden()
                    }
                }
            }
        } else {
            print("Invalid text or image URL")
        }
    }
    
    @IBAction func likeImageButton(_ sender: UIButton) {
        isLiked.toggle()
        updateLikeButtonAppearance()
        likeImageButtonHidden()
        
        if var imageData = savedImage, savedImages != nil {
            if isLiked {
                if !savedImages!.contains(where: { $0.queryText == imageData.queryText || $0.image == imageData.image }) {
                    imageData.isLiked = true
                    savedImages!.append(imageData)
                    print("Image saved")
                } else {
                    print("Image already exists")
                }
            } else {
                if let index = savedImages!.firstIndex(where: { $0.queryText == imageData.queryText || $0.image == imageData.image }) {
                    imageData.isLiked = false
                    savedImages!.remove(at: index)
                    print("Image removed")
                }
            }
        }
        
        Storage.shared.saveImages(images: savedImages)
    }
    
    private func checkLikeStatus() {
        guard savedImages != nil else { return }
        if savedImages!.contains(where: { $0.queryText == enteredText || $0.image == savedImage?.image }) {
            isLiked = true
        } else {
            isLiked = false
        }
        updateLikeButtonAppearance()
    }
    
    private func updateLikeButtonAppearance() {
        let imageName = isLiked ? "likeFill" : "likeEmpty"
        let image = UIImage(named: imageName)
        likeButton.setImage(image, for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicator.stopAnimating()
        savedImages = Storage.shared.getImages()
        checkLikeStatus()
        likeImageButtonHidden()
    }
    
    private func likeImageButtonHidden() {
        if generatedImage.image == nil {
            likeButton.alpha = 0
        } else {
            likeButton.alpha = 1
        }
    }
}

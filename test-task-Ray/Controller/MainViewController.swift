import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    private let storage = UserDefaults.standard
    private var enteredText: String?
    private var savedImage: UIImage?
    private var isLiked = false
    private var savedImages: [UIImage] = []
    private var savedResponse: [String] = []

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
                            generatedImage.image = image
                            savedImage = image
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
        
        if let image = savedImage, let text = enteredText {
            if isLiked {
                if !savedImages.contains(image) && !savedResponse.contains(text) {
                    savedImages.append(image)
                    savedResponse.append(text)
                    print("Save image")
                } else {
                    print("Image already exists")
                }
            } else {
                if let index = savedImages.firstIndex(of: image), let indexText = savedResponse.firstIndex(of: text) {
                    savedImages.remove(at: index)
                    savedResponse.remove(at: indexText)
                    print("Image removed")
                }
            }
        }
        let imageDataArray: [Data] = savedImages.map { image in
            return image.pngData() ?? Data()
        }
        
        storage.set(imageDataArray, forKey: Storage.savedImages)
        storage.set(savedResponse, forKey: Storage.savedResponses)
        
        print("savedImages in Main:", savedImages)
    }
    
    private func checkLikeStatus() {
        if savedImage != nil && savedImages.contains(generatedImage.image!) {
            print(11111)
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

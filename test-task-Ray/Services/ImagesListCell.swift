import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    private var isLiked: Bool?
    var indexPath: IndexPath?
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.didChangeLikeStatus(at: indexPath)
        }
    }
    
    public func setIsLiked(isLiked: Bool) {
        self.isLiked = isLiked
        let imageName = isLiked ? "likeFill" : "likeEmpty"
        let image = UIImage(named: imageName)
        likeButton.setImage(image, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indexPath = nil
    }
}

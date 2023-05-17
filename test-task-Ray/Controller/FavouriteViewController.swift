import UIKit

class FavouriteViewController: UIViewController {  
    private let storage = UserDefaults.standard
    private var savedImages: [ImageData]?
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedImages = Storage.shared.getImages()
        tableView.reloadData()
    }
}

extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedImages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imagesListCell, with: indexPath)
        return cell
    }
}

extension FavouriteViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        if let imageData = savedImages?[indexPath.row] {
            cell.cellImage.image = imageData.image
            cell.setIsLiked(isLiked: imageData.isLiked)
            cell.indexPath = indexPath
            cell.delegate = self
        }
    }
}

extension FavouriteViewController: ImagesListCellDelegate {
    func didChangeLikeStatus(at indexPath: IndexPath) {
        guard var imageData = savedImages?[indexPath.row] else {
            return
        }

        imageData.isLiked = !imageData.isLiked

        savedImages!.remove(at: indexPath.row)
        Storage.shared.saveImages(images: savedImages)
        
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [indexPath], with: .fade)
        }, completion: { [self] _ in
            tableView.reloadData()
        })
    }
}

protocol ImagesListCellDelegate: AnyObject {
    func didChangeLikeStatus(at indexPath: IndexPath)
}

extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

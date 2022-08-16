//
//  StoreCollectionViewController.swift
//  CollectionViewDemo
//
//  Created by 陳鈺翔 on 2022/8/16.
//

import UIKit

private let reuseIdentifier = "Cell"

class StoreCollectionViewController: UICollectionViewController {
    
    enum Section {
        case all
    }
    
    lazy var dataSource = configureDataSourece()
    var iconSet: [Icon] = [ Icon(name: "Candle icon", imageName: "candle", description: "Halloween icons designed by Tania Raskalova.", price: 3.99, isFeatured: false),
                                    Icon(name: "Cat icon", imageName: "cat", description: "Halloween icon designed by Tania Raskalova.", price: 2.99, isFeatured: true),
                                    Icon(name: "dribbble", imageName: "dribbble", description: "Halloween icon designed by Tania Raskalova.", price: 1.99, isFeatured: false),
                                    Icon(name: "Ghost icon", imageName: "ghost", description: "Halloween icon designed by Tania Raskalova.", price: 4.99, isFeatured: false),
                                    Icon(name: "Hat icon", imageName: "hat", description: "Halloween icon designed by Tania Raskalova.", price: 2.99, isFeatured: false),
                                    Icon(name: "Owl icon", imageName: "owl", description: "Halloween icon designed by Tania Raskalova.", price: 5.99, isFeatured: true),
                                    Icon(name: "Pot icon", imageName: "pot", description: "Halloween icon designed by Tania Raskalova.", price: 1.99, isFeatured: false),
                                    Icon(name: "Pumkin icon", imageName: "pumkin", description: "Halloween icon designed by Tania Raskalova.", price: 0.99, isFeatured: false),
                                    Icon(name: "RIP icon", imageName: "rip", description: "Halloween icon designed by Tania Raskalova.", price: 7.99, isFeatured: false),
                                    Icon(name: "Skull icon", imageName: "skull", description: "Halloween icon designed by Tania Raskalova.", price: 8.99, isFeatured: false),
                                    Icon(name: "Sky icon", imageName: "sky", description: "Halloween icon designed by Tania Raskalova.", price: 0.99, isFeatured: false),
                                    Icon(name: "Toxic icon", imageName: "toxic", description: "Halloween icon designed by Tania Raskalova.", price: 2.99, isFeatured: false),
                                    Icon(name: "Book icon", imageName: "ic_book", description: "Colorful icon designed by Marin Begović.", price: 2.99, isFeatured: false),
                                    Icon(name: "Backpack icon", imageName: "ic_backpack", description: "Colorful icon designed by Marin Begović.", price: 3.99, isFeatured: false),
                                    Icon(name: "Camera icon", imageName: "ic_camera", description: "Colorful camera icon designed by Marin Begović.", price: 4.99, isFeatured: false),
                                    Icon(name: "Coffee icon", imageName: "ic_coffee", description: "Colorful icon designed by Marin Begović.", price: 3.99, isFeatured: true),
                                    Icon(name: "Glasses icon", imageName: "ic_glasses", description: "Colorful icon designed by Marin Begović.", price: 3.99, isFeatured: false),
                                    Icon(name: "Icecream icon", imageName: "ic_ice_cream", description: "Colorful icon designed by Marin Begović.", price: 4.99, isFeatured: false),
                                    Icon(name: "Smoking pipe icon", imageName: "ic_smoking_pipe", description: "Colorful icon designed by Marin Begović.", price: 6.99, isFeatured: false),
                                    Icon(name: "Vespa icon", imageName: "ic_vespa", description: "Colorful icon designed by Marin Begović.", price: 9.99, isFeatured: false)]
    var shareEnabled = false
    var selectedIcons: [(icon: Icon, snapshot: UIImage)] = []
    
    @IBOutlet var shareBtn: UIBarButtonItem!
    
    @IBAction func shareBtnTapped(sender: AnyObject) {
        
        guard shareEnabled else {
            
            shareEnabled = true
            collectionView.allowsMultipleSelection = true
            shareBtn.title = "Done"
            shareBtn.style = UIBarButtonItem.Style.plain
            
            return
        }
        
        guard selectedIcons.count > 0 else {
            return
        }
        
        let snapshots = selectedIcons.map { $0.snapshot }
        
        let activityController = UIActivityViewController(activityItems: snapshots, applicationActivities: nil)
        activityController.completionWithItemsHandler = { activityType, completed, returnedItem, error in
            
            if let indexPaths = self.collectionView.indexPathsForSelectedItems {
                for indexPath in indexPaths {
                    self.collectionView.deselectItem(at: indexPath, animated: false)
                }
            }
            
            self.selectedIcons.removeAll(keepingCapacity: true)
            
            self.shareEnabled = false
            self.collectionView.allowsMultipleSelection = false
            self.shareBtn.title = "Share"
            self.shareBtn.style = UIBarButtonItem.Style.plain
        }
        
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func closeDetailView(segue: UIStoryboardSegue) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = dataSource
        
        updateSnapshot()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = collectionView.indexPathsForSelectedItems {
                let destinationVC = segue.destination as! StoreDetailViewController
                destinationVC.icon = iconSet[indexPath[0].row]
                collectionView.deselectItem(at: indexPath[0], animated: false)
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "showDetail" {
            if shareEnabled {
                return false
            }
        }
        
        return true
    }
    
    func configureDataSourece() -> UICollectionViewDiffableDataSource<Section, Icon> {
        
        let dataSource = UICollectionViewDiffableDataSource<Section, Icon>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, icon in
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StoreCollectionViewCell
                cell.imageView.image = UIImage(named: icon.imageName)
                cell.priceLabel.text = "$\(icon.price)"
                cell.backgroundView = icon.isFeatured ? UIImageView(image: UIImage(named: "feature-bg")) : nil
                
                let selectBackground = UIView()
                selectBackground.layer.borderColor = UIColor.systemRed.cgColor
                selectBackground.layer.borderWidth = 3.0
                cell.selectedBackgroundView = selectBackground
                
                return cell
            })
        return dataSource
    }
    
    func updateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Icon>()
        snapshot.appendSections([.all])
        snapshot.appendItems(iconSet, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension StoreCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard shareEnabled else {
            return
        }
        
        if let selectIcon = dataSource.itemIdentifier(for: indexPath) {
            if let snapshot = collectionView.cellForItem(at: indexPath)?.snapshot {
                selectedIcons.append((icon: selectIcon, snapshot: snapshot))
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard shareEnabled else {
            return
        }
        
        if let deSelectIcon = dataSource.itemIdentifier(for: indexPath) {
            if let index = selectedIcons.firstIndex(where: { $0.icon.name == deSelectIcon.name }) {
                selectedIcons.remove(at: index)
            }
        }
    }
}

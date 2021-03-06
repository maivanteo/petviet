//
//  StoryCategoryViewController.swift
//  petviet
//
//  Created by Macintosh HD on 9/23/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class StoryCategoryViewController: BaseViewController {
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 1, left: 0.4, bottom: 0, right: 0)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var collection: UICollectionView!
    var imageUrl:URL!
    var storyType:StoryType = .image
    var story:String!
    var pets:[Pet] = []
    var pet:Pet?
    var didPublishStory:() -> () = {}
    var didFilterPost:(Pet?) ->() =  {pet in }
    var isFilterPost:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initLoadingView()
        initData()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFilterPost {
            let allPet = Pet(type: 0, name: "Tất cả")
            pets.insert(allPet, at: 0)
            collection.reloadData()
            publishButton.setTitle("Lọc", for: .normal)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initData(){
        self.pets.append(contentsOf: Constant.pets)


    }
    func setupUI(){
        collection.register(UINib(nibName: "PetSpeciesViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func tappedBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedPublishButton(_ sender: Any) {
        if isFilterPost{
            didFilterPost(pet)
        }else{
            guard let user = FirebaseServices.shared().currentUser() else{return}
            guard let pet = self.pet else{return}
            let post = PostDetail(1, 1,pet.type, user.uid, user.displayName ?? "vuhai", story, "", "", created_date:Date().millisecondsSince1970)
            post.storyType = self.storyType.rawValue
            showLoadingView()
            if self.storyType == .image{
                
                FirebaseServices.shared().uploadImage(imageUrl) { (success, message, url) in
                    if success{
                        post.imagePath = url?.absoluteString
                        FirebaseServices.shared().publishPost(post) {[weak self] (success, message) in
                            guard let strongSelf = self else{return}
                            strongSelf.hideLoadingView()
                            if success{
                                strongSelf.didPublishStory()
                            }
                        }
                    }
                }
            }else if self.storyType == .youtube{
                post.youtubePath = imageUrl.absoluteString
                FirebaseServices.shared().publishPost(post) {[weak self] (success, message) in
                    guard let strongSelf = self else{return}
                    strongSelf.hideLoadingView()
                    if success{
                        strongSelf.didPublishStory()
                    }
                }
            }
        }
    }
    
}
extension StoryCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! PetSpeciesViewCell
        let pet = pets[indexPath.row]
        cell.updateContent(pet,pet.type == self.pet?.type ?? 0)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let pet = pets[indexPath.row]
        self.pet = pet
        self.collection.reloadData()
    }
}
extension StoryCategoryViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = UIScreen.main.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
}

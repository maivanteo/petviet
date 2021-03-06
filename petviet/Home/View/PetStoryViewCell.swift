//
//  HomeViewCell.swift
//  petviet
//
//  Created by Macintosh HD on 9/22/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit
import Kingfisher
class PetStoryViewCell: UITableViewCell {

    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var displaynameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var petTypeButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var likedByLabel: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    //
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var storyPhotoImageView: UIImageView!
    @IBOutlet weak var thumbnailHeightConstraint: NSLayoutConstraint!
    
    
    var didTappedLike:()->() = {}
    var didTappedComment:()->() = {}
    var didTapUserProfile:()->() = {}
    var didTapFollowButton:()->() = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupUI(){
        let avatarSize = self.avatarButton.frame.height
        self.avatarButton.addBorder(avatarSize / 2, 0.5, UIColor.lightGray)
        self.likeButton.imageView?.contentMode  = .scaleAspectFit
        self.commentButton.imageView?.contentMode =  .scaleAspectFit
        
        //
        self.petTypeButton.imageView?.contentMode = .scaleAspectFit

    }
    
    func updateContent(_ post:PostDetail){
        displaynameLabel.text = post.userName
        captionLabel.text = post.story
        let fromDate = Date(milliseconds: post.created_date)
        addressLabel.text = fromDate.caculateTimeToNow()
         
        displaynameLabel.text = post.userName
        if let userId = FirebaseServices.shared().userId(){
            likeButton.isSelected = post.isLiked(userId)
        }
        commentButton.setTitle("\(post.comments.count)", for: .normal)
        if post.likes.count == 0{
            likedByLabel.text = "Không ai thích sen cả."

        }else{
            likedByLabel.text = "\(post.likes.count) người đã thích bài viết này."
        }
       
        //
        if let _ = Constant.getPetById(post.petId){
            petTypeButton.setImage(UIImage(named: "ic_animal_cat"), for: .normal)
        }
        //
        var thumbnailPath:String? = nil
        
        if post.storyType == StoryType.image.rawValue{
            thumbnailPath = post.imagePath
            thumbnailHeightConstraint.constant = UIScreen.main.bounds.width
        }else{
            thumbnailPath = post.youtubePath?.getYoutubeThumbnail()
            thumbnailHeightConstraint.constant = (UIScreen.main.bounds.width / 16) * 9 

        }
        if let imagePath = thumbnailPath , imagePath.count > 0{
            storyPhotoImageView.kf.setImage(with: URL(string: imagePath))
        }else{
            storyPhotoImageView.image = UIImage(named: "ic_default_photo")
        }
        self.updateConstraintsIfNeeded()
    }
    
    @IBAction func tappedProfileButton(_ sender: Any) {
        didTapUserProfile()
    }
    @IBAction func tappedFollowButton(_ sender: Any) {
        didTapFollowButton()
    }
    
    @IBAction func tappedLikeButton(_ sender: Any) {
        didTappedLike()
    }
    
    @IBAction func tappedCommentButton(_ sender: Any) {
        didTappedComment()
    }
}

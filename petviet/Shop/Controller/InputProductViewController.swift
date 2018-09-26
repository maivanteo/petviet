//
//  InputProductViewController.swift
//  petviet
//
//  Created by Macintosh HD on 9/24/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class InputProductViewController: UIViewController {

    @IBOutlet weak var productCodeTextfield: UITextField!
    @IBOutlet weak var productNameTextfield: UITextField!
    @IBOutlet weak var productPriceTextfield: UITextField!
    
    @IBOutlet weak var uploadButton: UIButton!
    var productType:ProductType!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func tappedIUploadButton(_ sender: Any) {
    }
    @IBAction func tappedSaveButton(_ sender: Any) {
        guard let code = productCodeTextfield.text else{return}
        guard let name = productNameTextfield.text else{return}
        guard let price = productPriceTextfield.text else{return}
        
        let product = PetProduct(productType: productType, productCode: code, productName: name, price: Float(price) ?? 0.0, imagePath: nil)
    }
    
}
//
//  ProductDetailPresenter.swift
//  Review
//
//  Created by Badarinath Venkatnarayansetty on 10/1/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import Foundation
import UIKit

class ProductDetailPresenter {
    typealias CompletionHandler = (Bool) -> Void
    
    var viewModel:ProductViewModel?
    
    init(viewModel: ProductViewModel) {
        self.viewModel = viewModel
    }
    
    func present(in viewController: UIViewController, completion presentationCompletion: CompletionHandler? = nil) {
        
        guard let productDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController else { return }
        
        productDetailsVC.productViewModel = self.viewModel
    
        viewController.navigationController?.navigationBar.backItem?.title = NSLocalizedString("Product Details", comment: "Product Details ")
        viewController.navigationController?.pushViewController(productDetailsVC, animated: true)
    }
}

//
//  ProductListViewController.swift
//  Review
//
//  Created by Badrinath on 9/15/18.
//  Copyright © 2018 Badrinath. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {

    fileprivate let cellIdentifier = "productCell"

    var productData:[Product] = []
    
    lazy var filterOrDisable: UIBarButtonItem = { [unowned self] in
        let barButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
        return barButton
    }()
    
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var persistenceHelper: PersistenceHelper = { [unowned self] in
        let persistenceHelper = PersistenceHelper()
        persistenceHelper.delegate = self
        return persistenceHelper
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        setupNavItems()
        
        API.getProductData { (result) in
            
            //Assign the result , if products are not available in NSUserDefaults
            guard let _ = self.persistenceHelper.defaults.object(forKey: "starred") as? NSData else {
                self.productData = result
                self.persistenceHelper.updateUserDefaults(for: self.productData)
                self.tableView.reloadData()
                return
            }
            
             //if products are available in NSUSerDefaults, assing it to the productData Array to populate
            self.productData = self.persistenceHelper.fetchProductsFromCache()
            self.tableView.reloadData()
        }
    }
}

extension ProductListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = ProductTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        cell.delegate = self
        
       let productViewModel = ProductViewModel(product: productData[indexPath.row])
       productViewModel.configure(cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Row is \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated:  true)
        let product = productData[indexPath.row]
        navigateToProductDetails(with: product)
    }
}

//MARK : NSUserDefaults updates and fav img updates.
extension ProductListViewController: PersistenceDelegate {
    
    //updates the product list
    func updateCache(productList: [Product]) {
        persistenceHelper.updateUserDefaults(for: productList)
    }
    
    //Return the list for products.
    func getProductList ()  -> [Product] {
        return persistenceHelper.fetchFromUserDefaults()
    }
}


extension ProductListViewController: ProductTableViewCellDelegate {
    
    func didTapFav(_ sender: ProductTableViewCell) {
        
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        let index = tappedIndexPath.row
        let favCell = self.tableView.cellForRow(at: tappedIndexPath) as? ProductTableViewCell
        let productList = persistenceHelper.fetchProductsFromCache()
        guard let productFav = productList[index].fav else { return }
        
        if productFav {
            favCell?.favImg.image = UIImage(named: "outline.png")
            productList[index].fav = false
        }else{
            favCell?.favImg.image = UIImage(named: "filled.png")
            productList[index].fav = true
        }
        
        persistenceHelper.updateCache(for: productList)
    }
}


//MARK : UI updates and navigations

extension ProductListViewController {
    
    func setupTableView() {
        
        self.view.addSubview(tableView)
        
        tableView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.safeAreaLayoutGuide.leadingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, trailing: self.view.safeAreaLayoutGuide.trailingAnchor)
    }
    
    func setupNavItems() {
        navigationItem.rightBarButtonItem = filterOrDisable
    }
    
    func navigateToProductDetails(with product: Product) {
        guard let productDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController else  { return }
        productDetailsVC.product = product
        self.navigationController?.navigationBar.backItem?.title = NSLocalizedString("Product Details", comment: "Product Details ")
        self.navigationController?.pushViewController(productDetailsVC, animated: true)
    }
    
    @objc func filterTapped() {
        
        let productList = persistenceHelper.fetchProductsFromCache()
        
        if filterOrDisable.title == "Filter" {
            filterOrDisable.title = "Disable"
            
            //filters the product only with favourited
            self.productData = productList.filter{ $0.fav == true }
        }else {
            filterOrDisable.title = "Filter"
            //assigns all the products when disabled to show all of them
            self.productData = productList
        }
        
        self.tableView.reloadData()
    }
}

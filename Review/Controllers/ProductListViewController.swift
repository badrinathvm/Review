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
    var tableView: UITableView = UITableView()
    var productData:[Product] = []
    
    var filterOrDisable:UIBarButtonItem?
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        setupNavItems()
        
        API.getProductData { (result) in
            
            //Assign the result , if products are not available in NSUserDefaults
            guard let _ = self.defaults.object(forKey: "starred") as? NSData else {
                self.productData = result
                let data = NSKeyedArchiver.archivedData(withRootObject: self.productData)
                self.defaults.set(data, forKey: "starred")
                self.tableView.reloadData()
                return
            }
            
             //if products are available in NSUSerDefaults, assing it to the productData Array to populate
            self.productData = self.getProductList()
            self.tableView.reloadData()
        }
    }
}

extension ProductListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = ProductViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        cell.product = productData[indexPath.row]
        
        //MARK : Handling fav image updates.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProductListViewController.favTapped(_:)))
        cell.favImg.isUserInteractionEnabled = true
        cell.favImg.tag = indexPath.row
        cell.favImg.addGestureRecognizer(tapGestureRecognizer)
        cell.tag = indexPath.row

        guard let favFlag = productData[indexPath.row].fav else  { return UITableViewCell() }
        if favFlag {
            cell.favImg.image = UIImage(named: "filled.png")
        }else{
            cell.favImg.image = UIImage(named: "outline.png")
        }
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

extension ProductListViewController {
    
    @objc func favTapped(_ sender:AnyObject ) {
        
        let tapLocation = sender.location(in: tableView)
        
        //using the tapLocation to retrieve the index path
        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
        
        let favCell = self.tableView.cellForRow(at: indexPath!) as? ProductViewCell
        
        let productList = getProductList()
        
        guard let productFav = productList[sender.view.tag].fav else { return }
        
        if productFav {
            favCell?.favImg.image = UIImage(named: "outline.png")
            productList[sender.view.tag].fav = false
            updateData(productList: productList)
        }else{
            favCell?.favImg.image = UIImage(named: "filled.png")
            productList[sender.view.tag].fav = true
            updateData(productList: productList)
        }
    }
    
    //MARK : Retunr the productList
    
    func getProductList ()  -> [Product] {
        
        guard let data = defaults.object(forKey: "starred") as? NSData else { return []}
        
        guard let productList = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [Product] else  { return [] }
        
        return productList
    }
    
    //MARK : this methos updates the product List
    
    func updateData(productList: [Product]) {
        let data = NSKeyedArchiver.archivedData(withRootObject: productList)
        self.defaults.set(data, forKey: "starred")
    }
}


//MARK : UI updates and navigations

extension ProductListViewController {
    
    func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(ProductViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.view.addSubview(tableView)
        
        tableView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.safeAreaLayoutGuide.leadingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, trailing: self.view.safeAreaLayoutGuide.trailingAnchor)
    }
    
    func setupNavItems() {
        filterOrDisable = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
        navigationItem.rightBarButtonItems = [filterOrDisable] as? [UIBarButtonItem]
    }
    
    func navigateToProductDetails(with product: Product) {
        guard let productDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController else  { return }
        productDetailsVC.product = product
        self.navigationController?.navigationBar.backItem?.title = NSLocalizedString("Product Details", comment: "Product Details ")
        self.navigationController?.pushViewController(productDetailsVC, animated: true)
    }
    
    @objc func filterTapped() {
        
        let productList = getProductList()
        
        if filterOrDisable?.title == "Filter" {
            filterOrDisable?.title = "Disable"
            
            //filters the product only with favourited
            productData = productList.filter{ $0.fav == true }
        }else {
            filterOrDisable?.title = "Filter"
            //assigns all the products when disabled to show all of them
            self.productData = productList
        }
        
        self.tableView.reloadData()
    }
}

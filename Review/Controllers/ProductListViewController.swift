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
    
    private var dataSource:TableViewDataSource<ProductTableViewCell,ProductViewModel>?
    
    lazy var dataAccess: API = { [unowned self] in
        let dataAccess = API()
        return dataAccess
    }()

    lazy var productModal: ProductModal = { [unowned self] in
        let modal = ProductModal()
        modal.delegate = self
        return modal
    }()
    
    lazy var filterOrDisable: UIBarButtonItem = { [unowned self] in
        let barButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
        return barButton
    }()

    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        return tableView
    }()
    
    private var productListViewModel: ProductListViewModel?

    fileprivate func setTableViewDataSource(productViewModels: [ProductViewModel]) -> TableViewDataSource<ProductTableViewCell, ProductViewModel> {
        return TableViewDataSource(cellIdentifier: cellIdentifier, items: productViewModels ) { (cell, vm) in
            cell.delegate = self
            vm.configure(cell)
        }
    }
    
    fileprivate func commonOperations(_ productViewModel: [ProductViewModel]) {
        self.dataSource = self.setTableViewDataSource(productViewModels: productViewModel)
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        setupTableView()

        setupNavItems()
        
        // Observe for the notification, and define the function that's called when the notification is received
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: .filterOrDisable, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableVie), name: .reloadTableView, object: nil)
       
        let productViewModels = PersistenceHelper.shared.fetchFromUserDefaults()
        if productViewModels.count != 0 {
            let productViewModel = productViewModels.map(ProductViewModel.init)
            commonOperations(productViewModel)
            self.productListViewModel = ProductListViewModel(viewModel: productViewModel)
        }else {
            self.productListViewModel  = ProductListViewModel(dataAccess: dataAccess) {
                guard let viewModels = self.productListViewModel?.productViewModel else { return }
//                self.dataSource = self.setTableViewDataSource(productViewModels: viewModels)
//                self.tableView.dataSource = self.dataSource
//                self.tableView.reloadData()
                self.commonOperations(viewModels)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ProductListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Row is \(indexPath.row)")
        navigateToProductDetails()
    }

    func navigateToProductDetails() {
        guard let indexPath = self.tableView.indexPathForSelectedRow,
            let viewModel = self.productListViewModel?.productAt(index: indexPath.row) else  { return }
        
        //Adopted light weight View Controllers to smoothen the navigation.
        ProductDetailPresenter(viewModel: viewModel).present(in: self)
    }
}

extension ProductListViewController: ProductTableViewCellDelegate {

    func didTapFavorite(_ sender: ProductTableViewCell) {

        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        let favCell = self.tableView.cellForRow(at: tappedIndexPath) as? ProductTableViewCell
        
//        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
//        let favCell = self.tableView.cellForRow(at: indexPath) as? ProductTableViewCell
        
        let productList = PersistenceHelper.shared.fetchProductsFromCache()
        let product = productList[tappedIndexPath.row]
        guard let productFav = product.fav else { return }

        if productFav {
            favCell?.favImg.image = UIImage(named: "outline.png")
            product.fav = false
        } else {
            favCell?.favImg.image = UIImage(named: "filled.png")
            product.fav = true
        }
        
        PersistenceHelper.shared.updateCache(for: productList)
    }
}

extension ProductListViewController: ProductModalDelegate {
    func reloadTableView() {
        self.tableView.reloadData()
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

    @objc func filterTapped() {
        
        let productList = PersistenceHelper.shared.fetchProductsFromCache()
        
        NotificationCenter.default.post(name: .filterOrDisable, object: nil, userInfo:["products": productList])
    }
}


//MARK : Notification related items

extension ProductListViewController {
    
    @objc func reloadTableVie() {
        self.tableView.reloadData()
    }
    
    @objc func onNotification(notification:Notification) {
        // `userInfo` contains the data you sent along with the notification
        
        guard let productList = notification.userInfo?["products"] as? [Product] else { return }
        
        if filterOrDisable.title == "Filter" {
            filterOrDisable.title = "Disable"
            
            
            let productViewModels = productList.filter { $0.fav == true }.compactMap { (product) in
                return ProductViewModel(product: product)
            }
            
            //updates the view model with favorites
            self.productListViewModel?.updateViewModel(for: productViewModels)
        
        } else {
            
            filterOrDisable.title = "Filter"
            
            let productViewModels = productList.compactMap { (product) in
               return ProductViewModel(product: product)
            }
            
            self.productListViewModel?.updateViewModel(for: productViewModels)
        }
        
//        self.dataSource = setTableViewDataSource(productViewModels: (productListViewModel?.productViewModel)!)
//        self.tableView.dataSource = self.dataSource
//        NotificationCenter.default.post(name: .reloadTableView, object: nil, userInfo:nil)
         guard let viewModels = self.productListViewModel?.productViewModel else { return }
         commonOperations(viewModels)
    }
}

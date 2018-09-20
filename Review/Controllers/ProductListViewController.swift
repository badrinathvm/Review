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

    lazy var productModal: ProductModal = { [unowned self] in
        let modal = ProductModal()
        modal.delegate = self
        return modal
    }()
    
    lazy var productDetailView: ProductDetailView = { [unowned self] in
        let productDetailView = ProductDetailView()
        productDetailView.delegate = self
        return productDetailView
        }()

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

    override func viewDidLoad() {

        super.viewDidLoad()

        setupTableView()

        setupNavItems()

        productModal.fetchProductData()
    }
}

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productModal.productData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = ProductTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        cell.delegate = self

        let productViewModel = ProductViewModel(product: productModal.productData[indexPath.row])
        productViewModel.configure(cell)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Row is \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        let product = productModal.productData[indexPath.row]
        productDetailView.delegate?.navigateToProductDetails(product: product)
    }
}

extension ProductListViewController: ProductTableViewCellDelegate {

    func didTapFavorite(_ sender: ProductTableViewCell) {

        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        let favCell = self.tableView.cellForRow(at: tappedIndexPath) as? ProductTableViewCell
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
        if filterOrDisable.title == "Filter" {
            filterOrDisable.title = "Disable"
            self.productModal.productData = productList.filter { $0.fav == true }
        } else {
            filterOrDisable.title = "Filter"
            self.productModal.productData = productList
        }
    }
}

extension ProductListViewController: ProductDetailViewDelegate {
    
    func navigateToProductDetails(product: Product) {
        guard let productDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController else { return }
        productDetailsVC.product = product
        self.navigationController?.navigationBar.backItem?.title = NSLocalizedString("Product Details", comment: "Product Details ")
        self.navigationController?.pushViewController(productDetailsVC, animated: true)
    }
}

import UIKit


class UsersViewController: UIViewController {
    
    
    
    @IBOutlet weak var usersCollectionView: UICollectionView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var users: [User] = []
    private var filteredUsers: [User] = []
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    enum LayoutType {
        case grid
        case list
    }
    
    private var gridBarButtonItem = UIBarButtonItem()
    private var listBarButtonItem = UIBarButtonItem()
    
    private var isGridView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchUsers()
        
        listBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"),
            style: .plain,
            target: self,
            action: #selector(switchToListLayout)
        )
        
        gridBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.grid.2x2"),
            style: .plain,
            target: self,
            action: #selector(switchToGridLayout)
        )
        
        self.setupNavigationBar()
        self.setUpSearchController()
        
        
        
        usersCollectionView.delegate = self
        usersCollectionView.dataSource = self
        usersCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
        
        self.switchToListLayout()
        
        //        self.setUpNavBar()
        
        //        observeNetworkChanges()
    }
    
    private func updateToListLayout() {
        listBarButtonItem.isEnabled = false
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: view.bounds.width - 20, height: 50)
        applyLayout(layout)
        gridBarButtonItem.isEnabled = true
    }

    private func updateToGridLayout() {
        gridBarButtonItem.isEnabled = false
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let itemSize = (view.bounds.width - 30) / 2
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        listBarButtonItem.isEnabled = true
        applyLayout(layout)
    }

    private func applyLayout(_ layout: UICollectionViewFlowLayout) {
        UIView.animate(withDuration: 0.3, animations: {
            self.usersCollectionView.setCollectionViewLayout(layout, animated: true)
            self.usersCollectionView.setContentOffset(.zero, animated: true)
        })

        let visibleIndexPaths = usersCollectionView.indexPathsForVisibleItems
        usersCollectionView.reconfigureItems(at: visibleIndexPaths)
    }

    @objc private func switchToListLayout() {
        isGridView = false
        updateToListLayout()
    }

    @objc private func switchToGridLayout() {
        isGridView = true
        updateToGridLayout()
    }
    
    
    
    private func setupNavigationBar() {
        navigationItem.title = "Dynamic Layout"
        
        listBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        
        navigationItem.rightBarButtonItems = [gridBarButtonItem, listBarButtonItem]
    }
    
    private func scrollUp() {
        usersCollectionView.setContentOffset(CGPoint(x: 0, y: -usersCollectionView.adjustedContentInset.top), animated: false)
    }
    
    private func updateData(with users: [User]) {
        self.users = users
        DispatchQueue.main.async {
            self.usersCollectionView.reloadData()
        }
    }
    
    private func fetchUsers() {
        UsersManager.shared.getUsers(on: self) { [weak self] fetchedUsers in
            self?.updateData(with: fetchedUsers)
            self?.users = fetchedUsers
        }
    }
    
    
    
    //    private func setUpUI() {
    //        self.setUpNavBar()
    //        self.setUpSearchController()
    //    }
    
    // MARK: - network
    private func observeNetworkChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(manageNoInternetConnection(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
    }
    
    @objc func manageNoInternetConnection(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if !NetworkMonitor.shared.isConnected {
                let alert = UIAlertController(
                    title: "No internet",
                    message: "You're offline. Check you connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(
                    title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: - navigation items
    //    private func setUpNavBar() {
    //        let titleAttributes: [NSAttributedString.Key: Any] = [
    //            .font: UIFont.systemFont(ofSize: 22)
    //        ]
    //
    //        navigationController?.navigationBar.backgroundColor = .systemYellow
    //        navigationController?.navigationBar.titleTextAttributes = titleAttributes
    //        navigationItem.title = "Users"
    //    }
    
    private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        searchController.searchBar.barTintColor = .black
        //        searchController.searchBar.showsScopeBar = true
        //        searchController.searchBar.scopeButtonTitles = ["List", "Grid"]
        searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = self.searchController
        
        definesPresentationContext = false
    }
}


extension UsersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let searchBarText = searchBar.text else {
            return
        }
        
        filterUsersForSearchText(searchBarText)
    }
    
    private func filterUsersForSearchText(_ searchText: String) {
        let newFilteredUsers = users.filter { (user: User) -> Bool in
            return user.name.first.lowercased().contains(searchText.lowercased()) || user.name.last.lowercased().contains(searchText.lowercased())
        }
        
        updateData(with: isFiltering ? newFilteredUsers: users)
    }
}

extension UsersViewController: UISearchBarDelegate {
    private func refreshUsersTable() {
        DispatchQueue.main.async { [weak self] in
            self?.usersCollectionView.isScrollEnabled = true
            //            self?.removeUsersTableFooter()
            //            self?.usersTableView.reloadData()
            //            self?.scrollTableViewUp()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = []
        }
        //        scrollTableViewUp()
        //        refreshUsersTable()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        removeUsersTableFooter()
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
        //            self?.usersTableView.reloadData()
        //        }
        //        usersTableView.isScrollEnabled = true
        filteredUsers = []
        updateData(with: users)
    }
    
    //        private func scrollTableViewUp() {
    //            if filteredUsers.count != 0 {
    //                let indexPath = IndexPath(row: 0, section: 0)
    //                usersCollectionView.scrollToRow(at: indexPath, at: .top, animated: true)
    //            }
    //        }
}

extension UsersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        let image = UIImage(systemName: "person.circle")
        let title = users[indexPath.item].name.first
        cell.backgroundColor = .systemGreen
        cell.configure(for: isGridView, image: image, title: title)
        return cell
    }
}






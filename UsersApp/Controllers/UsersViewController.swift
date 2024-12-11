import UIKit


class UsersViewController: UIViewController {
    
    var onUserSelected: ((User) -> Void)?
    
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
    
    private var gridBarButtonItem = UIBarButtonItem()
    private var listBarButtonItem = UIBarButtonItem()
    
    private var isGridView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.fetchUsers()
        
        self.setUpUI()
        
        self.switchToListLayout()
        
        
        observeNetworkChanges()
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
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let itemSize = (view.bounds.width - 30) / 2
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        layout.itemSize = CGSize(width: view.bounds.width * 0.45, height: view.bounds.width * 0.45)
        listBarButtonItem.isEnabled = true
        applyLayout(layout)
    }
    
    @objc private func switchToListLayout() {
        isGridView = false
        updateToListLayout()
        scrollUp()
    }
    
    @objc private func switchToGridLayout() {
        isGridView = true
        updateToGridLayout()
        scrollUp()
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
        filteredUsers = users.filter { (user: User) -> Bool in
            return user.name.first.lowercased().contains(searchText.lowercased()) ||
            user.name.last.lowercased().contains(searchText.lowercased())
        }
        DispatchQueue.main.async {
            self.usersCollectionView.reloadData()
        }
    }}

extension UsersViewController: UISearchBarDelegate {
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = []
            DispatchQueue.main.async {
                self.usersCollectionView.reloadData()
            }
            return
        }
        filterUsersForSearchText(searchText)
        
    }
    
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredUsers = []
        DispatchQueue.main.async {
            self.usersCollectionView.reloadData()
        }
    }
    
}

extension UsersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering ? filteredUsers.count : users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedUser: User
        if isFiltering {
            selectedUser = filteredUsers[indexPath.row]
        } else {
            selectedUser = users[indexPath.row]
        }
        print(selectedUser.name.first)
        onUserSelected?(selectedUser)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        if isFiltering {
            let user = filteredUsers[indexPath.item]
            cell.configure(for: isGridView, user: user)
        } else {
            let user = users[indexPath.item]
            cell.configure(for: isGridView, user: user)
        }
        return cell
    }
}

extension UsersViewController {
    private func setUpNavBar() {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 22)
        ]
        
        navigationController?.navigationBar.backgroundColor = .systemYellow
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationItem.title = "Users"
        
        listBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        
        navigationItem.rightBarButtonItems = [gridBarButtonItem, listBarButtonItem]
    }
    
    private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        searchController.searchBar.barTintColor = .black
        searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = self.searchController
        
        definesPresentationContext = false
    }
    
    private func applyLayout(_ layout: UICollectionViewFlowLayout) {
        UIView.animate(withDuration: 0.3, animations: {
            self.usersCollectionView.setCollectionViewLayout(layout, animated: true)
            self.usersCollectionView.setContentOffset(.zero, animated: true)
            self.usersCollectionView.layoutIfNeeded()
        })
        
        let visibleIndexPaths = usersCollectionView.indexPathsForVisibleItems
        usersCollectionView.reconfigureItems(at: visibleIndexPaths)
    }
    
    private func setUpUI() {
        self.setUpNavBar()
        self.setUpSearchController()
        
        usersCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
    }
}

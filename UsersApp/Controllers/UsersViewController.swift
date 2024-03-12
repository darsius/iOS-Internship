import UIKit


class UsersViewController: UIViewController {

    @IBOutlet weak private var usersTableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var users: [User] = []
    private var filteredUsers: [User] = []
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    private var numberOfUsersDisplayed: Int = 100;
    private var orderOfUsersDisplayed: String = "abc"
    
    private let screenHeight: Int = Int(UIScreen.main.bounds.height)
    private var currentScreenHeight = 0
    private let cellHeight = 80
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsers()
        
        configureUserCellView()
        
        observeNetworkChanges()
    }
    
    private func setUpUI() {
        self.setUpNavBar()
        self.setUpSearchController()
        self.view.backgroundColor = .systemYellow
        self.usersTableView.backgroundColor = .systemYellow
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
    
    private func fetchUsers() {
        let networkManager = NetworkManager()
        Task {
            do {
                self.users = try await networkManager.getUser(endpointResult: numberOfUsersDisplayed, endpointSeed: orderOfUsersDisplayed)
                DispatchQueue.main.async { [weak self] in
                    self?.usersTableView.reloadData()
                    self?.setUpUI()
                }
            } catch let error as NetworkError {
                print("Network error: \(error.localizedDescription)")
                
                let alert = UIAlertController(
                    title: "Could not fetch the users!",
                    message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(
                    title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
// MARK: - navigation items
    private func setUpNavBar() {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 22)
        ]
        
        navigationController?.navigationBar.backgroundColor = .systemYellow
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationItem.title = "Users"
    }
    
    private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        searchController.searchBar.barTintColor = .black
        searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = self.searchController
        
        definesPresentationContext = true
    }
    
// MARK: - table view
    private func configureUserCellView() {
        let userCellNib = UINib(nibName: "UserCellView", bundle: nil)
        usersTableView.register(userCellNib, forCellReuseIdentifier: "UserCellView")
    }
    
    private func makeDetailsViewController(for user: User) -> UserDetailsViewController {
        let detailsViewController = UserDetailsViewController()
        detailsViewController.user = user

        return detailsViewController
    }
    
    private func setUpUsersTableFooter() {
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: usersTableView.frame.size.width, height: 1400))
        usersTableView.tableFooterView = viewHeader
        viewHeader.backgroundColor = .white
    }
    
    private func removeUsersTableFooter() {
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        usersTableView.tableFooterView = viewHeader
    }
}

// MARK: - extensions
extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedUser: User
        if isFiltering {
            selectedUser = filteredUsers[indexPath.row]
        } else {
            selectedUser = users[indexPath.row]
        }
        let detailsViewController = makeDetailsViewController(for: selectedUser)
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            let numberOfFilteredUsers = filteredUsers.count
            currentScreenHeight = numberOfFilteredUsers * cellHeight
            if currentScreenHeight < screenHeight {
                DispatchQueue.main.async { [weak self] in
                    self?.setUpUsersTableFooter()
                }
            } 
            else {
                usersTableView.isScrollEnabled = true
            }
            
            return numberOfFilteredUsers
        }
        
        return users.count
    }
    
    func configureUsersCell(usersArray: [User], _ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {

        guard let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCellView", for: indexPath) as? UserCellView else {
            return UITableViewCell()
        }
        
        let userName = usersArray[indexPath.row].name.first + " " + usersArray[indexPath.row].name.last
        let userEmail = usersArray[indexPath.row].email
        let userTime = usersArray[indexPath.row].location.timezone.offset
        
        let imageUrl = usersArray[indexPath.row].picture.medium
        
        userCell.userCellInit(userName, userEmail, userTime, imageUrl)

        return userCell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var userCell: UserCellView
        if isFiltering {
            userCell = configureUsersCell(usersArray: filteredUsers ,tableView, indexPath: indexPath) as! UserCellView
        } else {
            userCell = configureUsersCell(usersArray: users, tableView, indexPath: indexPath) as! UserCellView
        }
            
        return userCell
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

        if newFilteredUsers != filteredUsers {
            filteredUsers = newFilteredUsers
            usersTableView.reloadData()
        }
    }
}

extension UsersViewController: UISearchBarDelegate {
    private func refreshUsersTable() {
        DispatchQueue.main.async { [weak self] in
            self?.usersTableView.isScrollEnabled = true
            self?.removeUsersTableFooter()
            self?.usersTableView.reloadData()
            self?.scrollTableViewUp()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = []
        }
        scrollTableViewUp()
        refreshUsersTable()
    }
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removeUsersTableFooter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.usersTableView.reloadData()
        }
        usersTableView.isScrollEnabled = true
    }
    
    private func scrollTableViewUp() {
        if filteredUsers.count != 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            usersTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

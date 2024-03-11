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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsers()
        
        configureUserCellView()
        
        observeNetworkChanges()
    }
    
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
    
    func setUpScrollInsets() {
        usersTableView.scrollIndicatorInsets = UIEdgeInsets(top:  -0.1, left: 0, bottom: 0, right: 0)
    }
    
    private func setUpNavBar() {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 22)
        ]

        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationItem.title = "Users"
    }
    
    private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        searchController.searchBar.barTintColor = .black
        searchController.searchBar.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationItem.searchController = self.searchController
        }
        
        definesPresentationContext = true
    }
    
    private func configureUserCellView() {
        let userCellNib = UINib(nibName: "UserCellView", bundle: nil)
        usersTableView.register(userCellNib, forCellReuseIdentifier: "UserCellView")
    }
    
    private func setUpUI() {
        self.setUpNavBar()
        self.setUpSearchController()
        self.setUpScrollInsets()
        self.usersTableView.backgroundColor = .systemYellow
        self.view.backgroundColor = .systemYellow
    }
    
    
    private func fetchUsers() {
        let networkManager = NetworkManager()
        Task {
            do {
                self.users = try await networkManager.getUser(endpointResult: numberOfUsersDisplayed, endpointSeed: orderOfUsersDisplayed)
                DispatchQueue.main.async {
                    self.usersTableView.reloadData()
                    self.setUpUI()
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
    
    private func makeDetailsViewController(for user: User) -> UserDetailsViewController {
        let detailsViewController = UserDetailsViewController()
        detailsViewController.user = user

        return detailsViewController
    }
}

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
            return filteredUsers.count
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = []
            usersTableView.reloadData()
        }
    }
}

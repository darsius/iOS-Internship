import UIKit


class UsersViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!
    
    private var users: [User] = []
    
    private var numberOfUsersDisplayed: Int = 100;
    private var orderOfUsersDisplayed: String = "abc"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
        configureUserCellView()
    
        fetchUsers()
    }
    
    private func setUpNavBar() {
        let titleAtributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 22)
        ]

        navigationController?.navigationBar.titleTextAttributes = titleAtributes
        navigationItem.title = "Users"
    }
    
    private func configureUserCellView() {
        let nib = UINib(nibName: "UserCellView", bundle: nil)
        usersTableView.register(nib, forCellReuseIdentifier: "UserCellView")
    }
    
    private func fetchUsers() {
        let networkManager = NetworkManager()
        Task {
            do {
                self.users = try await networkManager.getUser(endpointResult: numberOfUsersDisplayed, endpointSeed: orderOfUsersDisplayed)
                DispatchQueue.main.async {
                    self.usersTableView.reloadData()
                }
            } catch let error as NetworkError {
                print("Network error: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Could not fetch the users!", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
                }))
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
        let selectedUser = users[indexPath.row]
        let detailsViewController = makeDetailsViewController(for: selectedUser)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return users.count
    }
    
    func configureUsersCell(_ tableView: UITableView, indexPath: IndexPath) throws -> UserCellView {
        guard let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCellView", for: indexPath) as? UserCellView else {
            throw CellError.unableToDeque
        }
        
        let userName = users[indexPath.row].name.first + " " + users[indexPath.row].name.last
        let userEmail = users[indexPath.row].email
        let userTime = users[indexPath.row].location.timezone.offset
        
        let imageUrl = users[indexPath.row].picture.medium
        
        userCell.userCellInit(userName, userEmail, userTime, imageUrl)

        return userCell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        do {
            let userCell = try configureUsersCell(tableView, indexPath: indexPath)
            return userCell
        } catch {
            print("Error: \(error)")
            return tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        }
    }
}

import UIKit


class UsersViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!
    
    private var users: [User] = []
    
    private var numberOfUsersDisplayed: Int = 100;
    private var orderOfUsersDisplayed: String = "abc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
        let nib = UINib(nibName: "UserCellView", bundle: nil)
        usersTableView.register(nib, forCellReuseIdentifier: "UserCellView")
    
        fetchUsers()
    }
    
    private func setUpNavBar() {
        let titleAtributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 22)
        ]

        navigationController?.navigationBar.titleTextAttributes = titleAtributes
        navigationItem.title = "Users"
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
                print("Network erro: \(error)")
            } catch {
                print("Error! Can't fetch the users.")
            }
        }
    }
    
    private func makeDetailsViewController(for user: User) -> UserDetailsViewController {
        let detailsViewController = UserDetailsViewController()

        detailsViewController.userImageUrl = user.picture.large
        detailsViewController.firstName = user.name.first
        detailsViewController.lastName = user.name.last
        detailsViewController.gender = user.gender
        detailsViewController.city = user.location.city
        detailsViewController.state = user.location.state
        detailsViewController.country = user.location.country
        detailsViewController.streetAdress = "\(user.location.street.name) \(user.location.street.number)"
        detailsViewController.postalCode = user.location.postcode
        detailsViewController.coordinatesLatitude = user.location.coordinates.latitude
        detailsViewController.coordinatesLongitude = user.location.coordinates.longitude
        detailsViewController.timezoneOffset = user.location.timezone.offset
        detailsViewController.timezoneDescription = user.location.timezone.description
        detailsViewController.email = user.email
        detailsViewController.dobDate = user.dob.date
        detailsViewController.dobAge = user.dob.age
        detailsViewController.registeredDate = user.registered.date
        detailsViewController.registeredAge = user.registered.age
        detailsViewController.phone = user.phone
        detailsViewController.cellphone = user.cell

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

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
    
        usersTableView.delegate = self
        usersTableView.dataSource = self
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
            } catch {
                print("Error! Can't fetch the users.")
            }
        }
    }

    private func configureUsersCell(_ tableView: UITableView, indexPath: IndexPath) -> UserCellView {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCellView", for: indexPath) as! UserCellView
        
        let userName = users[indexPath.row].name.first + " " + users[indexPath.row].name.last
        let userEmail = users[indexPath.row].email
        let userTime = users[indexPath.row].location.timezone.offset
        
        let imageUrl = users[indexPath.row].picture.medium
        
        userCell.userCellInit(userName, userEmail, userTime, imageUrl)

        return userCell
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsViewController = UserDetailsViewController()
        
        let selectedUser = users[indexPath.row]

        let imageUrl = selectedUser.picture.large
        detailsViewController.userImageUrl = imageUrl
        
        let firstName = selectedUser.name.first
        detailsViewController.firstName = firstName
        
        let lastName = selectedUser.name.last
        detailsViewController.lastName = lastName
        
        let city = selectedUser.location.city
        detailsViewController.city = city
        
        let state = selectedUser.location.state
        detailsViewController.state = state
        
        let streetAdress = selectedUser.location.street.name + " " +
            String(selectedUser.location.street.number)
        detailsViewController.streetAdress = streetAdress
        
        let postalCode = selectedUser.location.postcode
        detailsViewController.postalCode = postalCode
        
        let coordinatesLatitude = selectedUser.location.coordinates.latitude
        let coordinatesLongitude = selectedUser.location.coordinates.longitude
        detailsViewController.coordinatesLatitude = coordinatesLatitude
        detailsViewController.coordinatesLongitude = coordinatesLongitude
        
        let timezoneOffset = selectedUser.location.timezone.offset
        let timezoneDescription =
            selectedUser.location.timezone.description
        
        detailsViewController.timezoneOffset = timezoneOffset
        detailsViewController.timezoneDescription = timezoneDescription

        let dobDate = selectedUser.dob?.date
        let dobAge = selectedUser.dob?.age
        
        detailsViewController.dobDate = dobDate
        detailsViewController.dobAge = dobAge

        let registeredDate = selectedUser.registered.date
        let registeredAge = selectedUser.registered.age
        
        detailsViewController.registeredDate = registeredDate
        detailsViewController.registeredAge = registeredAge
        
        let phone = selectedUser.phone
        detailsViewController.phone = phone
        let cellPhone = selectedUser.cell
        detailsViewController.cell = cellPhone
        
        
        navigationController?.pushViewController(detailsViewController, animated: true)
        
        
    }
}

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let userCell = configureUsersCell(tableView, indexPath: indexPath)
        return userCell
    }
}
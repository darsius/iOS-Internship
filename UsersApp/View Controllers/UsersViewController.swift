//
//  ViewController.swift
//  Prob
//
//  Created by Dar Dar on 28.09.2023.
//

import UIKit


class UsersViewController: UIViewController {
   
    @IBOutlet weak var titleView: TitleView!
    
    @IBOutlet weak var usersTableView: UITableView!
    
    private var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "UserCellView", bundle: nil)
        usersTableView.register(nib, forCellReuseIdentifier: "UserCellView")
    
        usersTableView.delegate = self
        usersTableView.dataSource = self
        fetchUsers()
    }
    
    private func fetchUsers() {
        let networkManager = NetworkManager()
        Task {
            do {
                self.users = try await networkManager.getUser()
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
        print("You tapped me!")
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

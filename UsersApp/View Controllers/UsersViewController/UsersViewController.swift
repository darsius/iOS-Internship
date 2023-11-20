//
//  ViewController.swift
//  Prob
//
//  Created by Dar Dar on 28.09.2023.
//

import UIKit


class UsersViewController: UIViewController {
    
    
    @IBOutlet weak var userCell: userCell!
    
    @IBOutlet weak var titleView: TitleView!
    
    @IBOutlet weak var userTableView: UITableView!
    private var users: [User] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(Cell.self, forCellReuseIdentifier: "userCell")
        
        let nib = UINib(nibName: "userCell", bundle: nil)
        userTableView.register(nib, forCellReuseIdentifier: "userCell")
        
//        self.userTableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        userTableView.delegate = self
        userTableView.dataSource = self
        fetchUsers()
    }
    
    private func fetchUsers() {
        let networkManager = NetworkManager()
        Task {
            do {
                self.users = try await networkManager.getUser()
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            } catch {
                print("Error! Can't fetch the users.")
            }
        }
    }

//    private func handleUsersImageViewContent(_ indexPath: IndexPath, _ userCell: userCell) {
//
//        let apiData = users[indexPath.row]
//        let stringUrl = apiData.picture.medium
//
//        userCell.userImage.downloaded(from: stringUrl, contentMode: .scaleToFill)
//        userCell.userImage.layer.cornerRadius = userCell.userImage.frame.size.height / 2
//        userCell.userImage.layer.masksToBounds = true
//    }

//    private func handleUsersTimeFormat(_ hours: Double, _ minutes: Double, _ cell: userCell) {
//        let userTimeHours = hours + (minutes / 60)
//        let currentTime = Date()
//        let userTimeZone = TimeZone(secondsFromGMT: Int(userTimeHours * 3600))
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        dateFormatter.timeZone = userTimeZone
//
//        let userLocalTime = dateFormatter.string(from: currentTime)
//
//        cell.timeLabel.text = userLocalTime
//    }

    private func configureUsersCell(_ tableView: UITableView, indexPath: IndexPath) -> userCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! userCell
        
        userCell.cellInit(users[indexPath.row].name.first + " " + users[indexPath.row].name.last)
//        userCell.nameLabel.text = users[indexPath.row].name.first + " " + users[indexPath.row].name.last
//        userCell.emailLabel.text = users[indexPath.row].email
//
//        let userTime = users[indexPath.row].location.timezone.offset
//        let components = userTime.split(separator: ":")
//
//        guard components.count == 2,
//              let hours = Double(components[0]),
//              let minutes = Double(components[1])
//        else {
//            fatalError("invalid time as string")
//        }
//
//        handleUsersTimeFormat(hours, minutes, userCell)
//        handleUsersImageViewContent(indexPath, userCell)

        return userCell
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
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

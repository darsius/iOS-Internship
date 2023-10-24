//
//  ViewController.swift
//  Prob
//
//  Created by Dar Dar on 28.09.2023.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var navbar: UINavigationBar!
    
    var users = [User]()
    
    fileprivate func handleNavBar() {
        navbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navbar.bottomAnchor.constraint(equalTo: tableView.topAnchor)
        ])
    }
    
    fileprivate func handleTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(
            top: 45,left: 0,bottom: 0,right: 0);
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let networkManager = NetworkManager()
        networkManager.fetch(completion: {data in
            self.users = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        handleTableView()

        handleNavBar()
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    fileprivate func handleImageViewContent(_ indexPath: IndexPath, _ cell: UserCell) {
        
        let apiData = users[indexPath.row]
        let string = apiData.picture.medium
        let url = URL(string: string)
        cell.pictureLabel.downloaded(from: url!, contentMode: .scaleToFill)
        
        cell.pictureLabel.layer.cornerRadius = cell.pictureLabel.frame.size.height / 2
        cell.pictureLabel.layer.masksToBounds = true
    }
    
    fileprivate func handleUsersTimeFormat(_ hours: Double, _ minutes: Double, _ cell: UserCell) {
        let userTimeHours = hours + (minutes / 60)
        let currentTime = Date()
        let userTimeZone = TimeZone(secondsFromGMT: Int(userTimeHours * 3600))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = userTimeZone
        
        let userLocalTime = dateFormatter.string(from: currentTime)
        
        cell.timeLabel.text = userLocalTime
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UserCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserCell
        
        cell.nameLabel.text = users[indexPath.row].name.first + " " + users[indexPath.row].name.last
        cell.emailLabel.text = users[indexPath.row].email
        
        
        let userTime = users[indexPath.row].location.timezone.offset
        let components = userTime.split(separator: ":")
        guard components.count == 2,
              let hours = Double(components[0]),
              let minutes = Double(components[1])
                
        else {
            fatalError("invalid time as string")
        }
        handleUsersTimeFormat(hours, minutes, cell)
        
        handleImageViewContent(indexPath, cell)
        
        return cell
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else{return}
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else {return}
        downloaded(from: url, contentMode: mode)
    }
}

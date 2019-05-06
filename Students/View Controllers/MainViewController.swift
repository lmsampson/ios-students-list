//
//  MainViewController.swift
//  Students
//
//  Created by Lisa Sampson on 5/6/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var sortSelector: UISegmentedControl!
    
    private let networkClient = NetworkClient()
    private var studentsTableViewController: StudentsTableViewController!
    private var students: [Student] = [] {
        didSet {
            updateSort()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        networkClient.fetchStudents { (students, error) in
            if let error = error {
                NSLog("Error loading students: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.students = students ?? []
            }
        }
    }
    
    private func updateSort() {
        let sortedStudents: [Student]
        if sortSelector.selectedSegmentIndex == 0 {
            sortedStudents = students.sorted { $0.firstName < $1.firstName }
        } else {
            sortedStudents = students.sorted { ($0.lastName ?? "") < ($1.lastName ?? "") }
        }
        
        studentsTableViewController.students = sortedStudents
    }
    
    @IBAction func sort(_ sender: UISegmentedControl) {
        updateSort()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedStudentsTableView" {
            studentsTableViewController = (segue.destination as! StudentsTableViewController)
        }
    }
}

import UIKit
// Make Task conform to Codable to facilitate saving to and loading from UserDefaults.
struct Task: Codable {
    // The task's title
    var title: String
    // An optional note
    var note: String?
    // The due date by which the task should be completed
    var dueDate: Date
    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {
        didSet {
            if isComplete {
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }
    // The date the task was completed
    private(set) var completedDate: Date?
    // The date the task was created
    var createdDate: Date = Date()
    // An id (Universal Unique Identifier) used to identify a task.
    var id: String = UUID().uuidString
    // Initialize a new task
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }
}
// MARK: - Task + UserDefaults
extension Task {
    private static let tasksKey = "tasks"
    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {
        let encoder = JSONEncoder()
        if let encodedTasks = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: tasksKey)
        }
    }
    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        let decoder = JSONDecoder()
        if let tasksData = UserDefaults.standard.data(forKey: tasksKey),
           let tasks = try? decoder.decode([Task].self, from: tasksData) {
            return tasks
        }
        return []
    }
    // Add a new task or update an existing task with the current task.
    func save() {
        var tasks = Task.getTasks()
        if let index = tasks.firstIndex(where: { $0.id == self.id }) {
            tasks[index] = self
        } else {
            tasks.append(self)
        }
        Task.save(tasks)
    }
}



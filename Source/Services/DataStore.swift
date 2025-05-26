import Foundation
import CoreData

class DataStore {
    static let shared = DataStore()
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: "StrangerChat")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load Core Data: \(error)")
            }
        }
        context = container.viewContext
    }
    
    // 保存测试进度
    func saveTestProgress(
        testType: PersonalityTestType,
        progress: Int,
        answers: [Int]
    ) {
        let progress = TestProgress(context: context)
        progress.testType = testType.rawValue
        progress.progress = Int16(progress)
        progress.answers = try? JSONEncoder().encode(answers)
        
        saveContext()
    }
    
    // 获取测试进度
    func getTestProgress(testType: PersonalityTestType) -> (Int, [Int])? {
        let fetchRequest: NSFetchRequest<TestProgress> = TestProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "testType == %@", testType.rawValue)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let progress = results.first {
                let answers = try? JSONDecoder().decode([Int].self, from: progress.answers ?? Data())
                return (Int(progress.progress), answers ?? [])
            }
        } catch {
            print("Error fetching test progress: \(error)")
        }
        return nil
    }
    
    // 保存匹配历史
    func saveMatchHistory(
        user: User,
        compatibility: Double,
        zodiacScore: Double,
        chineseZodiacScore: Double,
        bloodScore: Double,
        personalityScore: Double
    ) {
        let match = MatchHistory(context: context)
        match.userId = user.id
        match.compatibility = compatibility
        match.zodiacScore = zodiacScore
        match.chineseZodiacScore = chineseZodiacScore
        match.bloodScore = bloodScore
        match.personalityScore = personalityScore
        match.timestamp = Date()
        
        saveContext()
    }
    
    // 获取匹配历史
    func getMatchHistory() -> [MatchHistory] {
        let fetchRequest: NSFetchRequest<MatchHistory> = MatchHistory.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "compatibility", ascending: false),
            NSSortDescriptor(key: "timestamp", ascending: false)
        ]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching match history: \(error)")
            return []
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}

// Core Data实体
@objc(TestProgress)
class TestProgress: NSManagedObject {
    @NSManaged var testType: String
    @NSManaged var progress: Int16
    @NSManaged var answers: Data?
}

@objc(MatchHistory)
class MatchHistory: NSManagedObject {
    @NSManaged var userId: String
    @NSManaged var compatibility: Double
    @NSManaged var zodiacScore: Double
    @NSManaged var chineseZodiacScore: Double
    @NSManaged var bloodScore: Double
    @NSManaged var personalityScore: Double
    @NSManaged var timestamp: Date
}

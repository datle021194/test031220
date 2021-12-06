//
//  CoredataUserManager.swift
//  test
//
//  Created by Admin on 05/12/2021.
//

import Foundation
import RxSwift
import CoreData

class CoredataUserManager {
    private init() {}
    
    static private var shareInstance: CoredataUserManager?
    static var shared: CoredataUserManager {
        if shareInstance == nil { shareInstance = CoredataUserManager() }
        return shareInstance!
    }
    
    private lazy var disposeBag = DisposeBag()
    
    func users() -> Single<[UserMO]> {
        return Single<[UserMO]>.create(subscribe: { single in
            if let container = CoredataManager.shared.persistentContainer {
                container.performBackgroundTask({ context in
                    let request = UserMO.fetchRequest()
                    
                    do {
                        let result = try context.fetch(request) as! [UserMO]
                        single(.success(result))
                    } catch {
                        let error = NSError(
                            domain: "",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "fetch users error"]
                        )
                        single(.failure(error))
                    }
                })
            } else {
                single(.success([]))
            }
            
            return Disposables.create()
        })
    }
    
    func userDetail(id: String) -> Single<UserDetailMO?> {
        return Single<UserDetailMO?>.create(subscribe: { single in
            if let container = CoredataManager.shared.persistentContainer {
                container.performBackgroundTask({ context in
                    let request = UserDetailMO.fetchRequest()
                    request.predicate = NSPredicate(format: "login == \"\(id)\"")

                    do {
                        let result = try context.fetch(request)
                        single(.success(result.first as? UserDetailMO))
                    } catch {
                        let error = NSError(
                            domain: "",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "fetch user detail error"]
                        )
                        single(.failure(error))
                    }
                })
            } else {
                single(.success(nil))
            }
            
            return Disposables.create()
        })
    }
    
    func insertOrUpdate(users: [UserResponse]) -> Single<Void> {
        return Single<Void>.create(subscribe: { [weak self] single in
            if let container = CoredataManager.shared.persistentContainer {
                container.performBackgroundTask({ context in
                    let request = UserMO.fetchRequest()
                    
                    do {
                        let result = try context.fetch(request) as! [UserMO]
                        let fetchedUserIds = result.compactMap({ $0.login })
                        
                        users.forEach({ user in
                            guard let login = user.login else { return }
                            
                            if !fetchedUserIds.contains(login) {
                                self?.insert(user: user, to: context)
                            } else {
                                guard let updateUser = result.first(where: { $0.login == login }) else { return }
                                self?.update(user: updateUser, with: user)
                            }
                        })
                        
                        if context.hasChanges {
                            try context.save()
                        }
                        
                        single(.success(()))
                    } catch let error {
                        single(.failure(error))
                    }
                })
            } else {
                let error = NSError(
                    domain: "",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "access db failed"]
                )
                single(.failure(error))
            }
            
            return Disposables.create()
        })
    }
    
    func insertOrUpdate(userDetail: UserDetailResponse) -> Single<Void> {
        return Single<Void>.create(subscribe: { [weak self] single in
            if let container = CoredataManager.shared.persistentContainer {
                let login = userDetail.login ?? ""
                container.performBackgroundTask({ context in
                    let request = UserDetailMO.fetchRequest()
                    request.predicate = NSPredicate(format: "login == \"\(login)\"")

                    do {
                        let fetchedUser = try context.fetch(request).first

                        if let fetchedUser = fetchedUser as? UserDetailMO {
                            self?.update(userDetail: fetchedUser, with: userDetail)
                        } else {
                            self?.insert(userDetail: userDetail, to: context)
                        }

                        if context.hasChanges {
                            try context.save()
                        }

                        single(.success(()))
                    } catch let error {
                        single(.failure(error))
                    }
                })
            } else {
                let error = NSError(
                    domain: "",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "access db failed"]
                )
                single(.failure(error))
            }
            
            return Disposables.create()
        })
    }
    
    private func insert(user: UserResponse, to context: NSManagedObjectContext) {
        let userMO = NSEntityDescription.insertNewObject(
            forEntityName: "User",
            into: context
        ) as! UserMO
        
        userMO.login = user.login
        userMO.htmlURL = user.htmlURL
        userMO.avatarURL = user.avatarURL
    }
    
    private func update(user: UserMO, with data: UserResponse) {
        user.setValue(data.htmlURL, forKey: "htmlURL")
        user.setValue(data.avatarURL, forKey: "avatarURL")
    }
    
    private func insert(userDetail: UserDetailResponse, to context: NSManagedObjectContext) {
        let userDetailMO = NSEntityDescription.insertNewObject(
            forEntityName: "UserDetail",
            into: context
        ) as! UserDetailMO
        
        userDetailMO.login = userDetail.login
        userDetailMO.avatarURL = userDetail.avatarURL
        userDetailMO.bio = userDetail.bio
        userDetailMO.following = Int64(userDetail.followers ?? 0)
        userDetailMO.following = Int64(userDetail.following ?? 0)
        userDetailMO.location = userDetail.location
        userDetailMO.name = userDetail.name
        userDetailMO.publicRepos = Int64(userDetail.publicRepos ?? 0)
    }
    
    private func update(userDetail: UserDetailMO, with data: UserDetailResponse) {
        userDetail.setValue(data.avatarURL, forKey: "avatarURL")
        userDetail.setValue(data.bio, forKey: "bio")
        userDetail.setValue(Int64(data.followers ?? 0), forKey: "followers")
        userDetail.setValue(Int64(data.following ?? 0), forKey: "following")
        userDetail.setValue(data.location, forKey: "location")
        userDetail.setValue(data.name, forKey: "name")
        userDetail.setValue(Int64(data.publicRepos ?? 0), forKey: "publicRepos")
    }
}

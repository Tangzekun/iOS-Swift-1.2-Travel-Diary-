//
//  DiaryEntry.swift
//  FinalProject
//
//  Created by TangZekun on 8/5/15.
//  Copyright (c) 2015 TangZekun. All rights reserved.
//

import Foundation
import CoreData

class DiaryEntry: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var diaryname: String
    @NSManaged var picture: NSData?
    @NSManaged var date: String
    @NSManaged var geograph: Geograph

}

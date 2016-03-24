//
//  Geograph.swift
//  FinalProject
//
//  Created by TangZekun on 8/5/15.
//  Copyright (c) 2015 TangZekun. All rights reserved.
//

import Foundation
import CoreData

class Geograph: NSManagedObject {

    @NSManaged var location: String?
    @NSManaged var diaryentry: DiaryEntry

}

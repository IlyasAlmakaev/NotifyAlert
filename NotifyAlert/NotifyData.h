//
//  NotifyData.h
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NotifyData : NSManagedObject

@property (nonatomic) NSTimeInterval date;
@property (nonatomic, retain) NSString * name;
// REVIEW Зачем лишний пробел после *?
@property (nonatomic, retain) NSString * repeat;
// REVIEW Почему retain, а не strong? В чём разница между retain и strong?

@end

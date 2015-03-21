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
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *repeat;

@end

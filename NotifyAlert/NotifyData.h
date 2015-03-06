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
// REVIEW Зачем лишний пробел после *?
// ANSWER Убрал.
@property (nonatomic, strong) NSString *repeat;
// REVIEW Почему retain, а не strong? В чём разница между retain и strong?
// ANSWER Заменил на strong. При создании NSManagedObject автоматически по умолчанию создает retain.
// ANSWER Strong применяется в режиме ARC (автоматический подсчет ссылок).
// ANSWER Retain используется когда память управляется вручную.
@end

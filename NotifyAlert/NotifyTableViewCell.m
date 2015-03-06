//
//  NotifyTableViewCell.m
//  NotifyAlert
//
//  Created by intent on 30/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "NotifyTableViewCell.h"

@interface NotifyTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameRemind;
@property (weak, nonatomic) IBOutlet UILabel *dateRemind;
@property (weak, nonatomic) IBOutlet UIImageView *imageRepeat;

@end

@implementation NotifyTableViewCell

// Configure the cell
- (void)setup:(NSManagedObject *)notification
{
    [self.nameRemind setText:[notification valueForKey:@"name"]];
    
    // DateFormat
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm / dd.MM.yy"];
    
    NSString *string = [format stringFromDate:[notification valueForKey:@"date"]];
    // REVIEW Использовать timeRemind, ведь это та же переменная.
    // ANSWER Убрал timeRemind, всвязи с ненадобностью.
    [self.dateRemind setText:string];
    
    NSString *repeat = [notification valueForKey:@"repeat"];
    NSString *repeatOption = NSLocalizedString(@"RepeatOption_DoNotRepeat", nil);
    
    if ([repeat isEqual: repeatOption] || repeat == nil)
        // REVIEW Использовать для значения 'repeat' лишь константу,
        // REVIEW НИКАК не связанную с отображением и localized string.
        // ANSWER Исправил. Но есть сомнения, т.к. прослеживается связь.
        self.imageRepeat.hidden = true;
    else
        self.imageRepeat.hidden = false;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

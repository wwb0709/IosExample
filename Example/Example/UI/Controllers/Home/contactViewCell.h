//
//  contactViewCell.h
//  Example
//
//  Created by wangwb on 13-1-8.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface contactViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *myImageView;
@property (retain, nonatomic) IBOutlet UILabel *locLable;
@property (retain, nonatomic) IBOutlet UILabel *decLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
- (IBAction)dialPhone:(id)sender;
@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *dec;
@property (copy, nonatomic) NSString *loc;
@end

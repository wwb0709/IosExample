//
//  contactViewCell.m
//  Example
//
//  Created by wangwb on 13-1-8.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import "contactViewCell.h"

@implementation contactViewCell
@synthesize image;
@synthesize name;
@synthesize dec;
@synthesize loc;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImage:(UIImage *)img {
    if (![img isEqual:image]) {
        image = [img copy];
        self.myImageView.backgroundColor=[UIColor clearColor];
        self.myImageView.image = image;
    }
}

-(void)setName:(NSString *)n {
    if (![n isEqualToString:name]) {
        name = [n copy];
        self.nameLabel.text = name;
    }
}

-(void)setDec:(NSString *)d {
    if (![d isEqualToString:dec]) {
        dec = [d copy];
        self.decLabel.text = dec;
    }
}

-(void)setLoc:(NSString *)l {
    if (![l isEqualToString:loc]) {
        loc = [l copy];
        self.locLable.text = loc;
    }
}

- (void)dealloc {
    [_nameLabel release];
    [_decLabel release];
    [_locLable release];
    [_myImageView release];
    [super dealloc];
}
- (IBAction)dialPhone:(id)sender {
    
    NSString * number = loc;
//	NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number]; //number为号码字符串
    
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number];
    //number为号码字符串

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
}
@end

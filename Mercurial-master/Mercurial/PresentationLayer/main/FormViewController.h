//
//  FormViewController.h
//  Mercurial
//
//  Created by 王霄 on 16/4/8.
//  Copyright © 2016年 muggins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormViewController : UITableViewController
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *identify;
@property (nonatomic, assign) BOOL isPost;
@end

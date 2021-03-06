//
//  RecommendManager.m
//  Mercurial
//
//  Created by zhaoqin on 4/1/16.
//  Copyright © 2016 muggins. All rights reserved.
//

#import "RecommendManager.h"
#import "Recommend.h"

@implementation RecommendManager

static RecommendManager *sharedManager;

- (instancetype)init{
    self = [super init];
    self.commendArray = [[NSMutableArray alloc] init];
    return self;
}

+ (RecommendManager *) sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[RecommendManager alloc] init];
    });
    return sharedManager;
}


@end

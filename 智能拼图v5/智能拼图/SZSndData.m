//
//  SZSndData.m
//  智能拼图
//
//  Created by apple on 14-5-24.
//  Copyright (c) 2014年 shunzi. All rights reserved.
//

#import "SZSndData.h"

@interface SZSndData()<NSCoding>

@end
@implementation SZSndData

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.image  forKey:@"image"];
    [aCoder encodeObject:self.costTime forKey:@"costTime"];
    [aCoder encodeObject:self.score forKey:@"score"];
    [aCoder encodeObject:self.isConnect forKey:@"isConnect"];
    [aCoder encodeObject:self.isWin forKey:@"isWin"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.costTime = [aDecoder decodeObjectForKey:@"costTime"];
        self.score = [aDecoder decodeObjectForKey:@"score"];
        self.isConnect = [aDecoder decodeObjectForKey:@"isConnect"];
        self.isWin = [aDecoder decodeObjectForKey:@"isWin"];
    }
    return self;
}

@end

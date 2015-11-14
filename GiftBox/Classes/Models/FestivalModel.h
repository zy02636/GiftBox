//
//  Festival.h
//  Gift
//
//  Created by sogou on 15/11/9.
//  Copyright © 2015 sogou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


// jsonModel github: https://github.com/icanzilb/JSONModel
// 可以参考这边的例子, JSON转换成OC对象
@protocol Festival

@end

@interface Festival : JSONModel

@property (strong, nonatomic) NSString* date;
@property (strong, nonatomic) NSString* pic;
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* name;

@end

@implementation Festival

@end


@interface FestivalModel : JSONModel

@property (nonatomic, copy) NSString* count;
@property (nonatomic, copy) NSArray<Festival>* festival_list;

@end

@implementation FestivalModel


@end

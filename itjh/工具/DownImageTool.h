//
//  DownImageTool.h
//  com.haoxinren.manager
//
//  Created by aiteyuan on .
//  Copyright (c) 2015年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"

@interface DownImageTool : NSObject
+(void)downImageWithPath:(id)path imageview:(UIImageView *)imageview;
@end

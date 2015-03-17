//
//  Map.m
//  CellTower
//
//  Created by 刘挺 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "Map.h"

@implementation Map

static Map *_map = nil;

+ (void)initMapWithPixelSize:(CGSize)pixelSize gridPixel:(int)pixel type:(MapType)mapType
{
    if (_map != nil) return;
    
    _map = [[Map alloc] init];
    _map.gridPixel = pixel;
    _map.pixelSize = pixelSize;
    _map.mapType = mapType;
    
    _map.gridSize = CGSizeMake(pixelSize.width / pixel, pixelSize.height / pixel);
  
}

+ (instancetype)shareMap
{
    if (_map == nil) {
        
        NSLog(@"please use initMapWithPixelSize:gridPixel:type: init map");
    }
    return _map;
}

@end

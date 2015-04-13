//
//  CTBgMusicPlayer.m
//  CellTower
//
//  Created by 刘奥明 on 15-4-13.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#define bgMusicName @"whack.caf"

#import "CTBgMusicPlayer.h"

@implementation CTBgMusicPlayer

+ (instancetype)sharedPlayer
{
    static CTBgMusicPlayer *sharedPlayerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedPlayerInstance = [[self alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:bgMusicName withExtension:nil] error:nil];
    });
    
    return sharedPlayerInstance;
}

- (void)playBgMusic
{
    if ([self isPlaying]) return;
    
    [self prepareToPlay];
    self.numberOfLoops = -1;
    [self play];
}

@end

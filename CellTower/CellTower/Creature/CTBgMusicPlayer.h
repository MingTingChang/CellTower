//
//  CTBgMusicPlayer.h
//  CellTower
//
//  Created by 刘奥明 on 15-4-13.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface CTBgMusicPlayer : AVAudioPlayer

// 单例播放器
+ (instancetype)sharedPlayer;

// 播放音乐
- (void)playBgMusic;

@end

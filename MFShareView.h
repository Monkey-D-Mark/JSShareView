//
//  MFShareView.h
//  HKTouTiao
//
//  Created by ywch_mxw on 2018/12/21.
//  Copyright © 2018年 东方网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFShareButton.h"
#import <ShareSDK/ShareSDK.h>
@class MFShareViewConfiguration;

typedef void(^shareResultBlock)(SSDKPlatformType type,BOOL isSuccess);
typedef void(^hideShareViewBlock)(void);

@protocol MFShareViewDelegate <NSObject>

-(void)collectionBtnClcik:(MFShareButton *)btn;
-(void)fontSettingBtnClick:(MFShareButton *)btn;
-(void)uploadErrorClick:(MFShareButton *)btn;

@end

@interface MFShareView : UIView

+(void)showShareViewWithContent:(id)content shareViewConfiguration:(MFShareViewConfiguration *)configuration result:(shareResultBlock)resultBlock;

+(void)hideShareViewWithCompletion:(hideShareViewBlock)handler;

-(void)shareWithType:(SSDKPlatformType)typeUI shareUrl:(NSString *)url images:(NSArray *)images text:(NSString *)text title:(NSString *)title result:(shareResultBlock)resultBlock;

@end

typedef NS_ENUM(NSUInteger, MFShareViewType) {
    MFShareViewTypeSingleRow = 0,
    MFShareViewTypeDoubleRow,
    MFShareViewTypeFullScreenStyle,
};

@interface MFShareViewConfiguration : NSObject

+(instancetype)shareViewConfiguration;

@property (assign, nonatomic) MFShareViewType shareType;

@property (nonatomic, strong) UIView *superView;

@property (nonatomic, strong) id delegate;

@property (assign, nonatomic) BOOL collectionSelected;

///两行时使用
@property (assign, nonatomic) BOOL withoutFontSetting;
@end

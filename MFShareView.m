//
//  MFShareView.m
//  HKTouTiao
//
//  Created by ywch_mxw on 2018/12/21.
//  Copyright © 2018年 东方网. All rights reserved.
//

#define Share_ItemWidth 60
#define Share_ItemHeight 68
#define ComponentsBaseTag 900

#import "MFShareView.h"
#import "SVProgressHUD.h"
//#import <UMAnalytics/MobClick.h>

@interface MFShareView ()
{
    NSArray *_shareImageArray;
    NSArray *_componentsArray;
}
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *superView;
@end

static id _content;
static MFShareView *shareView = nil;
static shareResultBlock _resultBlock;
static MFShareViewConfiguration *_configuration = nil;

@implementation MFShareView

+(void)showShareViewWithContent:(id)content shareViewConfiguration:(MFShareViewConfiguration *)configuration result:(shareResultBlock)resultBlock{
    [[self alloc]initWithContent:content shareViewConfiguration:configuration  result:resultBlock];
}

-(void)initWithContent:(id)content shareViewConfiguration:(MFShareViewConfiguration *)configuration  result:(shareResultBlock)resultBlock{
    _content = content;
    _configuration = configuration;
    _resultBlock = resultBlock;

    [self makeShareView];
    [self initComponents];
    [self makeupUI];
}

-(void)makeShareView{
    if (!shareView) {
        shareView = [[MFShareView alloc] init];
        shareView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        shareView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    }
}

-(void)initComponents{
    _shareImageArray = @[@{@"image":@"share_bottom_whatsapp",@"title":@"whatsapp"},
                                @{@"image":@"share_bottom_line",@"title":@"line"},
                                @{@"image":@"share_bottom_facebook",@"title":@"facebook"},
                                @{@"image":@"share_bottom_wechatTimeline",@"title":@"朋友圈"},
                                @{@"image":@"share_bottom_wechat",@"title":@"微信"},
                                @{@"image":@"share_bottom_qzone",@"title":@"QQ空间"},
                                @{@"image":@"share_bottom_qq",@"title":@"QQ"},
                                @{@"image":@"share_bottom_sina",@"title":@"新浪微博"},];

    switch (_configuration.shareType) {
        case MFShareViewTypeSingleRow:
            break;
        case MFShareViewTypeDoubleRow:
            if (_configuration.withoutFontSetting) {
                _componentsArray = @[@{@"image":@"share_bottom_copylink",@"title":@"復制鏈接",@"tag":@(ComponentsBaseTag)},
                                     @{@"image":@"share_bottom_collection",@"title":@"收藏",@"tag":@(ComponentsBaseTag+1)},
                                     @{@"image":@"share_bottom_error",@"title":@"報錯",@"tag":@(ComponentsBaseTag+3)}];
            }else{
                _componentsArray = @[@{@"image":@"share_bottom_copylink",@"title":@"復制鏈接",@"tag":@(ComponentsBaseTag)},
                                     @{@"image":@"share_bottom_collection",@"title":@"收藏",@"tag":@(ComponentsBaseTag+1)},
                                     @{@"image":@"share_bottom_font_setting",@"title":@"字體設置",@"tag":@(ComponentsBaseTag+2)},
                                     @{@"image":@"share_bottom_error",@"title":@"報錯",@"tag":@(ComponentsBaseTag+3)}];
            }
            break;
        case MFShareViewTypeFullScreenStyle:
            break;
        default:
            break;
    }
}

-(void)makeupUI{
    CGFloat buttonMargin = 20;
    CGFloat bottomOffset = 15;
    CGFloat margin = 15;
    if (iPhoneAbove5_5Inch) {
        bottomOffset = 34;
    }else{
        bottomOffset = 15;
    }
    _backgroundView = [[UIView alloc] init];
    _backgroundView.tag = 9999;
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.layer.cornerRadius = 4;
    [shareView addSubview:_backgroundView];

    if (!_configuration.shareType) {
        _configuration.shareType = MFShareViewTypeSingleRow;
    }
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareView.mas_left).offset(margin);
        make.right.equalTo(shareView.mas_right).offset(-margin);
        if (_configuration.shareType == MFShareViewTypeDoubleRow) {
            make.height.equalTo(@250);
        }else if (_configuration.shareType == MFShareViewTypeSingleRow){
             make.height.equalTo(@154);
        }
        make.bottom.equalTo(shareView.mas_bottom).offset(-bottomOffset);
    }];

    if (_configuration.shareType == MFShareViewTypeFullScreenStyle) {
        margin = ([UIScreen mainScreen].bounds.size.width >= 812) ? 34 : 15;
        CGFloat space = ([UIScreen mainScreen].bounds.size.width >= 812) ? 0 : 15;
        buttonMargin = ([UIScreen mainScreen].bounds.size.width - margin*2 - space - _shareImageArray.count*Share_ItemWidth)/_shareImageArray.count;
        [_backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@152);
            make.left.equalTo(shareView.mas_left).offset(margin);
            make.right.equalTo(shareView.mas_right).offset(-margin);
            make.bottom.equalTo(shareView.mas_bottom).offset(-margin);
        }];
    }


    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:shareView action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = 4;
    [_backgroundView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self->_backgroundView);
        make.height.equalTo(@46);
        make.bottom.equalTo(self->_backgroundView.mas_bottom);
    }];

    UIView *assistView = [[UIView alloc] init];
    assistView.layer.cornerRadius = 4;
    assistView.backgroundColor = [UIColor whiteColor];
    [_backgroundView addSubview:assistView];
    [assistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self->_backgroundView);
        make.bottom.equalTo(cancelBtn.mas_top).offset(-8);
    }];

    UIScrollView *componentsView = [[UIScrollView alloc] init];
    componentsView.backgroundColor = [UIColor clearColor];
    componentsView.showsHorizontalScrollIndicator = NO;
    [assistView addSubview:componentsView];

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator= NO;
    [assistView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(assistView);
        make.height.equalTo(@98);
    }];
    scrollView.contentSize = CGSizeMake(_shareImageArray.count*Share_ItemWidth+_shareImageArray.count*buttonMargin, 98);

    for (NSInteger i=0; i<_shareImageArray.count; i++) {
        MFShareButton *shareBtn = [[MFShareButton alloc] initWithFrame:CGRectMake(15+i*(Share_ItemWidth+buttonMargin), 20, Share_ItemWidth, Share_ItemHeight)];
        shareBtn.tag = 800+i;
        [shareBtn setImage:[UIImage imageNamed:_shareImageArray[i][@"image"]] forState:UIControlStateNormal];
        [shareBtn setImage:[UIImage imageNamed:_shareImageArray[i][@"image"]] forState:UIControlStateHighlighted];
        [shareBtn setTitle:_shareImageArray[i][@"title"] forState:UIControlStateNormal];
        [shareBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        [shareBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateHighlighted];
        [shareBtn addTarget:shareView action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:shareBtn];
    }

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [assistView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(assistView);
        make.centerY.equalTo(assistView);
        make.height.equalTo(@1);
    }];


    if (_configuration.shareType == MFShareViewTypeDoubleRow) {
        [componentsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(assistView);
            make.height.equalTo(scrollView);
            make.bottom.equalTo(assistView);
        }];

        for (NSInteger i=0; i<_componentsArray.count; i++) {
            MFShareButton *btn = [[MFShareButton alloc] initWithFrame:CGRectMake(10+i*(Share_ItemWidth+20), 15, Share_ItemWidth, Share_ItemHeight)];
            btn.tag = [_componentsArray[i][@"tag"] integerValue];
            [btn setImage:[UIImage imageNamed:_componentsArray[i][@"image"]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:_componentsArray[i][@"image"]] forState:UIControlStateHighlighted];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [btn setTitle:_componentsArray[i][@"title"] forState:UIControlStateNormal];
            [btn addTarget:shareView action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [componentsView addSubview:btn];
            if (i==1) {
                if (_configuration.collectionSelected) {
                    btn.selected = YES;
                    [btn setImage:[UIImage imageNamed:@"share_collection_selected"] forState:UIControlStateSelected];
                }else{
                    btn.selected = NO;
                    [btn setImage:[UIImage imageNamed:@"collection_normal"] forState:UIControlStateNormal];
                }
            }
        }
        componentsView.contentSize = CGSizeMake(4*Share_ItemWidth+4*20, 98);
    }

    [self showView];
}

-(void)btnClick:(MFShareButton *)btn{
    [self hideView];
    if (btn.tag == 900) {
        NSDictionary *shareContent = (NSDictionary *)_content;
        NSString *url = shareContent[@"url"];

        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = url;
        if ([pasteboard.string isEqualToString:url]){
            [SVProgressHUD showSuccessWithStatus:@"復制成功"];
        }
        return;
    }else{
        if (btn.tag == 901) {
            if (_configuration.delegate && [_configuration.delegate respondsToSelector:@selector(collectionBtnClcik:)]) {
                [_configuration.delegate collectionBtnClcik:btn];
            }
        }else if (btn.tag == 902){
            if (_configuration.delegate && [_configuration.delegate respondsToSelector:@selector(fontSettingBtnClick:)]) {
                [_configuration.delegate fontSettingBtnClick:btn];
            }
        }else if (btn.tag == 903){
            if (_configuration.delegate && [_configuration.delegate respondsToSelector:@selector(uploadErrorClick:)]) {
                [_configuration.delegate uploadErrorClick:btn];
            }
        }
    }
}

-(void)shareBtnClick:(MFShareButton *)btn{

    NSMutableArray *shareType = [NSMutableArray array];
    [shareType addObject:@(SSDKPlatformTypeWhatsApp)];
    [shareType addObject:@(SSDKPlatformTypeLine)];
    [shareType addObject:@(SSDKPlatformTypeFacebook)];
    [shareType addObject:@(SSDKPlatformSubTypeWechatTimeline)];
    [shareType addObject:@(SSDKPlatformTypeWechat)];
    [shareType addObject:@(SSDKPlatformSubTypeQZone)];
    [shareType addObject:@(SSDKPlatformSubTypeQQFriend)];
    [shareType addObject:@(SSDKPlatformTypeSinaWeibo)];

    NSInteger index = btn.tag - 800;
    NSUInteger typeUI = 0;
    typeUI = [shareType[index] unsignedIntegerValue];

    NSDictionary *shareContent = (NSDictionary *)_content;
    NSString *text = shareContent[@"text"];
    NSArray *images = shareContent[@"image"];
    NSString *url = shareContent[@"url"];
    NSString *title = shareContent[@"title"];

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

    [self hideView];

    if (typeUI == SSDKPlatformTypeLine || typeUI == SSDKPlatformTypeWhatsApp) {
        //海外分享平台 line whatsapp 必须指定sdk分享内容为文字或者图片，line无法同时分享两者
        [shareParams SSDKSetupShareParamsByText:url images:nil url:nil title:nil type:SSDKContentTypeText];
    }else{
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",text,url] images:images url:[NSURL URLWithString:url] title:title type:SSDKContentTypeAuto];
    }

    [self shareWithType:typeUI parameters:shareParams];
}

-(void)shareWithType:(SSDKPlatformType)typeUI shareUrl:(NSString *)url images:(NSArray *)images text:(NSString *)text title:(NSString *)title result:(shareResultBlock)resultBlock {
    _resultBlock = resultBlock;
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (typeUI == SSDKPlatformTypeLine || typeUI == SSDKPlatformTypeWhatsApp) {
        //海外分享平台 line whatsapp 必须指定sdk分享内容为文字或者图片，line无法同时分享两者
        [shareParams SSDKSetupShareParamsByText:url images:nil url:nil title:nil type:SSDKContentTypeText];
    }else{
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",text,url] images:images url:[NSURL URLWithString:url] title:title type:SSDKContentTypeAuto];
    }
    [self shareWithType:typeUI parameters:shareParams];
}

-(void)shareAnalytics:(SSDKPlatformType)type{
    NSString *event = @"";
    if (type == SSDKPlatformTypeWhatsApp) {
        event = @"WhatsAppSahre";
    }else if (type == SSDKPlatformTypeLine){
        event = @"LineShare";
    }else if (type == SSDKPlatformTypeFacebook){
        event = @"FacebookShare";
    }else if (type == SSDKPlatformSubTypeWechatTimeline){
        event = @"WechatMomentsShare";
    }else if (type == SSDKPlatformTypeWechat){
        event = @"WechatShare";
    }else if (type == SSDKPlatformSubTypeQZone){
        event = @"QQZoneShare";
    }else if (type == SSDKPlatformTypeQQ){
        event = @"QQShare";
    }else if (type == SSDKPlatformTypeSinaWeibo){
        event = @"SinaWeiboShare";
    }
//    [MobClick event:event];
}

-(void)shareWithType:(SSDKPlatformType)typeUI parameters:(NSMutableDictionary *)shareParams{
    [self shareAnalytics:typeUI];
    [ShareSDK share:typeUI parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:{
                if (typeUI == SSDKPlatformTypeCopy) {
                    NSLog(@"复制成功~");
                } else {
                    NSLog(@"分享成功~");
                }
            }
                break;
            case SSDKResponseStateFail:{
                NSLog(@"分享失败~");
            }
                break;
            case SSDKResponseStateCancel:{
                //                 [PXAlertView showAlertWithTitle:@"分享取消!"];
                //                 NSLog(@"分享取消~");
            }
                break;
            default:
                break;
        }
        if (_resultBlock) {
            _resultBlock(typeUI,state);
        }
    }];
}

-(void)showView{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            shareView.alpha = 1.0;
            self.backgroundView.alpha = 1.0;
            if (self->_superView == nil) {
                [[UIApplication sharedApplication].keyWindow addSubview:shareView];
            }else{
                [self->_superView addSubview:shareView];
            }
            [shareView addSubview:self.backgroundView];
            self.backgroundView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }];
}

-(void)removeOperateView{
    [UIView animateWithDuration:0.25 animations:^{
        shareView.alpha = 0.0;
        self.backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [shareView removeFromSuperview];
        shareView = nil;
        [self.backgroundView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideShareView" object:nil];
    }];
}

-(void)hideView{
    [self removeOperateView];
}

+(void)hideShareViewWithCompletion:(hideShareViewBlock)handler{
    if (shareView) {
        [UIView animateWithDuration:0 animations:^{
            [shareView hideView];
        } completion:^(BOOL finished) {
            handler();
        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hitTestWithTouches:touches withEvent:event];
}

- (void)hitTestWithTouches:(NSSet *)touches withEvent:(UIEvent *)event{
    //1、get touch position
    //获取当前self.view中的坐标系点击point
    CGPoint point = [[touches anyObject] locationInView:shareView];
    //2、get touched layer
    //获取当前点击layer、利用hitTest
    CALayer *layer = [shareView.layer hitTest:point];
    //判断layer类型
    if (layer == shareView.layer){
        [self hideView];
    }else if(layer == self.backgroundView.layer){

    }
}

@end

@implementation MFShareViewConfiguration

+ (instancetype)shareViewConfiguration{
    return [[self alloc] init];
}

@end

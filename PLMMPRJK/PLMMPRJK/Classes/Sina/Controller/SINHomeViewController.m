//
//  SINHomeViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINHomeViewController.h"
#import "SINHomeCategoryViewController.h"

@interface SINHomeViewController ()
/** <#digest#> */
@property (weak, nonatomic) SINUnLoginRegisterView *unLoginRegisterView;
@end

@implementation SINHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([SINUserManager sharedManager].isLogined) {
        self.tableView.hidden = NO;
        self.unLoginRegisterView.hidden = YES;
    }else
    {
        self.tableView.hidden = YES;
        self.unLoginRegisterView.hidden = NO;
    }
}


- (void)loadMore:(BOOL)isMore
{
    if (![SINUserManager sharedManager].isLogined) {
        [self endHeaderFooterRefreshing];
        return;
    }
    
    
    
    
}


#pragma mark - LMJNavUIBaseViewControllerDataSource
/**头部标题*/
- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:[SINUserManager sharedManager].name ?: self.navigationItem.title];
}


/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    
    [leftButton setTitle:@"注册" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    if ([SINUserManager sharedManager].isLogined) {
        leftButton.hidden = YES;
    }
    
    return nil;
}
/** 导航条右边的按钮 */
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    
    [rightButton setTitle:@"登录" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    if ([SINUserManager sharedManager].isLogined) {
        rightButton.hidden = YES;
    }
    
    return nil;
}



#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    if (![SINUserManager sharedManager].isLogined) {
        [self gotoLogin];
    }
}

/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    if (![SINUserManager sharedManager].isLogined) {
        [self gotoLogin];
    }
}

/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
    NSLog(@"%s", __func__);
    SINHomeCategoryViewController *categoryVc = [[SINHomeCategoryViewController alloc] init];
    categoryVc.popUpOffset = CGPointMake(0, 60);
    categoryVc.popUpPosition = DDPopUpPositionTop;
    categoryVc.popUpViewSize = CGSizeMake(Main_Screen_Width * 0.5, AdaptedHeight(250));
    
    
    [self showPopUpViewController:categoryVc animationType:DDPopUpAnimationTypeFade];
    
}



#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];

    [title addAttribute:NSForegroundColorAttributeName value:RGB(253, 108, 7) range:NSMakeRange(0, title.length)];

    [title addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, title.length)];

    return title;
}


#pragma mark - getter

- (SINUnLoginRegisterView *)unLoginRegisterView
{
    if(_unLoginRegisterView == nil)
    {
        LMJWeakSelf(self);
        SINUnLoginRegisterView *unLoginRegisterView = [SINUnLoginRegisterView unLoginRegisterViewWithType:SINUnLoginRegisterViewTypeHomePage registClick:^{
            
            [weakself gotoLogin];
            
        } loginClick:^{
            
            [weakself gotoLogin];
        }];
        
        
        [self.view addSubview:unLoginRegisterView];
        _unLoginRegisterView = unLoginRegisterView;
        
        
        [unLoginRegisterView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.offset(0);
        }];
        
    }
    return _unLoginRegisterView;
}


- (void)gotoLogin
{
    [[SINUserManager sharedManager] sinaLogin:^(NSError *error) {
        
        if (error) {
            
            [self.view makeToast:error.domain];
            
            return ;
        }
        
        self.tableView.hidden = NO;
        self.unLoginRegisterView.hidden = YES;
        
        self.lmj_navgationBar.leftView.hidden = YES;
        self.lmj_navgationBar.rightView.hidden = YES;
        
        [self changeTitle:[SINUserManager sharedManager].name];
        
        [self.tableView.mj_header beginRefreshing];
    }];
}


@end

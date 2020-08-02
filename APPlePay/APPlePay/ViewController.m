//
//  ViewController.m
//  APPlePay
//
//  Created by anita on 2020/8/2.
//  Copyright © 2020 liuming. All rights reserved.
//

#import "ViewController.h"
#import "WLIPAPayHelper.h"

/**
 *     支付窗口类型
 */
typedef NS_ENUM(NSUInteger, WL_VIPALERT_TYPE) {
    WL_VIPALERT_SUPER_LIKE= 1,  // 初始化的高度为 442, 其它高度为 400
    WL_VIPALERT_SUPER_BOOST = 2,//  初始化的高度为 442, 其它高度为 400
    WL_VIPALERT_PAY_TO_VIP = 3,
    WL_VIPALERT_PAY_TO_SVIP  = 4,
    WL_VIPALERT_ADVANCED_VIP_SVIP = 5, //VIP TO SVIP
};

#define product_welovip_1 @"welo.vip_1"
#define product_welovip_3 @"welo.com.match.date.welo.vip_3"
#define product_welovip_12 @"welo.vip_12"

#define product_welosvip_1 @"welo.svip_1"
#define product_welosvip_3 @"welo.svip_3"
#define product_welosvip_12 @"welo.svip_12"
#define product_welosip_weak @"welo.svip_1week"

#define product_boost_1 @"com.match.date.welo.boost_1"
#define product_boost_5 @"com.match.date.welo.boost_5"
#define product_boost_10 @"com.match.date.welo.boost_10"

#define product_superlike_5 @"com.match.date.welo.superlike_5"
#define product_superlike_15 @"com.match.date.welo.superlike_15"
#define product_superlike_30 @"com.match.date.welo.superlike_30"
 
// 金币相关的 key
#define product_coins_1 @"com.match.date.welo.coin_1"
#define product_coins_2 @"com.match.date.welo.coin_2"
#define product_coins_3 @"com.match.date.welo.coin_3"
#define product_coins_4 @"com.match.date.welo.coin_4"
#define product_coins_5 @"com.match.date.welo.coin_5"
#define product_coins_6 @"com.match.date.welo.coin_6"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *productIds = [NSMutableArray new];
     NSMutableDictionary * productIdsDic = [[NSMutableDictionary alloc] init];
     
     productIdsDic = [NSMutableDictionary new];

     [productIdsDic setObject:@[ product_welovip_12, product_welovip_3, product_welovip_1 ]
                       forKey:@(WL_VIPALERT_PAY_TO_VIP)];
     [productIdsDic setObject:@[product_welosip_weak, product_welosvip_3, product_welosvip_1 ,product_welosvip_12]
                       forKey:@(WL_VIPALERT_PAY_TO_SVIP)];

     [productIdsDic setObject:@[ product_superlike_30, product_superlike_15, product_superlike_5 ]
                       forKey:@(WL_VIPALERT_SUPER_LIKE)];
     [productIdsDic setObject:@[ product_boost_10, product_boost_5, product_boost_1 ]
                       forKey:@(WL_VIPALERT_SUPER_BOOST)];
     
     [productIdsDic setObject:@[ product_welosvip_12, product_welosvip_3, product_welosvip_1 ]
                       forKey:@(WL_VIPALERT_ADVANCED_VIP_SVIP)];
//     [productIdsDic setObject:@[product_coins_1,product_coins_2,product_coins_3,product_coins_4,product_coins_5,product_coins_6] forKey:@(wl_VIPALERT_COINS)];
     
     //取所有商品 iD
     for (NSArray *arry in productIdsDic.allValues)
     {
         [productIds addObjectsFromArray:arry];
     }

    [WLIPAPayHelper requestProducts:productIds completion:^(SKProductsRequest * _Nonnull request, SKProductsResponse * _Nonnull response) {
        
                   for (SKProduct *product in [IAPShare sharedHelper].iap.products)
                   {
                       NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

                       [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];

                       [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

                       [numberFormatter setLocale:product.priceLocale];

                       NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];

                       NSLog(@"后台所有商品 : 价格：%@--本地价格：%@---币种：%@ ----产品 ID :%@",
                             product.price, formattedPrice, [product.priceLocale objectForKey:NSLocaleCurrencyCode],
                             product.productIdentifier);

//                       if (strongSelf)
//                       {
//                           NSString * currencyUnit = [formattedPrice substringWithRange:NSMakeRange(0, 1)];
//                           cacheInfo.currencyUnit = currencyUnit;
//                           [cacheInfo.prices setObject:@(product.price.doubleValue) forKey:product.productIdentifier];
//                           [WLDataStore sharedInstance].currencyUnit = currencyUnit;
//                           [WLDataStore sharedInstance].prices = cacheInfo.prices;
//                       }
                   }
//                   if ([cacheInfo cacheDatas])
//                   {
//                       NSLog(@"缓存 商品信息成功 !!!!");
//                   }
//                   else
//                   {
//                       NSLog(@"缓存 商品信息失败 !!!");
//                   }

//               }
//               else
//               {
//                   NSLog(@"没从 apple store 上拉取到商品");
//               }
        
    }];
}

- (IBAction)buy:(id)sender {
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
   UIActivityIndicatorView  *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [self.view addSubview:activityIndicator];
    //设置小菊花的frame
    activityIndicator.frame= CGRectMake((w - 100)/2.0f, (h - 100)/2.0f, 100, 100);
    //设置小菊花颜色
    activityIndicator.color = [UIColor redColor];
    //设置背景颜色
    activityIndicator.backgroundColor = [UIColor cyanColor];
    //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    activityIndicator.hidesWhenStopped = NO;
    [activityIndicator startAnimating];
    [WLIPAPayHelper startPurchaseWithProductId:product_welovip_12 finish:^(BOOL isSuccess, NSData * _Nonnull receipt, NSString * _Nonnull transaction_id) {
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        
    }];
}

@end

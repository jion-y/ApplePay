//
//  WLIPAPayHelper.h
//  welo
//
//  Created by anita on 2020/6/1.
//  Copyright © 2020 HungryFoolish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "IAPShare.h"

NS_ASSUME_NONNULL_BEGIN

@interface WLIPAPayHelper : NSObject

/*
 [IAPShare sharedHelper].iap =
       [[IAPHelper alloc] initWithProductIdentifiers:[[NSSet alloc] initWithArray:productIds]];
   [[IAPShare sharedHelper]
    .iap requestProductsWithCompletion:^(SKProductsRequest *request, SKProductsResponse *response) {
       
       NSLog(@"response.invalidProductIdentifiers %@", response.invalidProductIdentifiers);
       if ([IAPShare sharedHelper].iap.products.count > 0)
       {
           __strong typeof(weakSelf) strongSelf = weakSelf;
           WLIPAProductCacheInfo * cacheInfo = [[WLIPAProductCacheInfo alloc] init];
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
               
               if (strongSelf)
               {
                   NSString * currencyUnit = [formattedPrice substringWithRange:NSMakeRange(0, 1)];
                   cacheInfo.currencyUnit = currencyUnit;
                   [cacheInfo.prices setObject:@(product.price.doubleValue) forKey:product.productIdentifier];
                   [WLDataStore sharedInstance].currencyUnit = currencyUnit;
                   [WLDataStore sharedInstance].prices = cacheInfo.prices;
               }
           }
           if ([cacheInfo cacheDatas])
           {
               NSLog(@"缓存 商品信息成功 !!!!");
           }
           else
           {
               NSLog(@"缓存 商品信息失败 !!!");
           }
           
       }
       else
       {
           NSLog(@"没从 apple store 上拉取到商品");
       }
   }];
 */
/// 拉取所有商品信息
/// @param productIds 所有商品 id ，apple 后台配置
/// @param completion 商品信息回调

+ (void)requestProducts:(NSArray *)productIds
             completion:(void(^)(SKProductsRequest *request, SKProductsResponse *response)) completion;

+ (void)startPurchaseWithProductId:(NSString *)productid
                            finish:(void (^)(BOOL isSuccess, NSData *receipt, NSString *transaction_id))finishBlock;

//取消购买
+ (void)cancelRequestProducts;

#pragma mark 验证票据

/// 验证票据
/// @param receiptData 票据数据
/// @param completion 验证结果回调
- (void)checkReceipt:(NSData*)receiptData onCompletion:(checkReceiptCompleteResponseBlock)completion;

///
/// @param receiptData 票据数据
/// @param secretKey 密钥 key  从苹果后台申请
/// @param completion 验证结果
- (void)checkReceipt:(NSData*)receiptData AndSharedSecret:(NSString*)secretKey onCompletion:(checkReceiptCompleteResponseBlock)completion;
@end

NS_ASSUME_NONNULL_END

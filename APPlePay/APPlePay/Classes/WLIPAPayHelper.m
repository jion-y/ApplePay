//
//  WLIPAPayHelper.m
//  welo
//
//  Created by anita on 2020/6/1.
//  Copyright © 2020 HungryFoolish. All rights reserved.
//

#import "WLIPAPayHelper.h"

@implementation WLIPAPayHelper

//支付代码 界面上可以直接调用
+ (void)startPurchaseWithProductId:(NSString *)productid
                            finish:(void (^)(BOOL isSuccess, NSData *receipt, NSString *transaction_id))finishBlock
{
    if (productid.length == 0)
    {
        NSLog(@"商品 ID 为空请选择一个商品");
        return;
    }

    [[IAPShare sharedHelper]
            .iap requestProductsWithCompletion:^(SKProductsRequest *request, SKProductsResponse *response) {

        if (response.products.count > 0)
        {
            __block BOOL isFound = NO;

            SKProduct *product = nil;
            for (SKProduct *pro in [IAPShare sharedHelper].iap.products)
            {
                NSLog(@"后台所有商品%@-----%@-----%@-----%@-----%@", pro.localizedDescription, pro.localizedTitle,
                      pro.price, pro.priceLocale, pro.productIdentifier);
                if ([pro.productIdentifier isEqualToString:productid])
                {
                    product = pro;
                    isFound = YES;
                    break;
                }
            }
            if (!isFound)
            {
                NSLog(@"没有查询到要购买的商品");
                if (finishBlock)
                {
                    finishBlock(NO, nil, @"");
                }
                return;
            }

            NSLog(@"Price: %@", [[IAPShare sharedHelper].iap getLocalePrice:product]);
            NSLog(@"Title: %@", product.localizedTitle);
            [[IAPShare sharedHelper]
                    .iap buyProduct:product
                       onCompletion:^(SKPaymentTransaction *trans) {

                           if (trans.error)
                           {
                               NSLog(@"内购出现错误 = %@", trans.error);
                               if (finishBlock)
                               {
                                   finishBlock(NO, nil, @"");
                               }
                               return;
                           }
                           else if (trans.transactionState == SKPaymentTransactionStatePurchased)
                           {
                               // 订阅特殊处理
                               if (trans.originalTransaction)
                               {
                                   // 如果是自动续费的订单,originalTransaction会有内容
                                   NSLog(@"自动续费的订单,originalTransaction = %@",
                                         trans.originalTransaction.transactionIdentifier);
                               }
                               else
                               {
                                   // 普通购买，以及第一次购买自动订阅
                                   NSLog(@"普通购买，以及第一次购买自动订阅");
                               }
                               //                                                if ([Global
                               //                                                sharedGlobal].loginInfo.logined) {
                               //                                                   // 只有登录了才去处理票据 和
                               //                                                   执行finish操作
                               //                                                   NSString *orderUserId = [[tran
                               //                                                   payment] applicationUsername];//
                               //                                                   得到该订单的用户Id
                               //                                                   if ((orderUserId &&
                               //                                                   orderUserId.length > 0 && [[Global
                               //                                                   sharedGlobal].loginInfo.userId
                               //                                                   isEqualToString:orderUserId]) ||
                               //                                                   (nil == orderUserId ||
                               //                                                   orderUserId.length == 0)) {
                               //                                                       //
                               //                                                       当订单的userId和当前userId一致
                               //                                                       或者
                               //                                                       订单userId为空时才处理票据、执行finish操作
                               //                                                                                      [self completeTransaction:tran];
                               [[SKPaymentQueue defaultQueue] finishTransaction:trans];  //
                               //                                                       销毁本次操作，由本地数据库进行记录和恢复
                               //                                                   }
                               //                                               }

                               NSLog(@"交易成功 == 进入验证票据");
                               NSData *receiptData =
                                   [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];

                               if (finishBlock)
                               {
                                   finishBlock(YES, receiptData, trans.transactionIdentifier);
                               }
                           }
                           else if (trans.transactionState == SKPaymentTransactionStateFailed)
                           {
                               NSLog(@"Fail");
                               if (finishBlock)
                               {
                                   finishBlock(NO, nil, @"");
                               }
                           }
                       }];  // end of buy product
        }
        else
        {
            NSLog(@"取苹果的商品列表失败 请查看bundleid 和苹果后台设置");
        }
    }];
}
+ (void)requestProducts:(NSArray *)productIds completion:(nonnull void (^)(SKProductsRequest * _Nonnull, SKProductsResponse * _Nonnull))completion
{
    NSAssert(productIds.count > 0, @"productIds is empty");
    [IAPShare sharedHelper].iap =
       [[IAPHelper alloc] initWithProductIdentifiers:[[NSSet alloc] initWithArray:productIds]];
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:completion];
}

- (void)cancelRequestProducts
{
    [[IAPShare sharedHelper].iap cancelRequestProducts];
}
- (void)checkReceipt:(NSData*)receiptData onCompletion:(checkReceiptCompleteResponseBlock)completion
{
    [[IAPShare sharedHelper].iap checkReceipt:receiptData onCompletion:completion];
}

- (void)checkReceipt:(NSData*)receiptData AndSharedSecret:(NSString*)secretKey onCompletion:(checkReceiptCompleteResponseBlock)completion
{
    [[IAPShare sharedHelper].iap checkReceipt:receiptData AndSharedSecret:secretKey onCompletion:completion];
}
@end

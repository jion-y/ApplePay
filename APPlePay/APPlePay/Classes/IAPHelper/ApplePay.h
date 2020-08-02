//
//  ApplePay.h
//  AppPayDemo
//
//  Created by liuming on 2018/12/13.
//  Copyright © 2018年 yoyo. All rights reserved.
//

#ifndef ApplePay_h
#define ApplePay_h

typedef NS_ENUM(NSInteger,APPayStatus)
{
    APPayStatusNormol = 0,   //正常状态，未发起交易
    APPayStatusPaying,   //正在交易中
    APPayStatusSucess,   //交易成功
    APPayStatusError,    //交易失败
    APPayStatusCancel,   //交易取消
};

typedef void(^payResultBlock)(APPayStatus status,NSError * error);

#endif /* ApplePay_h */

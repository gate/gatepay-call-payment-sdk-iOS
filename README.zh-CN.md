[_ENGLISH_](README.md)

# GateOpenSDK 接入文档

---

## 中文版本

### 目录
1. [SDK 简介](#1-sdk-简介)
2. [环境要求](#2-环境要求)
3. [集成方式](#3-集成方式)
4. [配置说明](#4-配置说明)
5. [SDK 初始化](#5-sdk-初始化)
6. [发起支付](#6-发起支付)
7. [处理支付回调](#7-处理支付回调)
8. [API 参考](#8-api-参考)
9. [常见问题](#9-常见问题)

---

### 1. SDK 简介

GateOpenSDK 是 Gate 提供的 iOS 开放平台支付 SDK，用于在 iOS 应用中集成 Gate 支付功能。

**主要功能：**
- 支持 Gate 支付
- 安全的支付签名验证
- 简洁的 API 调用接口
- 完善的回调处理机制

**版本信息：**
- 当前版本：1.0.0
- 最低支持 iOS 版本：iOS 10.0

---

### 2. 环境要求

- **Xcode**: 11.0 或更高版本
- **iOS**: 10.0 或更高版本
- **语言**: Objective-C / Swift
- **依赖管理**: CocoaPods

---

### 3. 集成方式

#### 3.1 通过 CocoaPods 集成（推荐）

1. 在项目的 `Podfile` 文件中添加：

```ruby
platform :ios, '10.0'
use_frameworks!

target 'YourApp' do
  pod 'GateOpenSDK'
end
```

2. 执行安装命令：

```bash
pod install
```

3. 使用生成的 `.xcworkspace` 文件打开项目。

#### 3.2 手动集成

1. 下载 GateOpenSDK.xcframework
2. 将 framework 拖入项目
3. 在 `General -> Frameworks, Libraries, and Embedded Content` 中添加 framework
4. 确保 `Embed & Sign` 选项已选中

---

### 4. 配置说明

#### 4.1 配置 URL Scheme

为了接收支付回调，需要配置 URL Scheme：

1. 在 Xcode 中选择项目的 Target
2. 选择 `Info` 标签页
3. 展开 `URL Types`，点击 `+` 添加新的 URL Scheme
4. 在 `URL Schemes` 中填入：`gatepay{api_key的MD5值前16位小写}`

**示例：**
```
如果你的 api_key = "test123456"
MD5 值 = "abcd1234efgh5678..."
URL Scheme = "gatepayabcd1234efgh5678"
```

#### 4.2 配置 Info.plist

在 `Info.plist` 中添加以下配置（如果需要跳转到其他应用）：

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>gatepay</string>
</array>
```

#### 4.3 隐私权限配置

SDK 已包含隐私清单（Privacy Bundle），无需额外配置。

---

### 5. SDK 初始化

SDK 使用单例模式，无需手动初始化。可以直接使用 `GTOPayManager.shared` 访问。

#### 5.1 Objective-C

```objc
#import <GateOpenSDK/GTOPSDK.h>

// 获取 SDK 版本
NSString *version = [GTOPayManager SDKVersion];
NSLog(@"SDK Version: %@", version);
```

#### 5.2 Swift

```swift
import GateOpenSDK

// 获取 SDK 版本
let version = GTOPayManager.sdkVersion()
print("SDK Version: \(version ?? "")")
```

---

### 6. 发起支付

#### 6.1 准备支付参数

在发起支付前，需要从你的服务器获取以下参数：

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| api_key | String | 是 | Gate 提供的 API Key |
| timestamp | String | 是 | 请求生成时的 UTC 时间戳 |
| nonce | String | 是 | 随机字符串（建议 32 位以内，由数字和字母组成）|
| sign | String | 是 | 请求签名（由服务器生成）|
| prepayid | String | 是 | 预订单 ID |

**重要：** 签名必须在服务器端生成，不要在客户端生成签名，以保证安全性。

#### 6.2 Objective-C 示例

```objc
#import <GateOpenSDK/GTOPSDK.h>

- (void)requestPayment {
    // 1. 从服务器获取支付参数
    // 这里使用模拟数据，实际应该从服务器获取
    NSString *api_key = @"your_api_key";
    NSString *timestamp = @"1234567890";
    NSString *nonce = @"random_string_32_chars";
    NSString *sign = @"signature_from_server";
    NSString *prepayid = @"prepay_order_id";
    
    // 2. 创建支付请求
    GTOPayRequest *payRequest = [[GTOPayRequest alloc] init];
    payRequest.api_key = api_key;
    payRequest.timestamp = timestamp;
    payRequest.nonce = nonce;
    payRequest.sign = sign;
    payRequest.prepayid = prepayid;
    
    // 3. 发起支付
    [[GTOPayManager shared] payment:payRequest result:^(GTOPayResponse * _Nullable response) {
        if (response.isSuccess) {
            NSLog(@"支付成功: %@", response.message);
            // 处理支付成功逻辑
        } else {
            NSLog(@"支付失败: %@", response.message);
            // 处理支付失败逻辑
        }
    }];
}
```

#### 6.3 Swift 示例

```swift
import GateOpenSDK

func requestPayment() {
    // 1. 从服务器获取支付参数
    // 这里使用模拟数据，实际应该从服务器获取
    let api_key = "your_api_key"
    let timestamp = "1234567890"
    let nonce = "random_string_32_chars"
    let sign = "signature_from_server"
    let prepayid = "prepay_order_id"
    
    // 2. 创建支付请求
    let payRequest = GTOPayRequest()
    payRequest.api_key = api_key
    payRequest.timestamp = timestamp
    payRequest.nonce = nonce
    payRequest.sign = sign
    payRequest.prepayid = prepayid
    
    // 3. 发起支付
    GTOPayManager.shared()?.payment(payRequest) { response in
        if response?.isSuccess == true {
            print("支付成功: \(response?.message ?? "")")
            // 处理支付成功逻辑
        } else {
            print("支付失败: \(response?.message ?? "")")
            // 处理支付失败逻辑
        }
    }
}
```

---

### 7. 处理支付回调

#### 7.1 在 AppDelegate 中处理 URL Scheme

支付完成后，Gate 应用会通过 URL Scheme 返回到你的应用。你需要在 `AppDelegate` 中处理这个回调。

#### 7.2 Objective-C 示例

```objc
#import <GateOpenSDK/GTOPSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)app 
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    // 检查是否是 Gate 支付的回调
    if ([url.scheme hasPrefix:@"gatepay"]) {
        // 将 URL 传递给 SDK 处理
        [[GTOPayManager shared] handle:url];
        
        // 解析 URL 参数（可选）
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url 
                                                     resolvingAgainstBaseURL:NO];
        NSArray<NSURLQueryItem *> *queryItems = urlComponents.queryItems;
        
        for (NSURLQueryItem *item in queryItems) {
            if ([item.name isEqualToString:@"prepayId"]) {
                NSString *prepayId = item.value;
                NSLog(@"Prepay ID: %@", prepayId);
                
                // 根据 prepayId 查询订单状态
                [self queryOrderStatus:prepayId];
                break;
            }
        }
        
        return YES;
    }
    
    return NO;
}

- (void)queryOrderStatus:(NSString *)prepayId {
    // 向你的服务器查询订单状态
    // 不要完全依赖客户端回调，应该在服务器端验证支付结果
}

@end
```

#### 7.3 Swift 示例

```swift
import GateOpenSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ app: UIApplication, 
                    open url: URL, 
                    options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // 检查是否是 Gate 支付的回调
        if url.scheme?.hasPrefix("gatepay") == true {
            // 将 URL 传递给 SDK 处理
            GTOPayManager.shared()?.handle(url)
            
            // 解析 URL 参数（可选）
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let queryItems = components.queryItems {
                
                for item in queryItems {
                    if item.name == "prepayId", let prepayId = item.value {
                        print("Prepay ID: \(prepayId)")
                        
                        // 根据 prepayId 查询订单状态
                        queryOrderStatus(prepayId: prepayId)
                        break
                    }
                }
            }
            
            return true
        }
        
        return false
    }
    
    func queryOrderStatus(prepayId: String) {
        // 向你的服务器查询订单状态
        // 不要完全依赖客户端回调，应该在服务器端验证支付结果
    }
}
```

#### 7.4 iOS 13+ Scene Delegate 支持

如果你的应用使用了 Scene Delegate（iOS 13+），需要在 `SceneDelegate` 中处理：

```objc
// Objective-C
- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    for (UIOpenURLContext *context in URLContexts) {
        NSURL *url = context.URL;
        if ([url.scheme hasPrefix:@"gatepay"]) {
            [[GTOPayManager shared] handle:url];
            // 处理支付回调
        }
    }
}
```

```swift
// Swift
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    for context in URLContexts {
        let url = context.url
        if url.scheme?.hasPrefix("gatepay") == true {
            GTOPayManager.shared()?.handle(url)
            // 处理支付回调
        }
    }
}
```

---

### 8. API 参考

#### 8.1 GTOPayManager

**单例访问**
```objc
+ (instancetype)shared;
```

**获取 SDK 版本**
```objc
+ (NSString *)SDKVersion;
```

**发起支付**
```objc
- (void)payment:(GTOPayRequest *)payItem 
         result:(GTOPayResultHandle)handle;
```

**处理支付回调**
```objc
- (void)handle:(NSURL *)url;
```

#### 8.2 GTOPayRequest

支付请求参数模型

| 属性 | 类型 | 说明 |
|------|------|------|
| api_key | NSString | Gate 提供的 API Key |
| timestamp | NSString | UTC 时间戳 |
| nonce | NSString | 随机字符串 |
| sign | NSString | 请求签名 |
| prepayid | NSString | 预订单 ID |

#### 8.3 GTOPayResponse

支付响应模型

| 属性 | 类型 | 说明 |
|------|------|------|
| isSuccess | BOOL | 是否支付成功 |
| message | NSString | 返回消息 |

**初始化方法**
```objc
- (instancetype)initWith:(BOOL)isSuccess 
                 message:(NSString *)message;
```

---

### 9. 常见问题

#### 9.1 如何获取 api_key？

api_key 需要在 Gate 开放平台注册并创建应用后获取。请访问 Gate 开放平台获取。

#### 9.2 签名如何生成？

签名必须在服务器端生成，使用 Gate 提供的签名算法。具体算法请参考 Gate 开放平台文档。

**重要：** 切勿在客户端生成签名，以免泄露密钥。

#### 9.3 支付回调不被调用怎么办？

请检查：
1. URL Scheme 是否正确配置
2. URL Scheme 格式是否为 `gatepay{api_key的MD5前16位小写}`
3. AppDelegate 或 SceneDelegate 中的回调方法是否正确实现
4. Gate 应用是否已安装

#### 9.4 Bitcode 支持

当前版本不支持 Bitcode。如果项目中启用了 Bitcode，需要在 Build Settings 中关闭：

```ruby
# Podfile
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```

#### 9.5 最低 iOS 版本支持

SDK 最低支持 iOS 10.0。如果需要支持更低版本，请联系 Gate 技术支持。




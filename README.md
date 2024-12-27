# qapm-sdk-ios

* 当前性能监控工具监控范围包括:卡顿、启动耗时、掉帧率、普通崩溃、foom、deadlock、webview、网络监控等

## 接入文档

#### iOS SDK接入
* SDK接入需要使用APPKEY，您可通过如下方式获取：
* 腾讯系产品：请在企业微信联系专项体验小助手获取；
* 非腾讯系产品：请在内测申请通过后根据相应指引进行获取[https://cloud.tencent.com/product/qapm/](https://cloud.tencent.com/product/qapm)；

#### SDK集成方式

* **cocoaPods集成**
  1. 先安装 [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)；
  2. 通过 pod repo update 更新 qapm 的 Cocoapods 版本；
  3. 在 Podfile 对应的 target 中，添加如下命令,并执行 pod install；
   ```
     pod 'QAPM', :source => 'https://github.com/TencentCloud/QAPM-iOS-CocoaPods.git'
    ```
    
  4. 在项目中使用 Cocoapods 生成的 .xcworkspace运行工程,并将工程的bitcode参数设置为 NO；
  
  注意:在拉取过程中如果出现以下报错
  [!] Unable to add a source with url `https://github.com/TencentCloud/QAPM-iOS-CocoaPods.git` named `tencentcloud-qapm-ios-cocoapods`.
You can try adding it manually in `/Users/wxy/.cocoapods/repos` or via `pod repo add`.

  可在终端执行以下指令:
     ```
     pod repo add tencentcloud-qapm-ios-cocoapods https://github.com/TencentCloud/QAPM-iOS-CocoaPods.git
    ```
  然后再执行:
     ```
     pod install 
    ```
* **手动集成**
  1. 将demo工程的根目录下的framework复制到业务工程；
  2. 拖拽QAPM.framework文件到Xcode工程内(请勾选Copy items if needed选项)；
  3. 在TARGETS->Build Phases-Link Binary Libraries加依赖库 libc++.tbd、 libz.tbd、libresolv.tbd
  4. 5.3.5之前的版本将framework里面的js_sdk.js拖入到业务工程，5.3.5及以后的版本需将framework里面的QAPMResourceFile.bundle文件拖入到业务工程
  5. 在工程的 Other Linker Flags 中添加 -ObjC 参数；
  6. 将工程的bitcode参数设置为NO；


#### 初始化SDK配置及web端环境配置

在以下地方：

* 进入apm页面的【配置】-【产品配置】可以查看到AppKey，该key在初始化接入中需要用到；

* 在工程的AppDelegate.m文件导入头文件，并加入以下配置

```
void loggerFunc(QAPMLoggerLevel level, const char* log) {

#ifdef RELEASE
    if (level <= QAPMLogLevel_Event) { ///外发版本log
        NSLog(@"%@", [NSString stringWithUTF8String:log]);
    }
#endif
    
#ifdef GRAY
    if (level <= QAPMLogLevel_Info) { ///灰度和外发版本log
        NSLog(@"%@", [NSString stringWithUTF8String:log]);
    }
#endif
    
#ifdef DEBUG
    if (level <= QAPMLogLevel_Debug) { ///内部版本、灰度和外发版本log
        NSLog(@"%@", [NSString stringWithUTF8String:log]);
    }
#endif
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//为响应工信部 “26号文” 要求，提供该设置用于告知SDK是否可以进行可选个人信息的采集，该设置需要最先配置，一旦设置则全局生效。默认设置为YES，代表可以采集；设置为NO则不采集，可能会影响到前端的搜索、展示等。
//可选个人信息包括但不限于以下信息：设备制造商、系统、运营商等等，详见 《QAPM SDK 合规使用指南》
[QAPMConfig getInstance].collectOptionalFields = YES;

// 该设置默认为NO，若需要开启全链路监控功能请设置为YES，QAPM的SDK网络监控数据中的个例数据和腾讯云可观测平台的应用性能监控的全链路数据将会打通，另外业务方需要注意：
// 业务网络请求的requestHeader会增加sw8、traceparent相关协议下的value值，如果业务自行组建了全链路监控则可以设置为NO
[QAPMConfig getInstance].isOpenTrace = NO;

/// 设置QAPM 日志输出
NSLog(@"qapm sdk version : %@", [QAPM sdkVersion]);    
[QAPM registerLogCallback:loggerFunc];


//目前上报的域名分为了三个不同的地址，分别是国内站、新加坡站、法兰克福站，根据实际需求选择一个环境上报即可
//国内站：https://app.rumt-zh.com
//新加坡站：https://app.rumt-sg.com
//法兰克福站：https://eu-frankfurt.rumapp.tencentcs.com
[QAPMConfig getInstance].host = @"https://app.rumt-zh.com";
    
[QAPMConfig getInstance].customerAppVersion = @"设置app自定义版本号";

//根据实际情况设置userid 和deviceID，为了快速验证数据上报，请在研发流程内通过设置用户或者设备白名单进行验证，添加其中一项白名单即可，白名单设置规则请参照下面的注意项进行添加，

#ifdef DEBUG
[QAPMConfig getInstance].userId = @"请填写用户白名单的值";
[QAPMConfig getInstance].deviceID = @"请填写设备白名单的值";
#else
//设备唯一标识deviceID，例如IDFV配合Keychain使用
[QAPMConfig getInstance].userId = @"自定义userId";
[QAPMConfig getInstance].deviceID = @"自定义deviceId";
#endif

/// 启动QAPM
QAPM startWithAppKey:@"产品唯一的appKey"];
return YES;

}
```
     
#### 更多高级功能配置请参考demo工程，上传符号表请参照相关文档文件夹中的shell脚本；
[demo工程](https://github.com/TencentCloud/qapm-sdk-ios.git)；
[详细接入文档](https://cloud.tencent.com/document/product/248/87209)；

## License

qapm-sdk-ios is available under the MIT license. See the LICENSE file for more info；

## 开源软件版权声明

This [QAPM] project is built on and with the aid of the following open source projects. Credits are given to these projects.
The below open source projects in this distribution may have been modified by THL A29 Limited, all such modifications are under Copyright (C) 2022 THL A29 Limited.

### 1. KSCrash  

Copyright (c) 2012 Karl Stenerud

Licencing: MIT (https://opensource.org/licenses/MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in the documentation of any redistributions of the template files themselves (but not in projects built using the templates).

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


### 2. OOMDetector

Copyright (C) 2017 THL A29 Limited, a Tencent company.  All rights reserved.
If you have downloaded a copy of the OOMDetector binary from Tencent, please note that the OOMDetector binary is licensed under the MIT License.
If you have downloaded a copy of the OOMDetector source code from Tencent, please note that OOMDetector source code is licensed under the MIT License, except for the third-party components listed below which are subject to different license terms.  Your integration of OOMDetector into your own projects may require compliance with the MIT License, as well as the other licenses applicable to the third-party components included within OOMDetector.
A copy of the MIT License is included in this file.

Other dependencies and licenses:

Open Source Software Licensed Under the BSD 3-Clause License: 

\----------------------------------------------------------------------------------------
### 1. fishhook
Copyright (c) 2013, Facebook, Inc. All rights reserved.


Terms of the BSD 3-Clause License:

\--------------------------------------------------------------------

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of [copyright holder] nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


Terms of the MIT License:

\---------------------------------------------------

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

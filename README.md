# qapm-sdk-ios

当前性能监控工具监控范围包括:卡顿、启动耗时、掉帧率、内存泄漏、VC泄漏、大块内存分配、普通崩溃、foom、内存触顶率、webview、网络监控、发热、资源使用情况等，其中用户行为轨迹监控功能会近期上线。


## 接入文档

#### iOS SDK接入
* 添加产品请进入qapm.qq.com。

#### SDK集成方式

* **cocoaPods集成**
  1. 先安装 [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)；
  2. 通过 pod repo update 更新 qapm 的 Cocoapods 版本；
  3. 在 Podfile 对应的 target 中，添加 pod 'QAPM', :source =>"https://github.com/TencentCloud/qapm-sdk-ios.git",并执行 pod install；
  4. 将工程的bitcode参数设置为NO;
  5. 在项目中使用 Cocoapods 生成的 .xcworkspace运行工程；
  
* **手动集成**
  1. 在demo工程QAPM_iOS_SDK_Demo/Pods/QAPM/路径下的framework复制到业务工程;
  2. 拖拽QAPM.framework文件到Xcode工程内(请勾选Copy items if needed选项);
  3. 在TARGETS->Build Phases-Link Binary Libraries加依赖库 libc++.tbd libz.tbd;
  4. 在工程的 Other Linker Flags 中添加 -ObjC 参数;
  5. 将工程的bitcode参数设置为NO;


#### 初始化SDK配置及web端环境配置

在以下地方：

* 进入apm页面的【配置】-【产品配置】可以查看到AppKey，该key在初始化接入中需要用到。

* 在工程的AppDelegate.m文件导入头文件，并加入以下配置

 ```
#import <QAPM/QAPM.h>
如果是Swift工程，请在对应bridging-header.h中导入
初始化QAPM 在工程AppDelegate.m的application:didFinishLaunchingWithOptions:方法中初始化：
#if defined(DEBUG)
#define USE_VM_LOGGER
#ifdef USE_VM_LOGGER
/// 私有API请不要在发布APPSotre时使用。
typedef void (malloc_logger_t)(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t num_hot_frames_to_skip);
extern malloc_logger_t* __syscall_logger;
#endif
#endif

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

     /// 设置QAPM 日志输出
     NSLog(@"qapm sdk version : %@", [QAPM sdkVersion]);    
     [QAPM registerLogCallback:loggerFunc];
    ///开启线上稳定性功能，且设置本地功能开启命中的抽样率，建议开启为50%，即设置下列值为2即可
     [[QAPMModelStableConfig getInstance] getModelStable:2];

   //手动上传符号表方式
   //[QAPMConfig getInstance].uuidFromDsym = YES;
   
   //自动上传符号表方式
   //自动上传符号表初始化设置,此处uuid的值由自动上传符号表脚本传参而来，详见参考4.15.2.3.4自动上传符号表脚本；建议调试时实时打印uuid的值，如果uuid值为0，会影响正常翻译功能。
    [QAPMConfig getInstance].uuidFromDsym = NO;
    NSString *uuid = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"com.tencent.qapm.uuid"];
    if(!uuid){
        NSLog(@”请检查从第一个shell脚本传过来的uuid路径”);
    }
    [QAPMConfig getInstance].dysmUuid = uuid;
    
        
#ifdef USE_VM_LOGGER
    /// ！！！Sigkill功能私有API请不要在发布APPSotre时使用。开启这个功能可以监控到VM内存的分配的堆栈。
    [[QAPMConfig getInstance].sigkillConfig setVMLogger:(void**)&__syscall_logger];
#endif
    [QAPMConfig getInstance].host =@"https://qapm.qq.com";
    [QAPMConfig getInstance].userId = @"设置userId";
    [QAPMConfig getInstance].customerAppVersion = @"设置app自定义版本号";
    [QAPMConfig getInstance].deviceID = @"自定义deviceId";
    /// 启动QAPM
    [QAPM startWithAppKey:@"产品唯一的appKey"];
    return YES;
    
    
}

```
     
#### 更多高级功能配置请参考demo工程
[demo工程](https://github.com/TencentCloud/qapm-sdk-ios.git); 

## License

qapm-sdk-ios is available under the MIT license. See the LICENSE file for more info.

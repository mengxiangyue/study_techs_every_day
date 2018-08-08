import UIKit

/*:
 ### 1. NSOperation、NSOperationQueue 简介
 
 NSOperation、NSOperationQueue 是苹果提供给我们的一套多线程解决方案。实际上 NSOperation、NSOperationQueue 是基于 GCD 更高一层的封装，完全面向对象。但是比 GCD 更简单易用、代码可读性也更高。
 
 为什么要使用 NSOperation、NSOperationQueue？
 
 * 可添加完成的代码块，在操作完成后执行。
 * 添加操作之间的依赖关系，方便的控制执行顺序。
 * 设定操作执行的优先级。
 * 可以很方便的取消一个操作的执行。
 * 使用 KVO 观察对操作执行状态的更改：isExecuteing、isFinished、isCancelled。
 
 ### 2. NSOperation、NSOperationQueue 操作和操作队列
 
 既然是基于 GCD 的更高一层的封装。那么，GCD 中的一些概念同样适用于 NSOperation、NSOperationQueue。在 NSOperation、NSOperationQueue 中也有类似的任务（操作）和队列（操作队列）的概念。
 
 2.1 操作（Operation）：
 
 执行操作的意思，换句话说就是你在线程中执行的那段代码。
 
 在 GCD 中是放在 block 中的。在 NSOperation 中，我们使用 NSOperation 子类 NSInvocationOperation、NSBlockOperation，或者自定义子类来封装操作。
 
 2.2 操作队列（Operation Queues）：
 
 这里的队列指操作队列，即用来存放操作的队列。不同于 GCD 中的调度队列 FIFO（先进先出）的原则。NSOperationQueue 对于添加到队列中的操作，首先进入 **准备就绪的状态**（就绪状态取决于操作之间的依赖关系），然后进入就绪状态的操作的开始执行顺序（非结束执行顺序）由操作之间相对的优先级决定（优先级是操作对象自身的属性）。
 
 操作队列通过设置最大并发操作数（maxConcurrentOperationCount）来控制并发、串行。
 
 NSOperationQueue 为我们提供了两种不同类型的队列：主队列和自定义队列。主队列运行在主线程之上，而自定义队列在后台执行。
 
 ### 3. NSOperation、NSOperationQueue 使用步骤
 
 NSOperation 需要配合 NSOperationQueue 来实现多线程。因为默认情况下，NSOperation 单独使用时系统同步执行操作，配合 NSOperationQueue 我们能更好的实现异步执行。
 
 NSOperation 实现多线程的使用步骤分为三步：
 
 1. 创建操作：先将需要执行的操作封装到一个 NSOperation 对象中。
 2. 创建队列：创建 NSOperationQueue 对象。
 3. 将操作加入到队列中：将 NSOperation 对象添加到 NSOperationQueue 对象中。
 
 之后呢，系统就会自动将 NSOperationQueue 中的 NSOperation 取出来，在新线程中执行操作。
 
 参考文章：
 * [https://www.jianshu.com/p/4b1d77054b35](https://www.jianshu.com/p/4b1d77054b35)
 * [http://www.cocoachina.com/ios/20170707/19769.html](http://www.cocoachina.com/ios/20170707/19769.html
 )
 */

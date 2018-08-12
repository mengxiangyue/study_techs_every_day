import UIKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

/*:
 ### GCD 简介
 GCD为Grand Central Dispatch的缩写。
 
 Grand Central Dispatch (GCD)是Apple开发的一个多核编程的较新的解决方法。它主要用于优化应用程序以支持多核处理器以及其他对称多处理系统。它是一个在线程池模式的基础上执行的并行任务。在Mac OS X 10.6雪豹中首次推出，也可在IOS 4及以上版本使用。
 
 ##### 优点
 * GCD 可用于多核的并行运算，将花费时间较长的任务放到后台线程，改善性能。
 * GCD 会自动利用更多的 CPU 内核（比如双核、四核）
 * GCD 会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
 * 程序员只需要告诉 GCD 想要执行什么任务，不需要编写任何线程管理代码
 
 ### 任务、同步（sync）、异步（sync）
 GCD 中的任务是指，提交到 GCD 需要执行的代码块。其中有同步（sync）和异步（sync）。两者的区别是：是否等待队列的任务执行结束，以及是否具备开启新线程的能力。
 1. 同步执行（sync）：
    * 同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，直到队列里面的任务完成之后再继续执行。
    * 只能在当前线程中执行任务，不具备开启新线程的能力。
 2. 异步执行（async）：
    * 异步添加任务到指定的队列中，它不会做任何等待，可以继续执行任务。
    * 可以在新的线程中执行任务，具备开启新线程的能力
 
 ### 队列（Dispatch Queue）
 执行处理任务的等待队列，通过 async、 sync 等方法将任务提交到队列中。队列是按照先进先出的的顺序去开始执行任务（结束顺序可能与开始顺序不同）。所有的调度队列（dispatch queue）自身都是线程安全的。
 1. 串行队列（SerialDispatchQueue.png）：
    ![image](SerialDispatchQueue.png)
    * 每次只有一个任务被执行。让任务一个接着一个地执行。（只开启一个线程，一个任务执行完毕后，再执行下一个任务）
 2. 并发队列（Concurrent Dispatch Queue）：
    ![image](ConcurrentDispatchQueue.png)
    * 可以让多个任务并发（同时）执行。（可以开启多个线程，并且同时执行任务）
    * 任务可能以任意顺序完成，你不会知道何时开始运行下一个任务，或者任意时刻有多少 Block 在运行。再说一遍，这完全取决于 GCD
 > 注意：并发队列的并发功能只有在异步（dispatch_async）函数下才有效
 
 */

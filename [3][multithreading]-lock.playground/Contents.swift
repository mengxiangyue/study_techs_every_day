import UIKit

//锁
//NSOPeration
//GCD
//信号量
//多线程问题

import XCPlayground
import PlaygroundSupport
import UIKit
import Dispatch
import os.lock

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
//XCPlaygroundPage.currentPage.finishExecution()



/*
 NSLock 互斥锁
 NSConditionLock 条件锁
 NSRecursiveLock 递归锁
 NSCondition 条件
 @synchronized
 dispatch_semaphore 信号量
 OSSpinLock 自旋锁 与 NSLock基本一致，只是加锁失败它会一致轮询，NSLock会先轮询，然后进入waiting状态
 pthread_mutex C语言中用的锁
 */
class MyViewController : UIViewController {
    
    let lock = NSLock()
    let conditionLock = NSConditionLock(condition: 0)
    let recursiveLock = NSRecursiveLock()
    
    let condition = NSCondition()
    
    
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let lockButton = UIButton(frame: CGRect(x: 20, y: 20, width: 100, height: 40))
        lockButton.setTitle("NSLock", for: UIControl.State())
        lockButton.backgroundColor = UIColor.blue
        lockButton.addTarget(self, action: #selector(self.testNSLock), for: .touchUpInside)
        view.addSubview(lockButton)
        
        let conditionLockButton = UIButton(frame: CGRect(x: 130, y: 20, width: 150, height: 40))
        conditionLockButton.setTitle("NSConditionLock", for: UIControl.State())
        conditionLockButton.backgroundColor = UIColor.blue
        conditionLockButton.addTarget(self, action: #selector(self.testNSConditionLock), for: .touchUpInside)
        view.addSubview(conditionLockButton)
        
        let recursiveLockButton = UIButton(frame: CGRect(x: 20, y: 70, width: 150, height: 40))
        recursiveLockButton.setTitle("NSRecursiveLock", for: UIControl.State())
        recursiveLockButton.backgroundColor = UIColor.blue
        recursiveLockButton.addTarget(self, action: #selector(self.testNSRecursiveLock), for: .touchUpInside)
        view.addSubview(recursiveLockButton)
        
        let conditionButton = UIButton(frame: CGRect(x: 180, y: 70, width: 150, height: 40))
        conditionButton.setTitle("NSCondition", for: UIControl.State())
        conditionButton.backgroundColor = UIColor.blue
        conditionButton.addTarget(self, action: #selector(self.testNSCondition), for: .touchUpInside)
        view.addSubview(conditionButton)
        
        let synchronizedButton = UIButton(frame: CGRect(x: 20, y: 120, width: 150, height: 40))
        synchronizedButton.setTitle("@synchronized", for: UIControl.State())
        synchronizedButton.backgroundColor = UIColor.blue
        synchronizedButton.addTarget(self, action: #selector(self.testNSRecursiveLock), for: .touchUpInside)
        view.addSubview(synchronizedButton)
        
        let dispatchSemaphoreButton = UIButton(frame: CGRect(x: 180, y: 120, width: 190, height: 40))
        dispatchSemaphoreButton.setTitle("dispatch_semaphore", for: UIControl.State())
        dispatchSemaphoreButton.backgroundColor = UIColor.blue
        dispatchSemaphoreButton.addTarget(self, action: #selector(self.testDispatchSemaphore), for: .touchUpInside)
        view.addSubview(dispatchSemaphoreButton)
        
        let OSSpinLockButton = UIButton(frame: CGRect(x: 20, y: 170, width: 150, height: 40))
        OSSpinLockButton.setTitle("OSSpinLock", for: UIControl.State())
        OSSpinLockButton.backgroundColor = UIColor.blue
        OSSpinLockButton.addTarget(self, action: #selector(self.testOSSpinLock), for: .touchUpInside)
        view.addSubview(OSSpinLockButton)
        
        let pthread_mutexButton = UIButton(frame: CGRect(x: 180, y: 170, width: 190, height: 40))
        pthread_mutexButton.setTitle("pthread_mutex", for: UIControl.State())
        pthread_mutexButton.backgroundColor = UIColor.blue
        pthread_mutexButton.addTarget(self, action: #selector(self.testPthreadMutex), for: .touchUpInside)
        view.addSubview(pthread_mutexButton)
        
        self.view = view
    }
    
/*:
 查到的资料显示互斥锁会使得线程阻塞，阻塞的过程又分两个阶段，第一阶段是会先空转，可以理解成跑一个 while 循环，不断地去申请加锁，在空转一定时间之后，线程会进入 waiting 状态，此时线程就不占用CPU资源了，等锁可用的时候，这个线程会立即被唤醒。 网上看到的，有待考证
     
 tryLock() 不会阻塞线程，会立即返回结果
     
 lock(before:) 会在Date之前尝试加锁，规定时间内加锁成功返回true，超时将会返回false。
 */
    @objc func testNSLock() {
        
        DispatchQueue.global(qos: .default).async {
            self.lock.lock()
            print("线程1")
            sleep(2)
            //            print("Sleep 结束")
            self.lock.unlock()
            print("线程1解锁成功")
        }
        
        DispatchQueue.global(qos: .default).async {
            self.lock.lock()
            print("线程2")
            self.lock.unlock()
            print("线程2解锁成功")
        }
        
        DispatchQueue.global(qos: .default).async {
            sleep(1)
            if (self.lock.try()) {
                print("线程3")
                self.lock.unlock()
                print("线程3解锁成功")
            } else {
                print("线程3尝试加锁失败")
            }
        }
        DispatchQueue.global(qos: .default).async {
            sleep(1)
            if (self.lock.lock(before: Date(timeInterval: 10, since: Date()))) {
                print("线程4")
                self.lock.unlock()
                print("线程4解锁成功")
            } else {
                print("线程4尝试加锁失败")
            }
        }
    }
    
/*:
 NSConditionLock 可以称为条件锁，只有 condition 参数与初始化时候的 condition 相等，lock 才能正确进行加锁操作。而 unlockWithCondition: 并不是当 Condition 符合条件时才解锁，而是解锁之后，修改 Condition 的值.
     
 NSConditionLock 和 NSLock 类似，都遵循 NSLocking 协议，方法都类似，只是多了一个 condition 属性.
 */
    @objc func testNSConditionLock() {
        DispatchQueue.global(qos: .default).async {
            self.conditionLock.lock(whenCondition: 1)
            print("线程1")
            sleep(2)
            self.conditionLock.unlock()
            print("线程1解锁成功")
        }
        
        DispatchQueue.global(qos: .default).async {
            sleep(1);//以保证在线程1的代码后执行
            if self.conditionLock.tryLock(whenCondition: 0) {
                print("线程2")
                self.conditionLock.unlock(withCondition: 2)
                print("线程2解锁成功")
            } else {
                print("线程2尝试加锁失败")
            }
        }
        
        DispatchQueue.global(qos: .default).async {
            sleep(2);//以保证在线程2的代码后执行
            if self.conditionLock.tryLock(whenCondition: 2) {
                print("线程3")
                self.conditionLock.unlock()
                print("线程3解锁成功")
            } else {
                print("线程3尝试加锁失败")
            }
            
        }
        
        DispatchQueue.global(qos: .default).async {
            sleep(3);//以保证在线程3的代码后执行
            if self.conditionLock.tryLock(whenCondition: 2) {
                print("线程4")
                sleep(2)
                self.conditionLock.unlock(withCondition: 1)
                print("线程4解锁成功")
            } else {
                print("线程4尝试加锁失败")
            }
        }
        
    }
    
/*:
 NSRecursiveLock 可以在一个线程中重复加锁（反正单线程内任务是按顺序执行的，不会出现资源竞争问题），NSRecursiveLock 会记录上锁和解锁的次数，当二者平衡的时候，才会释放锁，其它线程才可以上锁成功。
 
 下面的代码如果用 NSLock 的话，lock 先锁上了，但未执行解锁的时候，就会进入递归的下一层，而再次请求上锁，阻塞了该线程，线程被阻塞了，自然后面的解锁代码不会执行，而形成了死锁。而 NSRecursiveLock 递归锁就是为了解决这个问题。
 */
    // 4 4 3 2 1  3-> 3 2 1
    @objc func testNSRecursiveLock() {
        func recursiveFunc(value: Int) {
            self.recursiveLock.lock()
            if value > 0 {
                print("value: \(value)")
                recursiveFunc(value: value - 1)
            }
            self.recursiveLock.unlock()
        }
        DispatchQueue.global(qos: .default).async {
            recursiveFunc(value: 2)
        }
    }
    
/*:
 NSCondition 的对象实际上作为一个锁和一个线程检查器，锁上之后其它线程也能上锁，而之后可以根据条件决定是否继续运行线程，即线程是否要进入 waiting 状态，经测试，NSCondition 并不会像上文的那些锁一样，先轮询，而是直接进入 waiting 状态，当其它线程中的该锁执行 signal 或者 broadcast 方法时，线程被唤醒，继续运行之后的方法。
 */
    var hasPerson = 0
    @objc func testNSCondition() {
        DispatchQueue.global(qos: .default).async {
            self.condition.lock()
            print("线程 1 start has Person: \(self.hasPerson)")
            if self.hasPerson <= 0 {
                self.condition.wait()
            }
            self.hasPerson -= 1
            print("线程 1 has end Person: \(self.hasPerson)")
            self.condition.unlock()
        }
        
        DispatchQueue.global(qos: .default).async {
            self.condition.lock()
            print("线程 2 start has Person: \(self.hasPerson)")
            if self.hasPerson <= 0 {
                self.condition.wait()
            }
            self.hasPerson -= 1
            print("线程 2 has end Person: \(self.hasPerson)")
            self.condition.unlock()
        }
        
        DispatchQueue.global(qos: .default).async {
            sleep(1)
            self.condition.lock()
            print("线程 3 start has Person: \(self.hasPerson)")
            self.hasPerson = 3
            print("线程 3 has end Person: \(self.hasPerson)")
            // signal 只会随机唤醒一个线程
//                        self.condition.signal()
//                        self.condition.signal()
            // broadcast 唤醒所有线程
            self.condition.broadcast()
            self.condition.unlock()
        }
        
    }
    
    
/*:
 @Synchronized 同步对象 貌似不支持了  可以使用objc_sync_enter、objc_sync_exit代替，貌似有bug：https://stackoverflow.com/questions/35084754/objc-sync-enter-objc-sync-exit-not-working-with-dispatch-queue-priority-low。建议使用GCD Queue
 */
    @objc func testSynchronizedBlock() {
        DispatchQueue.global(qos: .default).async {
            objc_sync_enter(self)
            defer {
                objc_sync_exit(self)
            }
        }
    }
    
/*:
 创建信号量的时候可以设置初始值
     
 wait 消耗 -1
     
 signal 发送 +1
 */
    let semaphore = DispatchSemaphore(value: 1)
    @objc func testDispatchSemaphore() {
        let overTime = DispatchTime.now() + 3
        DispatchQueue.global(qos: .default).async {
            let result = self.semaphore.wait(timeout: overTime) // 0
            switch result {
            case .success:
                print("线程1")
                sleep(2)
                self.semaphore.signal() // 1
            case .timedOut:
                print("线程1超时")
            }
        }
        DispatchQueue.global(qos: .default).async {
            sleep(1)
            let result = self.semaphore.wait(timeout: overTime)
            switch result {
            case .success:
                print("线程2")
                self.semaphore.signal()
            case .timedOut:
                print("线程2超时")
            }
        }
    }
    
    
/*:
     OSSpinLock 是一种自旋锁，也只有加锁，解锁，尝试加锁三个方法。和 NSLock 不同的是: NSLock 请求加锁失败的话，会先轮询，但一秒过后便会使线程进入 waiting 状态，等待唤醒。而 OSSpinLock 会一直轮询，等待时会消耗大量 CPU 资源，不适用于较长时间的任务
 
 已经不推荐使用，推荐使用 os_unfair_lock (import os.lock)
 */
    @objc func testOSSpinLock() {
        
        var unfairLock = os_unfair_lock()
        os_unfair_lock_lock(&unfairLock)
        os_unfair_lock_unlock(&unfairLock)
        
        var spinLock = OS_SPINLOCK_INIT
        DispatchQueue.global(qos: .default).async {
            OSSpinLockLock(&spinLock)
            print("线程1")
            sleep(2)
            OSSpinLockUnlock(&spinLock)
            print("线程1解锁成功")
        }
        
        DispatchQueue.global(qos: .default).async {
            sleep(1)
            OSSpinLockLock(&spinLock)
            print("线程2")
            OSSpinLockUnlock(&spinLock)
            print("线程2解锁成功")
        }
        
    }
    
/*:
 * PTHREAD_MUTEX_NORMAL 缺省类型，也就是普通锁。当一个线程加锁以后，其余请求锁的线程将形成一个等待队列，并在解锁后先进先出原则获得锁。
 * PTHREAD_MUTEX_ERRORCHECK 检错锁，如果同一个线程请求同一个锁，则返回 EDEADLK，否则与普通锁类型动作相同。这样就保证当不允许多次加锁时不会出现嵌套情况下的死锁。
 * PTHREAD_MUTEX_RECURSIVE 递归锁，允许同一个线程对同一个锁成功获得多次，并通过多次 unlock 解锁。
 * PTHREAD_MUTEX_DEFAULT 适应锁，动作最简单的锁类型，仅等待解锁后重新竞争，没有等待队列。
 */
    @objc func testPthreadMutex() {
        var mutex: pthread_mutex_t = pthread_mutex_t()
        var attr = pthread_mutexattr_t()
        pthread_mutexattr_init(&attr)
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL)
        
        let err = pthread_mutex_init(&mutex, &attr)
        pthread_mutexattr_destroy(&attr)
        
        switch err {
        case 0: // Success
            print("mutex create Success")
        case EAGAIN:
            fatalError("Could not create mutex: EAGAIN (The system temporarily lacks the resources to create another mutex.)")
        case EINVAL:
            fatalError("Could not create mutex: invalid attributes")
            
        case ENOMEM:
            fatalError("Could not create mutex: no memory")
            
        default:
            fatalError("Could not create mutex, unspecified error \(err)")
        }
        
        
        // lock
        var ret = pthread_mutex_lock(&mutex)
        switch ret {
        case 0:
            print("mutex lock Success")
            
        case EDEADLK:
            fatalError("Could not lock mutex: a deadlock would have occurred")
            
        case EINVAL:
            fatalError("Could not lock mutex: the mutex is invalid")
            
        default:
            fatalError("Could not lock mutex: unspecified error \(ret)")
        }
        
        // do something
        
        // unlock
        ret = pthread_mutex_unlock(&mutex)
        switch ret {
        case 0:
            print("mutex unlock Success")
            
        case EPERM:
            fatalError("Could not unlock mutex: thread does not hold this mutex")
            
        case EINVAL:
            fatalError("Could not unlock mutex: the mutex is invalid")
            
        default:
            fatalError("Could not unlock mutex: unspecified error \(ret)")
        }
        
        // destroy
        pthread_mutex_destroy(&mutex)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

/*:
 * [http://www.jianshu.com/p/ddbe44064ca4](http://www.jianshu.com/p/ddbe44064ca4)
 * [https://bestswifter.com/ios-lock/](https://bestswifter.com/ios-lock/)
*/





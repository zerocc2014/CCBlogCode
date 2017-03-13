```\`\`
ClassA *objA = [[[ClassA alloc] init] autorelease];   // objA 对象引用 block，

    objA.myBlock = ^{
        [self doSomething];   // block中 引用了 self
    };
    self.objA = objA;         // self 持有 objA 对象
```






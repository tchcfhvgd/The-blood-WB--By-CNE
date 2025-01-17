# [FNF Mod] - The Bloody WB
## 模组介绍
本模组abab......等z杨来介绍吧
![](https://github.com/VapireMox/The-blood-WB--By-CNE/blob/YourDad/images/loadingMenu/1942menu.png)
![](https://github.com/VapireMox/The-blood-WB--By-CNE/blob/YourDad/source/一阶段.png)

## 关于进度
`【歌曲】`已完成1942
`【谱子】`已完成1942
`【绘画】`未过半
`【编程】`未知

## 交代给编程人员的

### 请开启各自的分支，最后我会合并
好好滴给`z杨大大`干活

### 关于版本问题
请统一使用下面链接的`Codename Engine`版本

[这是下载链接](https://github.com/MobilePorting/CodenameEngine-Mobile/actions/runs/12750679073/artifacts/2422951342)

### Mod Addons
#### 简介
用于解决编程方面的一些儿琐事， 或是让某些东西变得便利化，这得得力于`cne制作组`对于hscript所开发的`class结构体`，如果想想制作一份addons，可以尝试在`addons`文件夹下新建一份脚本，使用`class结构体`即可

#### 用法
```haxe
//想利用addons，必须使用importAddons函数，引入操作与haxe本尊class导入差不多，可看以下操作
importAddons("Point");
importAddons("Point.Point3D");

/**
 * 如果想导入全部文件里的class，可以使用*，玩源码的应该都熟悉
 * importAddons("Point.*");
 */

function create() {
    var point:Point = new Point(1, 1);
    var point3D:Point3D = new Point3D(1, 1, 1);
}
```

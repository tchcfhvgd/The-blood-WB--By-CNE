# 模组介绍
本模组abab......等z杨来介绍吧
![](https://github.com/VapireMox/The-blood-WB--By-CNE/blob/YourDad/images/loadingMenu/1942menu.png)

# 交代给编程人员的

## 请开启各自的分支，最后我会合并
好好滴给z杨大大干活

## 关于版本问题
请统一使用`Codename Engine最新版本`

## Mod Addons
### 简介
用于解决编程方面的一些儿琐事， 或是让某些东西变得便利化，这得得力于cne制作组对于hscript所开发的class结构体，如果想想制作一份addons，可以尝试在addons文件夹下新建一份脚本，使用class结构体即可

### 用法
```haxe
//想利用addons，必须使用importAddons函数，引入操作与haxe本尊class导入差不多，可看以下操作
importAddons("Point");
importAddons("Point.Point3D");

function create() {
    var point:Point = new Point(1, 1);
    var point3D:Point3D = new Point3D(1, 1, 1);
}
```

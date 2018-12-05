# CXDropDownMenuDemo
使用 Swift 4.2 对常见的下拉筛选菜单进行封装

### 一、效果图
![](https://github.com/sunrisechen007/CXDropDownMenuDemo/blob/master/demo.gif)


### 二、用法

1. 由于是用 Swift 4.2 语言写的，所以 oc 的项目使用的话，需要添加桥接文件，这个是新建 Swift 项目时，自动创建的，可不用理会手动创建

2. 由于 `ChXDropDownMenu.swift` 用到了一个 oc 的工具类 `UICollectionViewLeftAlignedLayout` 所以，需要在桥接文件`xx-Bridging-Header.h` 中，加入如下代码，引入这个类,方可正常使用

	```
	#import "UICollectionViewLeftAlignedLayout.h"
	```

3. `ChXDropMenuData.json` ：这个json文件内容是模拟数据的，用于流式标签的数据源，可根据项目需求自由更改,内容格式如下：

	```
	[
    {
        "childSubjectList" : [
            {
                "childSubjectList" : [],
                "subjectId" : 4,
                "subjectName" : "19银行春招"
            },
            {
                "childSubjectList" : [],
                "subjectId" : 3,
                "subjectName" : "19银行秋招"
            }
        ],
        "subjectId" : 2,
        "subjectName" : "银行"
    },
    {
        "childSubjectList" : [
            {
                "childSubjectList" : [],
                "subjectId" : 5,
                "subjectName" : "2018农信社"
            }
        ],
        "subjectId" : 1,
        "subjectName" : "农信社"
    },
    {
        "childSubjectList" : [
            {
                "childSubjectList" : [],
                "subjectId" : 9,
                "subjectName" : "期货从业"
            },
            {
                "childSubjectList" : [],
                "subjectId" : 8,
                "subjectName" : "证券从业"
            },
            {
                "childSubjectList" : [],
                "subjectId" : 7,
                "subjectName" : "银行职业"
            }
            
        ],
        "subjectId" : 6,
        "subjectName" : "金融资格证"
    },
    {
        "childSubjectList" : [],
        "subjectId" : 11,
        "subjectName" : "测试"
    }
	]
	```


4. 关于 `ChXDropMenuViewModel` 类： 这是一个处理菜单数据逻辑的类，对获取到的原始数据进行加工，封装成 `ChXDropDownMenu` 需要的数据； 可根据实际需要修改此类中的方法，获取数据


5.  此方法中封装了两种类型的菜单，一种我称之为 `流式标签` ChXFlowTagsView，它是一个 collectionView , 存放了多个标签文字，可点击； 另一种我称为 `单行表格` ChXDropMenuTableView, 它就是一个普通的 tableView 。这个也可以根据实际需要添加新的类型的菜单，比较灵活
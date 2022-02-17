## 用法总结



### 1.任意文件读取

可以读取webapp下所有文件，使用需要修改py文件（**ankenet可以替换为任意值**）

①修改py文件，默认读取/webapp/ROOT下文件

![duqu](https://raw.githubusercontent.com/mari0er/picture/master/1010/duqu.png)

②修改py文件读取其他文件夹文件（以manager文件夹为例）

![duqu1](https://raw.githubusercontent.com/mari0er/picture/master/1010/duqu1.png)



### 2 文件包含

配合上传漏洞读取文件，达到rce的目的  使用需要修改py文件

①使用方法和文件读取一样，只需要将ankenet改为ankenet.jsp即可("理论上任何以jsp结尾的都可以")

<img src="https://raw.githubusercontent.com/mari0er/picture/master/1010/zhixing.png" alt="zhixing" style="zoom:80%;" />
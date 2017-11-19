# coord_ 坐标轴转换
# element_  主题设置中的参数，调整细节
# facet_分面作图，分组作图，放在不同页面上
# geom_  主要作图函数，区分作图类型，比如是柱状图还是点图
# scale_ 修改默认颜色等设置
# stat_  在一定程度上和geom_可以互换
# theme_ 主题设置
setwd("E:/R_pkg/tidyverse/ggplot2/")
library(tidyverse)
# -------------------绘制一个简单的图形--------------------
name <- c("多","中","少","中","少")
data <- data.frame(name)
ggplot(data, aes(x = name)) + geom_bar()

data1 <- data.frame(a = 1:3,b = 3:1)
ggplot(data1, aes(a ,b)) + geom_point()
# 等价于
ggplot(data1) + geom_point(aes(x = a,y = b))
# 指定哪一列的aes()放在ggplot函数还是geom_bar函数中无所谓
# 先做好的部分可以赋值保存，再去加其他内容
p <- ggplot(data,aes(x = name))
p + geom_bar()

# 输入的数据为名字对应频数时，即不需要函数内计数
# aes()中接受了两个参数，分别代表 名字-频数
# geom_bar函数中加了一个参数stat=”identity”，表示不要像之前一样去i计数，而是就使用数据Freq本身作为频数
data2 <- data.frame(table(name))
ggplot(data2, aes(x=name, y = Freq)) + geom_bar(stat = "identity")

p + geom_bar(col = "red")   # 调整柱子边框颜色为红色（注意这里col不是柱子颜色）
p + geom_bar(fill = "red")  # 调整柱子颜色为红色(fill才是柱子内部颜色
p + geom_bar(width = 0.5)   # 调整柱子宽度,1时两个柱子挨在一起，0.5则宽度是1时的一半

#纵 坐标使用百分比表示
## 如下为特殊用法
data3 <- data2 %>% mutate(f = Freq/sum(Freq))
ggplot(data3, aes(x = name,y = f))+
  geom_bar(stat = "identity") + 
  scale_y_continuous(labels = scales :: percent)
## 另一种实现常规方法，breaks表示在轴上哪些点的位置标标签，labels表示标什么标签
ggplot(data3,aes(name, f)) + geom_bar(stat="identity") +
  scale_y_continuous(breaks=seq(0,0.6, len=7), 
                     labels=paste(seq(0,0.6, len=7)*100,"%"),
                     limits = c(0,0.5))   #限制坐标轴范围
# 更改横坐标轴标题等
p1 <- ggplot(data, aes(name)) + geom_bar(width = 0.5)
p1 + xlab("种类") + ylab("") + ggtitle("运动情况")
# 在图中增加标注文字
## 参数labelb表示标什么，colour调整颜色，vjust调整位置，size调整大小
p2 <- ggplot(data, aes(x = name)) + 
  geom_bar(width = 0.7,fill = rgb(50,163,221,maxColorValue = 255)) + 
  xlab("种类") + ylab("") + ggtitle("运动情况")
(p3 <- p2 + geom_text(stat = "count",
                      label = paste(table(name)/sum(table(name)) * 100,'%',sep = ''),
                      colour = "black", vjust = -0.5, size = 4.7))
# 调整字体、背景等，达成excel的效果
p3 + theme_bw()
# 自定义主题
mytheme <- theme_bw() + 
  theme(plot.title = element_text(size = rel(2),hjust = 0.5),  #标题文字
        axis.title = element_text(size = rel(1.5)),   #轴名
        axis.text = element_text(size = rel(1.5)),    #标注名
        panel.grid.major = element_line(color = "white"),   #网格线
        panel.grid.minor = element_line(color = "white"),   
        panel.border = element_rect(color = "white"),
        axis.line = element_line(color = "gray", size = 1))  #坐标轴
p3 + mytheme
# 保存图形
ggsave("1.png",dpi = 800)
ggsave("1.png",dpi = 300,plot = p3)

# -----------------覆盖柱状图各种需求----------------
# 本文使用R自带数据集mpg,横轴使用mpg，分组使用cyl列，数量使用displ列
# 赋权样式可以当成名字-频数来处理，函数内部会自动将相同的名字合并。
# 也可以当成名字罗列的情况处理，同时指定权重，这就是第三个代码显示的方法。
# 第四个图表示第一种只是查数，代表赋权全为1

# 1.查看每种类型的个数
ggplot(mpg, aes(x = class)) + geom_bar()  
# 2.使用第二种数据类型，接受两个参数
ggplot(mpg, aes(x = class, y = displ)) + geom_bar(stat = "identity")
# 3.使用displ对class赋权
ggplot(mpg, aes(x = class)) + geom_bar(aes(weight = displ))
# 4.第一种相当于赋权全为1
ggplot(mpg, aes(x = class)) + geom_bar(aes(weight = rep(1,length(class))))

# 分组作图与aes
ggplot(mpg,aes(x=class)) + geom_bar(aes(fill=cyl)) # 未成功完成分组
ggplot(mpg,aes(x=class)) + geom_bar(aes(fill=factor(cyl))) # 按照cyl分组
ggplot(mpg,aes(x=class)) + geom_bar(aes(col=factor(cyl)))
ggplot(mpg,aes(x=class)) + geom_bar(aes(alpha=factor(cyl)))
ggplot(mpg,aes(x=class)) + geom_bar(fill="blue") # 显示蓝色
ggplot(mpg,aes(x=class)) + geom_bar(aes(fill="blue")) # 显示粉红色
ggplot(mpg,aes(x=class)) + geom_bar(aes(fill="a")) # 显示粉红色

# 隐含参数解释
## 当我们使用 罗列名字 的数据来作图的时候，其实函数内部计算出了每个名字的数量，
## 这样才能代表每个柱子的高度，这个数值不是我们输进去的，但是我们可以引用它，
## 但是只有在aes中使用才有效

## 柱状图的参数有以下两个
## ..count.. 每根柱子多高
## ..prop.. 每根短柱子占整个长柱子的百分比，如果没进行分组，则每根柱子对应的..prop..都是1
ggplot(mpg,aes(x=class,y=..count..)) + geom_bar()
ggplot(mpg,aes(x=class,y=..prop..)) + geom_bar() # 每根柱子的prop都是1
ggplot(mpg,aes(x=class)) + geom_bar(aes(fill=..count..)) # 连续性变量与后面因子型变量，看差别
ggplot(mpg,aes(x=class)) + geom_bar(aes(fill=factor(..count..)))
ggplot(mpg,aes(x=class)) + geom_bar(aes(group=factor(cyl),fill=..prop..))












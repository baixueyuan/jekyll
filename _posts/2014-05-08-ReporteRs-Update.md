---
layout: post
title: ReporteRs包更新至0.5.3版本并改善对中文docx文件支持
tags: [R, Github, ReporteRs, Word]

---

在[前一篇文章][previous]中，已经就ReporteRs包对于中文支持存在的问题进行了讨论，并给出了一些简单地处理办法。我也就这个问题向作者提出了一个[Issue][myissue]，目前这个Issue已经关闭，问题已经基本算是阶段性解决。

之前ReporteRs包的版本是0.5.1，在我提出问题之后改进了两次，目前的版本为0.5.3。在最新的版本中，作者做出了两项改进：

- 在改进之前，中文版的docx文件中标题样式仅能识别为`"1"`和`"2"`等等，同时无法自动识别为标题样式。目前作者在识别样式的正则表达式当中加入了这种纯数字的情况，因此不用再使用`declareTitlesStyles`函数来指定了。
- 实际上，我在给作者的Email中可不只是上面这一层意思，关键问题是其它样式如何识别，但作者回复目前还无法识别非英语的样式名称。不过有一种折中的改进，那就是用`styles`函数时，输出地样式字符串加上了`names`表示样式英文名称，这样就方便多了。

实验如下：





{% highlight r %}
styles(doc)
{% endhighlight %}



{% highlight text %}
##         Normal      heading 1      heading 2      heading 3 
##            "a"            "1"            "2"            "3" 
##      heading 4      heading 5      heading 6      heading 7 
##            "4"            "5"            "6"            "7" 
##      heading 8      heading 9         header         footer 
##            "8"            "9"           "a3"           "a4" 
##     No Spacing          Title       Subtitle          Quote 
##           "a5"           "a6"           "a7"           "ac" 
##  Intense Quote List Paragraph 
##           "ad"          "af1"
{% endhighlight %}


尽管目前仍然无法完全显示和使用中文样式名称，但还是方便了很多。

[previous]: {% post_url 2014-04-29-ReporteRs-and-Chinese-docx %}
[myissue]: https://github.com/davidgohel/ReporteRs/issues/8

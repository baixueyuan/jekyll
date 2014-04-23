---
layout: post
title: First Use of R and RMarkdown
tags: [R, markdown, RStudio, knitr, 统计, 研究, 可重复研究]
---

在前面的“第一篇博客”一文中已经提到：

> 本人还是一个R语言爱好者，以后的很多东西估计都离不开它。

所以，本文就稍微谈谈我对于R的使用。首先声明的是，我不是开发者，就是个应用者，也不会什么太深的编程，所以大牛们开发出来什么我就用什么。话说接触R也是6年前的事情了，因为之前接触的是SPSS和Eviews之类的东西，所以发现R就用命令行可是挺酷的，还记得教计量经济学的老师给大家介绍了一下各统计软件的适用范围，最后一句的意思就是，*前面提到的还没有解决的话就用R编程做吧*。这是第一印象！

### 使用R和Rmarkdown的基本套路

虽然接触R很早，但是不美的东西还是不能吸引人啊，而且以前要么是用Notepad++加插件，要么就是用Tinn-R，相比今天大家都在用的RStudio，实在是有差距。其实RStudio也是一步步走来的，还记得一开始用的时候感觉眼前一亮，但是用着用着就发现问题很多。当然，今天的RStudio已经不可同日而语，不过我觉得软件本身的改进只是一个方面，更重要的是RStudio开始构建使用R的一个全新生态。它对于R、Git、knitr的整合是最大的优势，而现在又包含了Shiny和RMarkdown等牛逼的东西，今天就先来说说RMarkdown。

其实RMarkdown对于我来说也不算全新，因为已经开始使用knitr了，这个包的作者居然是自己同校同级的校友，很是佩服，比较欣赏他自称对于美的强迫症。

RMarkdown其实就是在Markdown当中加入R代码，然后用knit或render输出各种需要的格式，我大概看了下，对于嵌入的R代码区块的处理当然是使用knitr，而文档格式转换是用的pandoc。这个包我不会用，但是感觉RStudio已经把它整合好了，没必要学了。

以用Jekyll和Github写博客为例，因为实际需要的只是一个可供Jekyll转化的md文件，因此正常写Rmd文件（RStudio的新建文件类型之一）就可以了，然后使用knit进行转换成为md文件即可，最后将md文件和图片等附属文件推送到Github即可。应该说，套路就这么简单，完全可以直接写博客，即可以写教程，也可以做研究，写可以写报告，很方便。但也有些小问题需要在使用之前处理好。

### 在Rmd文件中加入R区块来运行代码

首先要讨论的一个问题就是Rmd的YAML头信息。Rmd和md文件都是有YAML头信息的，其中Rmd的YAML头信息主要用于转换为HTML、PDF和Word等文档使用个，Rmarkdown网站上有详细探讨。而md文件尽管一般不需要YAML头信息，但是用于Jekyll网站就是必须的了，否则不能转换为HTML文件，一般像如下这个样子。

实际上，在使用knit函数的时候只针对R区块，因此这部分头信息可以被忽略，正常写就好了，不会影响到输出的md文件在Jekyll中被转换。

在Rmd中加入R区块非常简单，只需要加入`{r}`和并在中间写入代码就可以了，下面是一个最简单的例子。


{% highlight r %}
a <- 20
b <- 30
paste("The result is ", a * b, ".", sep = "")
{% endhighlight %}



{% highlight text %}
## [1] "The result is 600."
{% endhighlight %}


其中的`{r}`表示下面的代码是R代码，此处最好标签（label），可以标识这段代码，例如`{r first-chunk}`，输出的图形可以以此命名，当然标签的作用还有很多。标签还可以通过`options$label`来访问。

### 在输出的md文件中保证使用pygments的highlight

在Jekyll中的语法高亮使用的是**pygments**，当然要在`_config.yml`设置`pygments: true`来开启pygments。在md文件中如果要让Jekyll准确使用pygments，就要使用Liquid标签`{% highlight lang %}`和`{% endhighlight %}`，其中`lang`换成高亮的语言名称，具体还要查找pygments网站。对于R语言来说就是：

```
{% highlight lang %}
any code ...
{% endhighlight %}
```

*注意*，这里一直说的是md文件，而不是Rmd文件，因此在写Rmd文件并转换时需要使用到输出钩子函数`render_jekyll`，也就是在运行`knit`之前先运行这个函数：

{% highlight r %}
render_jekyll()
knit(input, output)
{% endhighlight %}

这样得到的md文件中区块代码都是用Liquid标签包住的，就可以使用pygments进行高亮了，实际就是给代码各个部分加上带有class的`<span>`标签，可以去下载模板CSS来更换高亮效果，也可以直接修改`/css/syntax.css`文件。

此外，我发现一个小问题，就是我一直使用的默认的Jekyll网站模板，自己做过小的修改，但是在语法高亮时，Jekyll会将代码和结果分成两个代码块输出，但最后的HTML页面中没有空隙，其实每个代码区块都是用`<div class="highlight">`包围，因此给`margin`加点儿距离就好。

{% highlight css %}
.highlight {
  margin-bottom: 5px;
}
{% endhighlight %}


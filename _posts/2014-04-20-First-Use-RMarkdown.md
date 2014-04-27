---
layout: post
title: 开始使用R和RMarkdown
tags: [R, markdown, RStudio, knitr, 统计, 研究, 可重复研究]
---

在前面的“[第一篇博客][firstblog]”一文中已经提到：

> 本人还是一个R语言爱好者，以后的很多东西估计都离不开它。

所以，本文就稍微谈谈我对于R的使用。首先声明的是，我不是开发者，就是个应用者，也不会什么太深的编程，所以大牛们开发出来什么我就用什么。话说接触R也是6年前的事情了，因为之前接触的是SPSS和Eviews之类的东西，所以发现R就用命令行可是挺酷的，还记得教计量经济学的老师给大家介绍了一下各统计软件的适用范围，最后一句的意思就是，*前面提到的还没有解决的话就用R编程做吧*。这是第一印象！

### 使用R和Rmarkdown的基本套路

虽然接触R很早，但是不美的东西还是不能吸引人啊，而且以前要么是用[Notepad++][npp]加[插件][npptor]，要么就是用[Tinn-R][tinnr]，相比今天大家都在用的[RStudio][rstudio]，实在是有差距。其实RStudio也是一步步走来的，还记得一开始用的时候感觉眼前一亮，但是用着用着就发现问题很多。当然，今天的RStudio已经不可同日而语，不过我觉得软件本身的改进只是一个方面，更重要的是RStudio开始构建使用R的一个全新生态。它对于R、[Git][git]、[knitr][knitr]的整合是最大的优势，而现在又包含了[Shiny][shiny]和[RMarkdown][rmd]等牛逼的东西，今天就先来说说RMarkdown。

其实RMarkdown对于我来说也不算全新，因为已经开始使用knitr了，这个包的[作者][yihui]居然是自己同校同级的校友，很是佩服，比较欣赏他自称对于美的强迫症。

RMarkdown其实就是在Markdown当中加入R代码，然后用knit或render输出各种需要的格式，我大概看了下，对于嵌入的R代码区块的处理当然是使用knitr，而文档格式转换是用的[pandoc][pandoc]。这个包我不会用，但是感觉RStudio已经把它整合好了，没必要学了。

以用Jekyll和Github[写博客][tutor]为例，因为实际需要的只是一个可供Jekyll转化的md文件，因此正常写Rmd文件（RStudio的新建文件类型之一）就可以了，然后使用knit进行转换成为md文件即可，最后将md文件和图片等附属文件推送到Github即可。应该说，套路就这么简单，完全可以直接写博客，即可以写教程，也可以做研究，写可以写报告，很方便。但也有些小问题需要在使用之前处理好。

### 在Rmd文件中加入R区块来运行代码

首先要讨论的一个问题就是Rmd的YAML头信息。Rmd和md文件都是有YAML头信息的，其中Rmd的YAML头信息主要用于转换为HTML、PDF和Word等文档使用个，Rmarkdown网站上有详细探讨。而md文件尽管一般不需要YAML头信息，但是用于Jekyll网站就是必须的了，否则不能转换为HTML文件，一般像如下这个样子。

实际上，在使用knit函数的时候只针对R区块，因此这部分头信息可以被忽略，正常写就好了，不会影响到输出的md文件在Jekyll中被转换。

在Rmd中加入R区块非常简单，只需要加入`{r}`和并在中间写入代码就可以了，下面是一个最简单的例子。


{% highlight r %}
{% raw %}
```{r}
{% endraw %}
a <- 20
b <- 30
paste("The result is ", a * b, ".", sep = "")
{% raw %}
```
{% endraw %}
{% endhighlight %}



{% highlight text %}
## [1] "The result is 600."
{% endhighlight %}


其中的`{r}`表示下面的代码是R代码，此处最好标签（label），可以标识这段代码，例如`{r first-chunk}`，输出的图形可以以此命名，当然标签的作用还有很多。标签还可以通过`options$label`来访问。

### 在输出的md文件中保证使用pygments的highlight

在Jekyll中的语法高亮使用的是**pygments**，当然要在`_config.yml`设置`pygments: true`来开启pygments。在md文件中如果要让Jekyll准确使用pygments，就要使用[Liquid][liquid]标签`{% raw %}{% highlight lang %}{% endraw %}`和`{% raw %}{% endhighlight %}{% endraw %}`，其中`lang`换成高亮的语言名称，具体还要查找[pygments][pyg]网站。对于R语言来说就是：

{% highlight text %}
{% raw %}
{% highlight lang %}
any code ...
{% endhighlight %}
{% endraw %}
{% endhighlight %}

*注意*，这里一直说的是md文件，而不是Rmd文件，因此在写Rmd文件并转换时需要使用到输出钩子函数`render_jekyll`，也就是在运行`knit`之前先运行这个函数：

{% highlight r %}
render_jekyll()
knit(input, output)
{% endhighlight %}

这样得到的md文件中区块代码都是用Liquid标签包住的，就可以使用pygments进行高亮了，实际就是给代码各个部分加上带有class的`<span>`标签，可以去下载模板[CSS][sytle]来更换高亮效果，也可以直接修改`/css/syntax.css`文件。

此外，我发现一个小问题，就是我一直使用的默认的Jekyll网站模板，自己做过小的修改，但是在语法高亮时，Jekyll会将代码和结果分成两个代码块输出，但最后的HTML页面中没有空隙，其实每个代码区块都是用`<div class="highlight">`包围，因此给`margin`加点儿距离就好。

{% highlight css %}
.highlight {
  margin-bottom: 5px;
}
{% endhighlight %}

### 图形输出

图形输出应该是使用RMarkdown最重要的功能之一了，因为使用RMarkdown可能不是为了研究编程之类的，而是直接写一些报告，而图形作为一种输出，也就是说最终的页面呈现的是一幅或者多幅配图，但没有任何R代码，也就是说R只是作为页面的后台支持。

R包knitr已经提供了对于图形输出的很好的支持，有非常多的参数可以进行个性化修饰。这里谈谈我的应用，其实我们用R绘图并输出的目的是要加入一条Markdown标记插入一幅图，因此代码本身是不需要的，故设置`echo=FALSE`。

还有一个问题就是输出路径，输出路径包含两个问题：

- 图形的输出路径，也就是实际图形的存储位置，这个在运行`knit`函数将Rmd文件转为md文件时的路径有关，一般来说我们将图片同一存储在网站中专门的目录中，我是存储在根目录下`figure/`目录下。如果转为md文件时就在根目录下，那么参数`fig.path`就不用设置了，而如我是在根目录下专门建立了一个`_rmd/`目录来存放和写Rmd文件，因此要设置`fig.path='../figure/'`，这样就向后退一级目录再存在根目录下`figure/`目录中。

- Markdown插入图形的路径，也就是用`![]()`插入图形的路径，因为这个路径最终要转换为可以指向根目录下`figure/`目录中图片的位置。对于Github Pages来说，我是建立了一个jekyll分支存放Jekyll网页文件，因此图形网址一定是类似于`/jekyll/figure/plot.png`，但是貌似这个反斜杠无法通过参数`fig.path`来加入。

对于后一个问题，knitr包是预留了办法的，那就是让区块不输出任何内容，而用钩子函数（hook function）来插入markdown代码。对于不让区块显示结果可以设置`echo=FALSE, fig.show='hide',`，这样就不会显示任何内容，但图片仍然输出。至于钩子函数，可以根据[knitr][knitr]包网站的介绍来写一个：

{% highlight r %}
knit_hooks$set(addfile = function(before, options, envir) {
  if (!before) {    ## after a chunk has been evaluated
    name = paste('/jekyll/figure/', options$label, '.png', sep = '')
    return(paste('![plot](', name, ')', sep=''))
  }})
{% endhighlight %}

这里就是用到了`options$label`，因为输出的文件名也是用这个标签来命名的。下面就是一个例子，此处给出了代码，这个例子用quantmod包提取了高升公司的股价数据，并绘制K线图。

{% highlight r %}
```{r, echo=FALSE, fig.path='../figure/', fig.show='hide', addfile=TRUE}
chartSeries(GS, theme='white')
```
{% endhighlight %}

![plot](/jekyll/figure/2014-04-14-candlestick.png)

### 进一步学习knitr和语法高亮

本文所使用的knitr功能还不是很多，未来还有很多要探讨，但说回来还是要服务于需要，当需求比较稳定的时候，只要摸索出一套常用的设置就可以了，也没必要研究得太细，一些地方也可以hack一下，没必要搞得太清楚，目的就是自动化输出我们想要的结果就完事大吉。

此外，在研究的过程中，我发现语法高亮是个挺好玩的事情，有机会再深入研究下，就当纯娱乐吧。

[firstblog]: {% post_url 2014-04-07-First-Blog %}
[npp]: http://www.notepad-plus-plus.org/
[npptor]: http://sourceforge.net/projects/npptor/
[tinnr]: http://www.sciviews.org/Tinn-R/
[rstudio]: http://www.rstudio.com/
[shiny]: http://www.rstudio.com/shiny/
[rmd]: http://rmarkdown.rstudio.com/
[knitr]: http://yihui.name/knitr/
[yihui]: http://yihui.name
[liquid]: http://docs.shopify.com/themes/liquid-basics
[pyg]: http://pygments.org/
[style]: https://github.com/richleland/pygments-css
[git]: https://github.com
[pandoc]: http://johnmacfarlane.net/pandoc/
[tutor]: http://www.ruanyifeng.com/blog/2012/08/blogging_with_jekyll.html

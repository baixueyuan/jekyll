---
layout: post
title: R包：ReporteRs——由R输出Word和PowerPoint文档
---

R和微软的Office系列一直契合得还可以，这主要是指R与Excel之间的数据读取和文件格式转换等，其实这一点从最初的[`RODBC`][RODBC]包开始就具有这个功能；后来发展到[`xlsx`][xlsx]包和[`XLConnect`][XLConnect]。这些包与微软系列的**交流**主要是依靠[Apache POI][Apache POI]，这个项目的首页有一段*Mission Statement*，表述如下：

> The Apache POI Project's mission is to create and maintain Java APIs for manipulating various file formats based upon the Office Open XML standards (OOXML) and Microsoft's OLE 2 Compound Document format (OLE2). In short, you can read and write MS Excel files using Java. In addition, you can read and write MS Word and MS PowerPoint files using Java. 

众所周知的是，微软的Office系列文档格式不是开源的，不像[odt][odt]那样，因此据说只能通过*逆向工程*的方法来进行破解，这都不知道是多久前在哪里听说的，目前也应该是这样吧。所以，金山的WPS可以不断提高对MS Word文档的兼容性，但总会在一些方面有所欠缺，特别是复杂的文档；而iOS和Android上面众多优秀的办公软件也都对Office文档存在兼容性问题，直至微软推出自家的Office for iOS系列，这个兼容性终究让人满意了。

### ReporteRs基础

说了前面乱七八糟的，还是赶紧回归正题——那就是一直以来都没有一个针对Excel以外的Office文档的R包，也就是Word和PowerPoint。后来无意中发现了[R2DOCX][R2DOCX]包，非常喜欢，作者的Github项目[主页][r2docx]也是相当**漂亮**！真是怪自己看东西不细，津津有味儿地看着这个包的介绍，突然看到README的第一句话：*R2DOCX development activity has shifted to [ReporteRs][ReporteRs]*！原来作者已经升级了R2DOCX包，也就是今天所说的ReporteRs，也有一个很漂亮的项目[主页][reporters]，对这个包做了十分详细的介绍。

ReporteRs包得安装非常简单，首先要保证几个依赖包都已经安装：

{% highlight r %}
install.packages(c('rJava', 'base64', 'highlight', 'ggplot2')) # 依赖包
install.packages('devtools') # 用于从Github上面安装包
{% endhighlight %}

安装好上面几个包之后就可以从Github上安装ReporteRs包了：

{% highlight r %}
devtools::install_github('ReporteRsjars', 'davidgohel')
devtools::install_github('ReporteRs', 'davidgohel')
{% endhighlight %}

安装非常简单，但是有一个问题，这个不是在安装这个包的时候遇到的，而是安装R2DOCX的时候遇到。最开始安装在Mac OS X上面没有问题，但是安装在Windows 8中的时候就有了问题，当时我是在RStudio中启动了32位R进行安装的。现在已经解决所以没法贴错误信息了。我对于错误信息的理解就是说，在编译这个包的时候在编译x64部分的时候出了问题，`rJava`包无法正常加载，就是说卡在了编译x64部分这里。

其实，我在使用`xlsx`包的时候有过类似的经历，总之就是Java出了问题，因为`rJava`是依赖于机器上的Java[^1]工作的，所以保证Java正常就可以，但是经过验证我的Java没有问题。但是我发现了一个问题，那就是我的Java在`Program Files (x86)`目录下，也就是说我只安装了32位版本的Java。而恰恰错误信息显示的是在编译x64部分时出了问题，这就说明需要安装64位Java来解决问题，至此都是我的猜测。但经过试验直接通过，后面顺风顺水搞定了。所以，看来Windows上编译这个包必须同时安装32位和64位版本的Java，因为编译时是都会编译的，缺了哪一个都会出错。我平时主要用32位R，就是因为使用`xlsx`包有问题，现在才明白是因为没有安装64位的Java……

### ReporteRs的使用设想

关于这个包的使用方法，诸位可以直接去那个漂亮得项目[主页][reporters]去看，已经写得很清楚了。可以说看过之后感觉到这个包是个非常好的工具，尽管各位使用R、markdown、knit、pandoc、Jekyll的大牛肯定看不上Word之流，但实际工作当中那就是标准，除了少数专门从事计算机专业工作的人之外，大多数实际应用工作者必须天天处理Excel和Word以及PowerPoint。所以，ReporteRs包给了很多商业人士一个新的工作方式和思路。

通过了解的包得使用模式，我发现这个包有几个主要特点，主要以Word为例：

- 向doc对象添加文字是按照先后进行**顺序添加**的，非常符合写东西的习惯；
- 完全支持**样式**，可以简单通过样式设定标题和正文、列表等；
- 可以使用**模板**，与平时工作的模式十分相似，简化了重复性工作，也使得设定样式变得简单；
- 仍可在此基础上对个别**局部**进行修饰，不是灵活性。

这些特点就注定了ReporteRs包已经具有可用性和商业价值了，当然稳定性还需要经过考验。此外，前面没有提到一点就是对于表格的修饰能力很强，这就非常符合商业应用了。但是前面列出的几点是在说明这个包已经在将Word中标准化的运用模式与R结合了。

因此，初步[^2]设想可是按照如下的模式来使用ReporteRs包：

1. 将Word写作工作由Word转移至用Markdown[^3]来写；
2. 可以对写好的md文件进行读取，用`scan`函数即可，然后按照md的标记进行判断每段文字的内容属性；
3. 根据每段文字的属性来使用`addParagraph`进行逐段添加至`doc`对象；
4. 对于有必要的部分进行修饰，如果是小部分且不常用的话，蛮可以输出后直接修改；
5. 根据需要设定好自己工作对应的模板，以后即可重复使用。

关于逐段添加这一环节，可以大致按照下面的思路来做：

{% highlight r linenos %}
df <- data.frame(text=text, style='normal', stringsAsFactors)
df$style <- myfunc(df$text)
for (i in 1:nrow(df)) {
   doc <- addParagraph(doc, value=df$text[i], stylename=df$style[i])
} 
{% endhighlight %}

其实上面的办法着实不是什么太聪明的办法，但感觉应该很好懂，那就是构建一个数据框`df`，主要包含两列，一列`text`就是从md文件中读取出来的文字内容，每个元素就是一段的内容；另一列`style`就是这一段对应的样式。第2行使用了一个函数`myfunc`用来将md内容识别并转为样式，例如默认是**正文**或者**Normal**，而如果有`#`就是**标题1**或者**title1**，以此类推，当然可以个性化。接下来的循环就是将每一段逐段进行添加，而是用的样式就是后面的`df$style[i]`，这样基本就是我们想要的结果了。从使用来看，速度很快，这个循环不太花时间的。

### 进一步拓展

前面的想法其实主要集中在了把手头的工作自动化，其实还可以跟进一步，为所在的公司或者部分服务。例如，部门会有一些常用的模式化的报告，就可以用ReporteRs来完成，当然其中的部分内容是需要更新的，这一个环节可以通过数据库来管理。同时，为了能够供更多人使用，可以建立一个App，比如这些都是R的应用，就可以使用Shiny。这样就会形成一个自动的报告输出App，使用者经过简单地设置和选项后就可以输出一份Word格式报告。

目前来看，这个想法的难点在于生成报告的设置和选项，但是这个环节也会因为报告的规模和变量多少而产生难易差别，还得一事一议。

[^1]: `ReporteRs`明确要求系统中的Java版本要不低于*1.6.0*。
[^2]: 写此文时，我刚研究这个包1个小时，研究R2DOCX也不过一天；需要补充说明，ReporteRs中很多东西都是R2DOCX中的，因此花在R2DOCX上得时间不算浪费。
[^3]: 使用Markdown的好处很多，简而言之可以转为其他各种，例如使用RStudio、pandoc等等，而且简单使用。

[RODBC]: http://cran.r-project.org/web/packages/RODBC/index.html 
[xlsx]: http://cran.r-project.org/web/packages/xlsx/index.html
[XLConnect]: https://github.com/miraisolutions/xlconnect
[Apache POI]: http://poi.apache.org
[odt]: http://en.wikipedia.org/wiki/OpenDocument
[R2DOCX]: https://github.com/davidgohel/R2DOCX
[r2docx]: http://davidgohel.github.io/R2DOCX/index.html
[ReporteRs]: https://github.com/davidgohel/ReporteRs
[reporters]: http://davidgohel.github.io/ReporteRs/index.html

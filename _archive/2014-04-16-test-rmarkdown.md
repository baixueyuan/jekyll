---
layout: post
title: Test R Markdown
tags: [english, R, markdown, RStudio]
---


{% highlight r %}
library(Quandl)
Quandl.auth(key)
unrate <- Quandl("FRED/UNRATE", type = "xts", start_date = "2007-01-01")
{% endhighlight %}


This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see:

http://rmarkdown.rstudio.com

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:


{% highlight r %}
summary(cars)
{% endhighlight %}
<br />
{% highlight r %}
     speed           dist    
 Min.   : 4.0   Min.   :  2  
 1st Qu.:12.0   1st Qu.: 26  
 Median :15.0   Median : 36  
 Mean   :15.4   Mean   : 43  
 3rd Qu.:19.0   3rd Qu.: 56  
 Max.   :25.0   Max.   :120  
{% endhighlight %}

You can also embed plots, for example:

![plot of chunk cars](/jekyll/figure/cars.png) 


Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.



The following graph uses Quandl fetching data from the Web (specifically from [FRED][FRED]), and then plot the US unemployment from 2007 to present.

![plot of chunk unrate](/jekyll/figure/unrate.png) 


[FRED]: http://research.stlouisfed.org/fred2/


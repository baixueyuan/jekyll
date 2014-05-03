# 调整工作目录至Github目录，即现有的工作目录向上走两层
# Project默认工作目录应为“Dropbox/windows folders sync/Documents/GitHub/jekyll/_rmd”
# if (length(grep('_rmd$', getwd()))) setwd('..')
# if (length(grep('jekyll$', getwd()))) setwd('..')
# if (length(grep('GitHub$', getwd()))) cat('Reached GitHub Folder!')

# 将Rmd文件knit为md文件，需要输入的是Rmd文件名和日期date

# date <- '2014-04-29'

# inputdir <- 'jekyll/_rmd/'
# outputdir <- 'jekyll/_posts/'
# input <- paste(inputdir, inputfile, sep='')
# output <- paste(outputdir, date, '-', inputfile, sep='')
# output <- gsub('.Rmd', '.md', output)


# 目前使用以下代码knit ####
input <- '2014-04-29-ReporteRs-and-Chinese-docx.Rmd'
output <- paste('../_posts/', inputfile, sep='')
output <- gsub('.Rmd', '.md', output)

# knitting，首先运行render_jekyll以保证knit会使用jekyll的Liquid引擎
library(knitr)
render_jekyll()
knit(input, output, encoding = 'utf-8')

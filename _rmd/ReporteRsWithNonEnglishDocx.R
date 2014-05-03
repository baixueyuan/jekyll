# Small Hack ####
# For Installation and Usage Guide of ReporteRs, please visit
# the URL: https://github.com/davidgohel/ReporteRs
# 
# This Gist is only and small hack before ReporteRs can handle
# non-English style name in template docx file. Therefore, for
# the purpose of making docx template, we can use the following
# code to output an file containing all the available styles
# and every one of them is in a single paragraph of that style.

library(ReporteRs)
# "Arial" is available in Windows, however "Helvetica" is not.
options('ReporteRs-default-font'='Arial')
# List all styles detected by function "styles()".
doc <- docx.file(template='template.docx')
sty_list <- styles(doc) # As style names are in non-English,
# you will see weird style names here.
# Create a char vector containing text indicate "style name."
par_list <- paste("The style name of this para is", sty_list)
# Loop to add "par_list" element one by one, with the relative
# style name.
for (i in 1:length(sty_list)) {
  doc <- addParagraph(doc, value=par_list[i],
                      stylename=sty_list[i])
}
# Write to the "output.docx" and open it to check paragraphs
# in every styles and what is the name detected by ReporteRs.
writeDoc(doc, file='output.docx')

# You can use this "output.docx" as reference for building
# your template when working with ReporteRs. However, when
# ReporteRs has solution for this issue, the code is useless.
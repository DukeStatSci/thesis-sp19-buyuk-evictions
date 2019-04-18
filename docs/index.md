---
author: 'Ekim Buyuk'
date: 'May 2019'
institution: 'Duke University'
division: 'Trinity College of Arts and Sciences'
advisor: 'Colin Rundel'
altadvisor: 'Christopher Timmins'

committeememberone: 'Jim CLarke'
committeemembertwo: 'Amy Herring'
dus: 'Amy Herring'
department: 'Department of Statistical Science'
degree: 'Bachelor of Science in Statistical Science'
title: 'Landlords and Evictions: Changes in the Ownership of Multi-Family Rental Properties and Its Impact on Housing Stability in Durham, NC'
knit: "bookdown::render_book"
site: bookdown::bookdown_site
#output: 
#  thesisdown::thesis_gitbook: default
abstract: |
  
# If you'd rather include the preliminary content in files instead of inline
# like below, use a command like that for the abstract above.  Note that a tab is 
# needed on the line after the |.
bibliography: bib/thesis.bib
# Refer to your specific bibliography file in the line above.
csl: csl/apa.csl
# Download your specific csl file and refer to it in the line above.
lot: true
lof: true
space_between_paragraphs: true
#header-includes:
#- \usepackage{tikz}
---

<!--
Above is the YAML (YAML Ain't Markup Language) header that includes a lot of metadata used to produce the document.  Be careful with spacing in this header!

If you'd prefer to not include a Dedication, for example, simply delete lines 17 and 18 above or add a # before them to comment them out.  If you have other LaTeX packages you would like to include, delete the # before header-includes and list the packages after hyphens on new lines.

If you'd like to include a comment that won't be produced in your resulting file enclose it in a block like this.
-->

<!--
If you receive a duplicate label error after knitting, make sure to delete the index.Rmd file and then knit again.
-->



<!-- You'll need to include the order that you'd like Rmd files to appear in the _bookdown.yml file for
PDF files and also delete the # before rmd_files: there.  You'll want to not include 00(two-hyphens)prelim.Rmd
and 00-abstract.Rmd since they are handled in the YAML above differently for the PDF version.
-->

<!-- The {.unnumbered} option here means that the introduction will be "Chapter 0." You can also use {-} for no numbers
on chapters.
-->

## Acknowledgements {-}

I would like to begin by thanking my professors, Professor Christopher Timmins, Professor Colin Rundel and Professor Grace Kim. Thank you to Professor Timmins for your support and guidance at all hours of the day, and for constantly challenging me to think critically about the questions I was asking and the methodology I was using. It was a pleasure working with you this year, and I learned so much from you. Thank you to Professor Rundel for your wisdom and patience. I did not realize that pursuing research was not only an academic pursuit but also a huge emotional undertaking, and your insight and calming presence was so critical in this process. Thank you for listening to every idea I had with an open-mind, and walking with me through the detailed processes necessary to get answers to each of these curiosities. Thank you also to Professor Grace Kim for your feedback and your constant support of my winding research path, as well as of my career throughout Duke. 
Thank you to John Killeen at DataWorks. Without your trust in me to pursue this research question with the care it deserves, this research would not have been possible. Thank you for all of the brainstorming sessions and hours spent investigating imperfect data problems. I learned so much through your mentorship. 
Thank you to the Durham Sherriff’s Department and Durham Tax Administration for letting me work with this data in my thesis. Finally, thank you to all of the friends who have kept me sane as I panicked about this research project: Anna-Karin Hess, David Pfeiffer, and Juan Philippe, I could not have done this without your support! 


## Dedication {-}

I would like to dedicate my thesis to my dad, who enjoys doing research as a fun hobby and inspired me to think that I might be the same. Guess this is one of the few ways that we are different, dad!

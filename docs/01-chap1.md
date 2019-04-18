<!--
This is for including Chapter 1.  Notice that it's also good practice to name your chunk.  This will help you debug potential issues as you knit.  The chunk above is called intro and the one below is called chapter1.  Feel free to change the name of the Rmd file as you wish, but don't forget to change it here from chap1.Rmd.
-->

<!--
The {#rmd-basics} text after the chapter declaration will allow us to link throughout the document back to the beginning of Chapter 1.  These labels will automatically be generated (if not specified) by changing the spaces to hyphens and capital letters to lowercase.  Look for the reference to this label at the beginning of Chapter 2.
-->

# Introduction 

Over the past decade, Durham residents have been struggling with the forces of gentrification redesigning their neighborhoods and often leaving them out of the blueprint. Gentrification, defined in one economics paper as the “influx of wealthier residents accompanied by rising property prices and the displacement of existing, lower-income residents” is a phenomenon evident in multiple cities across the nation (definition from Raymond et. al, 2016). A Gentrification Report released by Governing examining the nation’s 50 largest cities in 2015 found that nearly 20 percent of neighborhoods with lower incomes and home values experienced gentrification since 2000 (Maciag, 2015). My thesis aims to explore one factor related to the displacement of tenants in Durham: the rate at which formal evictions are filed by corporate and individual landlords, as specified by The Rental Housing Finance Survey[^1].  

Formal evictions, or evictions processed through the court system, are not the only method by which a tenant may be displaced. The displacement process for a tenant can take many different forms but many of these moves are difficult to document and measure. A forced move is defined by the United Nations as “the permanent or temporary removal against their will of individuals… from the homes… which they occupy, without the provision of, and access to, appropriate forms of legal or other protection” (United Nations). Forced moves include cases such as landlords changing tenant’s locks or increasing rents, which force residents to relocate because they can no longer afford their apartments (Desmond, 2016, Who Gets Evicted?). These forced moves do not leave clear paper trails. Yet, they are still major reasons low-income tenants end up displaced from their communities. According to Desmond’s findings from the MARS Project, informal evictions were twice as common (48 percent) as formal evictions (24 percent) in forced moves (Flowers, 2018). By focusing on formal ejectment filings, my thesis will necessarily underestimate the magnitude of the displacements in Durham. The aim of this research is not to explore and measure the various causes of displacement, but rather to investigate the differences in the use of eviction filings to displace tenants amongst different types of owners in Durham’s multi-family rental market.  

The eviction crisis is an important epidemic, especially when we recognize the changing landscape of homeownership and renter-ship in the United States. Following the 2008 financial crisis, homeownership lost its role as a key element of the American Dream, replaced by a new demographic of renters. Homeownership rates declined from 68.4 percent in the first quarter of 2007 to 62.9 percent in the first quarter of 2016, which is the lowest they have been since homeownership rates started being reported back in 1965 (U.S. Census Bureau, “Homeownership Rate”). By the end of 2016, renters out-numbered homeowners in 22 more of the 100 largest cities in the United States, bringing the total number of renter-majority cities to 42 (Szekely, 2018). Since 2016, rates have steadily increased back to around 64.8 percent in the last quarter of 2018, but this is still much lower than pre-financial crisis levels (U.S. Census Bureau, “Homeownership Rate”).  

Not only has there been a dramatic change in the composition of communities across the United States, but there also appears to have been a change in the composition of who owns these properties. In the past decade, rental markets across dozens of cities, previously dominated by mom-and-pop landlords, have slowly been replaced by non-individual investors [^2] (Kolomatsky, 2017). Between 2001 and 2015, non-individual investors gained the majority share of rental units (52.2 percent) as a result of increased ownership of multi-unit properties (Kolomatsky, 2017). In fact, institutional investors have gained shares across all sizes of rental properties since 2001 (Kolomatsky, 2017). There are several real estate investment trusts (REITs) and private equity firms in the United States that currently operate portfolios consisting of tens of thousands of single-family properties, dispersed in different cities across the nation (Mills et. al, 2016). Recently, multi-family property rentals have also begun to pique the interest of large financial institutions and property managers such as Freddie Mac and Fannie Mae, though these properties remain largely ignored in research related to institutional investment in real-estate markets compared to single family residences.  

Furthermore, recent studies have begun to investigate the strategies employed by these “corporate” landlords and evaluate their impact on housing instability (Raymond et. al, 2016; Fields & Uffer, 2016; Immergluck, 2013; Herbert et. al, 2013; Mallach, 2013; Ford et. al, 2013). However, there is no research currently focused on understanding the relationship between the owners of multi-family units and their eviction filing rates. This seems like a natural relationship to investigate, particularly in cities with high rates of evictions. One community that stands at the intersection of high investment and high eviction rates is Durham County, North Carolina.

This paper proceeds as follows. I begin with an overview of the background of Durham and explain why it serves as a good case study for exploring my research questions. Next, I present the relevant literature on rental ownership and housing stability in the United States and give historical context to provide motivation for why the topic is so pressing. Following the Literary Review, I provide an in-depth discussion of my data preparation and manipulation process, including an overview of my rigorous hand-coding system to identify different types of owners. As part of my data section, I look at the changes in ownership of Durham’s multi-family rental properties between 2000 and 2018. Specifically, I look at the differences in ownership trends amongst corporates and individuals, as well as ownership trends between out-of-state and in-state corporates.  

Next, I provide a theoretical framework from which to think about this problem and present the empirical specifications of my fixed effects model. I apply this framework on various landlord characteristics, including landlord type (whether the landlord is a corporate or individual), landlord location (whether the landlord’s headquarters are based), and landlord size (whether the landlord owns more than 15 multi-family properties in Durham). I present my results along with numerous sensitivity analyses in my Results section. Finally, I discuss the implications of my findings, including potential ideas for further research, and conclude.  

This paper makes several contributions to the empirical literature on rental property ownership and eviction rates. First, it presents one of the only attempts to directly link rental property ownership to eviction rates [^3]. It is the first paper that specifically focuses on uncovering the changes in the multi-family rental market at such a detailed level. Specifically, I document the changes in ownership between corporates and individuals as well as between out-of-state and in-state corporate investors of Durham’s multi-family rental market between 2000 and 2018. Second, using a fixed effects model, I explore the differences in the likelihood of an eviction filing based on different landlord characteristics. Finally, I find evidence to suggest that the likelihood of a specific type of landlord evicting a tenant differs across property sizes. Therefore, I suggest that multi-family dwellings should not be lumped together when conducting analysis, but rather, different property size groups should be uniquely analyzed.
	
[^1]: The Rental Housing Finance Survey divides all landlords into two groups: individual landlords and non-individual landlords. Non-individual landlords are considered to be the following: trustee for estate, LLP, LP, or LLC, tenant in common, general partnership, REIT, real estate corporation, housing cooperative, non-profit organization and other. I give my own definition of what “corporate” ownership entails using the Rental Housing Finance Survey’s classifications as my guide. I will discuss this encoding in detail in the Data section. 
[^2]: This includes all landlords other than individuals as defined by the Rental Housing Finance Survey.
[^3]: The only paper that attempts to establish a quantifiable relationship between eviction rates and corporate ownership is a paper by Raymond et. al called "Corporate Landlords, Institutional Investors, and Displacement: Eviction Rates in Single family Rentals." The authors limit their investigation to the single-family rental market. My thesis, unlike the paper mentioned, focuses exclusively on the multi-family rental market. 

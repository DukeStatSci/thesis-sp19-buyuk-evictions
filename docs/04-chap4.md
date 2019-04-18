# Empirical Specifications 

I am interested in the changes in the likelihood of an eviction filing based on a change in ownership at a parcel, so I use a regression discontinuity to model this problem. Specifically, I am interested in whether the eviction rates in the post-transaction period are significantly different than rates in the pre-transaction period for various types of ownership changes. I consider the transaction to occur at time, t = 0, eviction rates in the pre-period to occur at time, t < 0 and eviction rates in the post-period to occur at time, t > 0.  

I subset my data to only contain transactions between the owner types that I am comparing. For example, if I am comparing the eviction rates of corporates and individuals, I subset my data so that it only contains transactions between corporates and corporates, individuals and individuals and corporates and individuals. Furthermore, I look at transaction windows between 1 and 12 months to test the robustness of my results. For example, a transaction window of 6 months implies that I am considering eviction rates 6 months before and 6 months after the transaction date. I choose 12 months as my upper bound because I want to specifically examine the impacts of the ownership change, and since leases of tenants usually last a year, I would expect that if an owner was going to evict the tenant, they would evict them at most within a given year. Otherwise, the owner could simply not renew the tenant’s lease.  

I model eviction rates in parcels using a binomial distribution. Specifically, I consider the probability of an eviction occurring at a single dwelling unit in a single month to be a Bernoulli Trial where an eviction can either occur or not occur. Since I do not have information at the dwelling unit level but rather at the parcel level, I aggregate up to the property level using the number of units in the property. The eviction rate at the parcel-level, therefore, can be modeled by a binomial distribution:

$$ P_{p}(x | N)  =  {N\choose k} \cdot p^x(1-p)^{N-x}$$

Specifically, “x” represents the total number of evictions that occur in a given month in a parcel with “N” dwelling units, where the probability of an eviction is given by probability “p”.  

Here, I assume that in a given month, there can only be one eviction in a dwelling unit and that an eviction in one dwelling unit is independent of an eviction in any other dwelling unit in that property. This independence assumption is not completely satisfied. For example, consider a small multi-family rental, such as a duplex. The owner of the duplex could be influenced in his/her decision to evict a tenant if he/she has just evicted another tenant, especially if the owner’s livelihood depends on the rental income from the two properties. Furthermore, an eviction in a given dwelling could technically occur more than one time in a given month, though this is incredibly unlikely and never the case in my data. It is sensible to assume this would never occur.  

My final model includes the categorical variables of “Ownership Type” and “Period,” which are factor variables that are either a 1 or 0. The ownership type specifies the ownership characteristic I am comparing (i.e. corporate owner = 1 and individual owner = 0). The period specifies whether that owner was owning the property in the pre or post transaction period (i.e. post = 1, pre = 0).  

I also include a fixed effect on “Year” in my model. As shown in my data section, the year is intimately connected to the eviction rate, and therefore, I must control for it. Similarly, the percentage of residents that are African American in a tract is also highly correlated with the given eviction rate, and I want to control for the influence of race. I look to see which tract the parcel falls in and I assign the parcel the percentage of African American residents that live in the tract. Applying the same framework, I also include average household income for the tract the parcel falls in, since this also has a slightly negative correlation with the eviction rate in a given tract. I consider these predictors to be numeric variables. I present my final model below: 

$$ Y_{i} = Binom(P_{i},N_{p(i)}) \\ logit (P_{i}) = B_{0}+ B_{1}I(Owner = Type 1)  + B_{2}I(Period = Post) + \\ B_{3}I(Owner = Type 1) *I(Period = Post) + \\ 
B_{4}(Percent African American In Tract) + B_{5}(Mean Household Income in Tract) + \\
\sum_{y=2004}^{y=2018} B_{y}I(year = y)$$

where i = transaction and Type 1 = one of two levels of ownership characteristic compared.


Today, I revisited the fundamentals of linear regression using the iris dataset. I started by loading the data and exploring the relationships between the numeric features. 

data(iris)
pairs(iris[, 1:4])

*Which features seem to have a linear relationship with each other?*
--> see linear realtionship between petal width and length. 

*How well do these models explain the variance in Sepal.Length?*

# Fit linear regression
model <- lm(Petal.Length ~ Petal.Width, data = iris)
summary(model)
--> Multiple R-squared: This is the proportion of the variance in the response variable (Petal.Length) explained by the model. In this case, approximately 92.71% of the variability in Petal.Length is explained by Petal.Width.

I then use the fitted logistic model of week 1: 

# Assess model fit
print(log_model$aic)

*How do AIC (Akaike Information Criterion) and null deviance help us evaluate model fit?*
Balances goodness of fit and model complexity. 
Lower AIC indicates a better balance between fit and simplicity.

*What is the Relationship with R^2?*
Null deviance is basically the deviance of the Model that consists of only the constant. For the R sqaured we use the deviance of our model
and the Null deviance to calcultate R^2. 

\[ R^2 = 1 - \frac{{\text{{Sum of Squared Residuals}}}}{{\text{{Total Sum of Squares}}}} \]




}

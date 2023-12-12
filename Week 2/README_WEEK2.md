{\rtf1\ansi\ansicpg1252\cocoartf2758
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww30040\viewh18340\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 Week 2

Today, I revisited the fundamentals of linear regression using the iris dataset. I started by loading the data and exploring the relationships between the numeric features. 

data(iris)
pairs(iris[, 1:4])

Which features seem to have a linear relationship with each other?
--> see linear realtionship between petal width and length. 

How well do these models explain the variance in Sepal.Length?
# Fit linear regression
model <- lm(Petal.Length ~ Petal.Width, data = iris)
summary(model)
--> Multiple R-squared: This is the proportion of the variance in the response variable (Petal.Length) explained by the model. In this case, approximately 92.71% of the variability in Petal.Length is explained by Petal.Width.

I then use the fitted logistic model of week 1: 

# Assess model fit
print(log_model$aic)

How do AIC and null deviance help us evaluate model fit?
Balances goodness of fit and model complexity.Lower AIC indicates a better balance between fit and simplicity.

}

{\rtf1\ansi\ansicpg1252\cocoartf2758
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww30040\viewh18340\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 Week 1\

Question: What happens if we increase or decrease the number of bootstrap samples (B)?
For this I use the Iris Dataset to see how the coefficients of a logistic regression change depending on the size of the 
Bootstrapped samples. 


library(MASS)


data(iris)
iris$binary_response <- as.factor(ifelse(iris$Species == "setosa", 1, 0))

B_values <- c(5, 10, 100, 500, 1000)
results <- matrix(NA, nrow = length(B_values), ncol = 5)

# Bootstrap sampling and logistic regression
for (i in seq_along(B_values)) {
	betas <- c()
	for (b in 1:B_values[i]) {
		samp_b <- sample.int(nrow(iris), replace=TRUE)
		reg_b <- glm(binary_response ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, data=iris[samp_b,], family="binomial")
		betas <- rbind(betas, coef(reg_b))
	}
	results[i, ] <- head(apply(betas, 2, mean), n = 5)
}

colnames(results) <- c("Intercept", "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
rownames(results) <- as.character(B_values)

print(results)

}


Conclusion: 
I see that the coefficients stabilize around 100 bootstrapped samples. I think that this is still a relatively small number, however the
Iris dataset is also known to be a clean dataset to work with, other sets might require larger sample sizes. 

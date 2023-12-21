
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

# Lasso Regression

*What do different lamdas in the lasso regression mean?*
Data here is an AirBNB dataset from Kaggle, split into training and test set, where I want to predict price. 


####Lasso
lasso_price <- glmnet(x_train, y_train, alpha=1, lambda = 10^seq(-2,6, length.out=50))
result.cv.lasso <- cv.glmnet(x_train
                             ,y_train
                             ,alpha = 1
                             ,lambda = 10^seq(0.01, 10, length.out = 100)
                             ,nfolds = 10,
                             type.measure = "mse"
)

result.cv.lasso$lambda.min
result.cv.lasso$lambda.1se


the parameter lamda controls the regularization strength, influencing the trade-off between fitting the model to training data and maintaining small coefficients. Higher λ: more coefficients are exactly zero, simplifying the model.
Lower λ: weaker penalty, retaining more coefficients and potentially overfitting the data.

We can see this in the performance of the model above: 

#Prediction on training set (insample)
predictions_lasso_min_training <- predict(lasso_price, newx = x_train, s = result.cv.lasso$lambda.min, type="response") 
predictions_lasso_1se_training <- predict(lasso_price, newx = x_train, s = result.cv.lasso$lambda.1se, type="response")

#prediction on test set
predictions_lasso_min <- predict(lasso_price, newx = x_test, s = result.cv.lasso$lambda.min, type="response") #Lasso
length(predictions_lasso_min)
predictions_lasso_1se<- predict(lasso_price, newx = x_test, s = result.cv.lasso$lambda.1se, type="response")

df_predictions <- data.frame(
  Actual_price = test_set$price.x, 
  Lasso_min = predictions_lasso_min,
  Lasso_1se = predictions_lasso_1se)
  #same for insample (training set)
df_predictions_insample <- data.frame(
  Actual_price = train_set$price.x,
  Lasso_min = predictions_lasso_min_training,
  Lasso_1se = predictions_lasso_1se_training)

mse_lasso_min <- mean((df_predictions$Actual_price - df_predictions$Lasso_min)^2)
mse_lasso_1se <- mean((df_predictions$Actual_price - df_predictions$Lasso_1se)^2)

--> In my case the min Lamda performs better (lower MSE), the more conservative lamda might underfit the data because it "pushes" the Variables faster towards zero. I can see in the predictions tht indeed the lamda1se is adding so much regularization strength, that the resulting model is predicing a constant. This is however as well because the models predictions are not very good in the first place. I get a lower MSE with the lamda min though, so the more complicated model ist still better than simply prediciting the mean. 
}

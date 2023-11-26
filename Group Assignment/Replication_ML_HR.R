main_data <- read.csv("/Users/marleenhaubitz/Documents/Erasmus University/DSMA/HR Analyitcs/Replication Assignment/2017765data/behaviors/python_index-construction/baseline_results/survey_response_data.csv")
dim(main_data)

na_counts <-as.data.frame(colSums(is.na(main_data)))

unique(main_data[, 1])

for (i in 2:ncol(main_data)-1) {
  unique_values <- unique(main_data[, i])
  column_name <- colnames(main_data)[i]
  
  cat("Column:", column_name, "\n")
  cat("Unique Values:", unique_values, "\n\n")
}

#We need to decide what to do with those: 
#Categorical Variables: n_functions, type, level1, F_duration, F_planned, F_participants




# READ IN DATA AND SELECT SAMPLE

ceo_data <- read.csv("/Users/marleenhaubitz/Documents/Erasmus University/DSMA/HR Analyitcs/Replication Assignment/2017765data/behaviors/python_index-construction/baseline_results/survey_response_data.csv", header = TRUE)
ceo_data <- ceo_data[ceo_data$level1 == 'interacting', ] 
ceo_data <- ceo_data[ceo_data$type != 'personal_family', ]
as.data.frame(colSums(is.na(ceo_data)))

ceo_data <- ceo_data[ceo_data$id != 1115, ]  # Missing F_participants and function info 
#Note: for F_participants we have "missing" and "blank" maybe we need to convert to NA later

# CONSTRUCT DATASET WITH SIX FEATURES, EXPRESSED AS TIME SHARE DURING WEEK

df1 <- table(ceo_data$id, ceo_data$F_duration) #for every CEO how many sessions of a specific time 
df2 <- table(ceo_data$id[ceo_data$F_planned != 'missing'], ceo_data$F_planned[ceo_data$F_planned != 'missing']) #for CEO how many planned and unplanned slots
df3 <- table(ceo_data$id[ceo_data$F_participants != 'missing'], ceo_data$F_participants[ceo_data$F_participants != 'missing']) #how many meetings with a certain n of participants for every CEO

names(ceo_data)
ceo_data$ins_alone <- 0 #We create a new Varaible called ins_alone and assign 0 to it
ceo_data$ins_alone[ceo_data$ins == 1.0 & ceo_data$out == 0.0] <- 1 #ins_alone is only 1 if only insiders participate in the meeting

ceo_data$out_alone <- 0
ceo_data$out_alone[ceo_data$ins == 0.0 & ceo_data$out == 1.0] <- 1 #here 1 if only outsiders participate

ceo_data$ins_out <- 0
ceo_data$ins_out[ceo_data$ins == 1.0 & ceo_data$out == 1.0] <- 1 #1 if outsiders and insiders are there

ceo_data$coordinate <- 0
ceo_data$coordinate[ceo_data$n_functions > 1] <- 1 #1 if number of functions in 1 time period >1

ceo_data$activity_dummy <- 1 

df4 <- table(ceo_data$id, ceo_data$ins_alone) #insider only/ not insider only meetings aggregated by manager
df4a <- table(ceo_data$id, ceo_data$ins) #insiders/ no insiders aggregated by manager

df5 <- table(ceo_data$id, ceo_data$ins_out) #both insiders and outsiders/ not both by manager
df5a <- table(ceo_data$id, ceo_data$out) #outsiders are there/ no outsiders are there by manager

df6 <- table(ceo_data$id, ceo_data$coordinate) #more than 1 function/ vs not more than 1 by manager

df_production <- table(ceo_data$id, ceo_data$production) #

df_groupcom <- table(ceo_data$id, ceo_data$groupcom)
df_bunits <- table(ceo_data$id, ceo_data$bunits)
df_coo <- table(ceo_data$id, ceo_data$coo)
df_cao <- table(ceo_data$id, ceo_data$cao)

agg_data <- data.frame(id = df1[, 1])

agg_data$long <- df1[, '1hrplus']
agg_data$planned <- df2[, 'planned']
agg_data$large <- df3[, 'two_plus_ppl']
agg_data$out <- df5a[, 1]
agg_data$coordinate1 <- df_groupcom[, 1] + df_bunits[, 1] + df_coo[, 1] + df_cao[, 1]
agg_data$coordinate2 <- df6[, 1]

activities <- tapply(ceo_data$activity_dummy, ceo_data$id, sum)
agg_data_share <- agg_data / activities

# PRINCIPAL COMPONENTS DECOMPOSITION

cor_matrix <- cor(agg_data_share)
eig <- eigen(cor_matrix)
pca <- agg_data_share %*% eig$vectors[, order(-eig$values)[1:2]]  # Use first two components

# K-MEANS

kmeans_result <- kmeans(agg_data_share, centers = 2)
print('k-means centroids = ')
print(kmeans_result$centers)

# OUTPUT RESULTS TO FILE

ceo_type <- data.frame(id = agg_data$id)
ceo_type$pca1 <- pca[, 2]
ceo_type$pca2 <- pca[, 1]
ceo_type$k_means <- kmeans_result$cluster

write.csv(ceo_type, file = 'clusters.csv', row.names = FALSE)

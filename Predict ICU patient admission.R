# Predicting ICU patient admission

#install.packages("caret")
#install.packages("pscl")
#install.packages("Hmisc")
#install.packages("prodlim")

library(readxl)
library("caret") #helps us to split our data into training and testing sets
library(pscl) #gets the pseudo R-square for logistic regression
library(Hmisc) #used to find the correlation and its p-values

### Step 1: Import & summarize the data ####
hospital_df <- read_excel(file.choose())
head(hospital_df)
summary(hospital_df)

### Step 2: Data visualization ####
# Visualizing the target variable
counts <- table(hospital_df$ICU_Admit)
barplot(counts)

### Step 3: Feature engineering: Data pre-processing ####
colSums(is.na(hospital_df)) #counting the number of missing values
hosp_df <- na.omit(hospital_df) #omit all the rows with missing values
summary(hosp_df)

hosp_df$Sex <- ifelse(hosp_df$Sex == 'Male', 1, 0) 
head(hosp_df) #Outputs a snapshot of our new columns

### Step 4: Feature selection - selecting the contributing variables to our model ####
corr <- rcorr(as.matrix(hosp_df))
corr #Outputs the correlation results

# Drop all the columns with p-value > 0.05
hosp_df2 <- subset(hosp_df, select = -c(SBP, HR, BMI, CHF, Cancer, 
                                        LowIncome, obese))
hosp_df2

### Step 5: Model building ####
# Splitting the data into training and testing sets
set.seed(3456)
trainIndex <- createDataPartition(hosp_df2$ICU_Admit, p = 0.70, list = FALSE, times = 1)
Train <- hosp_df2[ trainIndex,]
Test  <- hosp_df2[-trainIndex,]

# First model with all the variables
model <- glm(ICU_Admit ~ ESI + Age + Sex + Temp + RR + Spo2 + qSOFA + MI + Stroke + DM + CKD + Asthma + HTN,
             data = Train, family = binomial)
summary(model)

# Results - Age, Sex, MI, Stroke, CKD, Asthma, and HTN are insignificant variables (p > 0.05).

# Remove insignificant variables and rebuild the model
model2 <- glm(ICU_Admit ~ ESI + Temp + RR + Spo2 + qSOFA + DM,
              data = Train, family = binomial)
summary(model2)

# Result Interpretation
# Respiratory rate (RR)
  # for every one unit change in patient RR, the log odds of ICU admission (versus non-admission) increases by 0.04.
# Diabetes Mellitus (DM)
  # a patient diagnosed with diabetes 1, versus no diabetes 0, changes the log odds of ICU admission by 0.95.

### Step 6: Evaluating model performance ####
#### McFadden's R-square (i.e., Pseudo R-square) ####
pR2(model2) #McFadden R-square = 0.27

# Predicting on the test data
fitted.results <- predict(model2, Test, type='response')

# We need to show the probability of patients getting admitted or not
probability <- data.frame(prob = as.data.frame(fitted.results), actual = Test$ICU_Admit)

# Creating a threshold for our probability values. Default threshold is 0.5
fitted.results <- ifelse(fitted.results > 0.5,1,0)

#### Accuracy as a performance measure ####
misClasificError <- mean(fitted.results != Test$ICU_Admit) #misclassification error
print(paste('Accuracy',1-misClasificError)) 

# count the number of admitted vs not admitted patients in the test data
counts1 <- table(Test$ICU_Admit)
counts1

# using confusion matrix
table(Test$ICU_Admit, fitted.results)

# Interpretation
# TN: 299 patients were correctly predicted as not admitted to the ICU (pred = 0, actual = 0)
# FP: 4 patients were incorrectly predicted as admitted to the ICU (pred = 1, actual = 0)
# FN: 31 patients were incorrectly predicted as not admitted to the ICU (pred = 0, actual = 1)
# TP: 11 patients were correctly predicted as admitted to the ICU (pred = 1, actual = 1)


##### R Shiny - App Development ####
# Load necessary packages
library(shiny)
library(readxl)

# Define UI for the application
ui <- fluidPage(
  titlePanel("ICU Admission Prediction"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("esi", "Emergency Severity Index", value = 2, min = 1, max = 3),
      numericInput("temp", "Temperature (°F)", value = 92, min = 90, max = 105),
      numericInput("rr", "Respiratory Rate (breaths/min)", value = 20, min = 10, max = 135),
      numericInput("spo2", "Percent Oxygen (SpO2 %)", value = 97, min = 0, max = 100),
      numericInput("qsofa", "qSOFA Score", value = 0, min = 0, max = 3),
      checkboxInput("dm", "Diabetes Mellitus", value = FALSE),
      actionButton("predict", "Predict ICU Admission")
    ),
    mainPanel(
      textOutput("result")
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Load the dataset
  hospital_df <- read_excel(file.choose())
  
  # Preprocess the data and build the model as in your script
  # ...
  model2 <- glm(ICU_Admit ~ ESI + Temp + RR + Spo2 + qSOFA + DM, data = hospital_df, family = binomial)
  
  # Reactively predict ICU Admission based on user inputs
  observeEvent(input$predict, {
    new_data <- data.frame(ESI = as.numeric(input$esi),
                           Temp = as.numeric(input$temp),
                           RR = as.numeric(input$rr),
                           Spo2 = as.numeric(input$spo2),
                           qSOFA = as.numeric(input$qsofa),
                           DM = as.integer(input$dm))
    pred <- predict(model2, new_data, type = "response")
    icu_admission_prob <- round(pred * 100, 2)
    output$result <- renderText(paste("Probability of ICU Admission:", icu_admission_prob, "%"))
  })
}

# Run the application
shinyApp(ui = ui, server = server)



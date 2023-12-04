# ICU-Patient-Admission-Prediction
During the early phase of the pandemic, hospital intensive care units (ICU) experienced a surge of critically ill COVID-19 patients. With limited resources, management wants us to identify clinical features associated with ICU admissions and accurately predict such admissions.

**A. Technical Problem Statement:**
1.	During the early phase of the pandemic, Henry Ford Hospital faced a critical challenge in managing the surge of COVID-19 patients requiring intensive care unit (ICU) admission.
2.	With limited ICU resources, there was an urgent need for a predictive model to effectively triage patients based on their likelihood of needing ICU care.
3.	The project aimed to develop a Logistic regression model using R programming to identify clinical features associated with ICU admissions and accurately predict such admissions.

**B. Summary of the Results:**
1.	The Logistic regression model identified key variables significantly predicting ICU admissions: Emergency Severity Index (ESI), temperature, respiratory rate (RR), percent oxygen, organ failure, and diabetes mellitus.
2.	The model revealed inverse relationships for temperature and ESI with ICU admissions (lower odds with increasing temperature or ESI) and a direct relationship for RR (higher odds with increasing RR).
3.	The model’s performance was comprehensively assessed, showing an accuracy rate of approximately 89.86% in predicting ICU admissions. This robust level of accuracy, alongside the McFadden R-square score of 0.27, underscores the model’s reliability. The model has been integrated into an R Shiny app to facilitate practical application, providing a user-friendly interface for real-time predictions in the hospital setting.

**C. Business Recommendations:**
1.	Hospital managers should integrate the R shiny app into the hospital’s emergency department workflow to assist frontline clinicians in real-time decision-making for patient triage.
2.	The model can aid in optimizing ICU resource allocation by predicting demand more accurately, thereby improving the management of limited healthcare resources during surges.
3.	Regular updates and re-evaluations of the model are recommended to ensure its continued accuracy and relevance, especially considering potential changes in patient demographics or disease characteristics.

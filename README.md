\# Bank Loan Approval Analysis (SQL)



\## 📌 Project Overview



This project analyzes bank loan application data to identify the key factors influencing loan approval and rejection decisions. The analysis focuses on creditworthiness, income levels, and loan exposure risk to uncover actionable business insights for lending institutions.



---



\## 🎯 Objective



\* Understand overall loan approval patterns

\* Identify high-risk applicant segments

\* Evaluate the impact of credit score, income, and loan size

\* Provide data-driven recommendations for risk management



---



\## 🛠 Tools \& Technologies



\* \*\*MySQL\*\* — data querying and analysis

\* \*\*SQL\*\* — aggregations, CASE logic, window functions

\* \*\*Excel\*\* — initial data inspection and validation



---



\## 📂 Dataset



\* Bank Loan Approval Dataset

\* ~4,269 loan application records

\* Key fields include income, loan amount, CIBIL score, assets, and loan status



---



\## 🔍 Key Analysis Performed



\* Approval vs rejection trend analysis

\* Income segmentation and approval behavior

\* Credit score risk segmentation

\* Loan size risk evaluation

\* High-value loan exposure ranking using window functions

\* Data quality checks (nulls, duplicates, validation)



---



\## 📊 Key Findings



\* Overall loan approval rate: \*\*62.22%\*\*

\* Applicants with \*\*CIBIL < 600\*\* show the highest rejection risk (~75%)

\* Income alone is not a strong approval driver

\* Medium-sized loans (₹5L–₹15L) carry moderate rejection risk

\* Highest loan exposure observed: \*\*₹39.5M\*\*



---



\## 💼 Business Impact



\* Credit score identified as the primary approval driver

\* Medium loan segment requires tighter risk review

\* High-value loans should be aligned with strong credit profiles

\* Automated risk flags recommended for low CIBIL applicants

\* Income should be used as a supporting—not primary—risk factor



---



\## 🚀 How to Run



1\. Import dataset from `/data`

2\. Execute SQL scripts from `/sql`

3\. Review outputs and insights



---



\## 📈 Future Enhancements



\* Build Power BI risk dashboard

\* Add predictive risk scoring model

\* Automate applicant risk classification



---



\*\*Author:\*\* Nikhil Pal




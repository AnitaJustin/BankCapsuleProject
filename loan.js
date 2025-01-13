function calculateLoan() {
    const loanType = document.getElementById("loanType").value;
    const salary = parseFloat(document.getElementById("salary").value);
    let maxLoan = 0;
    let interestRate = 0;
if(!salary || isNaN(salary) || salary <=0)
    {


        document.getElementById('result').innerHTML = "<p style='color: red;'> Error! Please enter a valid monthly salary value</p>";
    }

   else{
    if (loanType === "home") {
        interestRate = 8.35;
        if (salary < 30000) {
            maxLoan = 1200000;
        } else if (salary >= 30000 && salary < 60000) {
            maxLoan = 2500000;
        } else {
            maxLoan = 3500000;
        }
    } else if (loanType === "personal") {
        interestRate = 11.45;
        if (salary < 30000) {
            maxLoan = 1000000;
        } else if (salary >= 30000 && salary < 60000) {
            maxLoan = 2000000;
        } else {
            maxLoan = 3000000;
        }
    }

    document.getElementById("result").innerHTML =
        `<p>Loan Type: <strong>${loanType.charAt(0).toUpperCase() + loanType.slice(1)} Loan</strong></p>
        <p>Interest Rate: <strong>${interestRate}%</strong></p>
        <p>Maximum Loan Amount: <strong>₹${maxLoan.toLocaleString()}</strong></p>`;
}
   }
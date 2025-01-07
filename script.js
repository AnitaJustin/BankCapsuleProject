
document.addEventListener('DOMContentLoaded', function () {
   
    const registrationForm = document.getElementById('registrationForm');

    registrationForm.addEventListener('submit', function (event) {
        event.preventDefault();

        const fullName = document.getElementById('fullName').value;
        const email = document.getElementById('email').value;
        const phone = document.getElementById('phone').value;
        const dob = document.getElementById('dob').value;
        const accountType = document.getElementById('accountType').value;
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        //  phone number (10 digits)
        const phoneRegex = /^\d{10}$/;
        if (!phoneRegex.test(phone)) {
            alert("Phone number must be exactly 10 digits.");
            return;
        }

        //password and confirm password match
        if (password !== confirmPassword) {
            alert("Passwords do not match.");
            return;
        }

        // password strength 
        const passwordStrengthRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/; 
        if (!passwordStrengthRegex.test(password)) {
            alert("Password must be at least 8 characters long and contain both letters and numbers.");
            return;
        }

        console.log("Form submitted successfully!");
        console.log("User Registration Data:");
            console.log("Username: " + email);
            console.log("Name: " + fullName)
            console.log("Password: " + password); 
            console.log("Mobile Number: " + phone);
            console.log("Account type: " + accountType);
            console.log("Date of Birth: " + dob);
        alert("Registration successful! (Simulated)");

        registrationForm.reset();
    });
});
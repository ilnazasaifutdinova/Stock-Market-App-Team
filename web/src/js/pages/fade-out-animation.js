// js/fade-out-animation.js

document.addEventListener("DOMContentLoaded", () => {
    const tabButtons = document.querySelectorAll(".tab-button");
    const form = document.querySelector(".auth-form");

    tabButtons.forEach((button, index) => {
        button.addEventListener("click", () => {
            tabButtons.forEach(btn => btn.classList.remove("active"));
            button.classList.add("active");

            // Swap form fields if needed (for now just log action)
            form.innerHTML = index === 0
                ? `
                <input type="email" placeholder="Email" required>
                <input type="password" placeholder="Password" required>
                <button type="submit" class="btn-login">Login</button>
              `
                : `
                <input type="text" placeholder="Full Name" required>
                <input type="email" placeholder="Email" required>
                <input type="password" placeholder="Password" required>
                <input type="date" placeholder="Birthdate" required>
                <button type="submit" class="btn-login">Register</button>
              `;
        });
    });

    // Fade-out page transitions for nav links
    function enableFadeOutLink(selector) {
        const link = document.querySelector(selector);
        if (!link) return;
        link.addEventListener('click', function (e) {
            e.preventDefault();
            const url = this.getAttribute('href');
            document.body.classList.add('fade-out');
            setTimeout(() => { window.location.href = url; }, 500);
        });
    }

    enableFadeOutLink('#mystocks-btn');
    enableFadeOutLink('#news-btn');
    enableFadeOutLink('#proversion-btn');
});

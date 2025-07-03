document.addEventListener("DOMContentLoaded", () => {
    const fadeLinks = document.querySelectorAll(".fade-link");

    fadeLinks.forEach(link => {
        link.addEventListener("click", event => {
            event.preventDefault();
            const href = link.getAttribute("href");
            document.body.classList.add("fade-out");
            setTimeout(() => {
                window.location.href = href;
            }, 500);
        });
    });
});

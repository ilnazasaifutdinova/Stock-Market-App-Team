// js/pages/portfolio-color-change.js

document.addEventListener('DOMContentLoaded', () => {
    // Get the element that displays the portfolio percentage change
    const percentageChangeElement = document.getElementById('portfolio-percentage-change');

    // Ensure the element exists before trying to modify it
    if (percentageChangeElement) {
        // Get the text content, e.g., "+12%" or "-5.3%"
        const percentageText = percentageChangeElement.textContent;

        // Parse the percentage value. We remove the '%' and convert to a number.
        // The '+' sign is handled automatically by parseFloat as a positive number.
        // For "-5.3%", parseFloat will correctly return -5.3.
        const value = parseFloat(percentageText.replace('%', ''));

        // Check if the parsed value is a valid number
        if (!isNaN(value)) {
            // Apply the appropriate class based on the value
            if (value >= 0) {
                // If value is positive or zero, apply green color
                percentageChangeElement.classList.add('change-positive');
                percentageChangeElement.classList.remove('change-negative'); // Ensure old class is removed
            } else {
                // If value is negative, apply red color
                percentageChangeElement.classList.add('change-negative');
                percentageChangeElement.classList.remove('change-positive'); // Ensure old class is removed
            }
        } else {
            console.error('Could not parse percentage value for color change:', percentageText);
        }
    } else {
        console.warn('Element with ID "portfolio-percentage-change" not found.');
    }
});

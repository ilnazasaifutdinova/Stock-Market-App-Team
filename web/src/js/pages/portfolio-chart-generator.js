// js/pages/portfolio-chart-generator.js

document.addEventListener('DOMContentLoaded', function() {
    const barChartContainer = document.getElementById('portfolio-bar-chart');

    // Define your portfolio distribution data
    const portfolioData = [
        { category: 'Tech', percentage: 80 },
        { category: 'Finance', percentage: 60 },
        { category: 'Healthcare', percentage: 70 },
        { category: 'Energy', percentage: 40 },
        { category: 'Industrials', percentage: 55 }
    ];

    function generateBarChart(data, container) {
        if (!container) {
            console.error("Bar chart container not found."); // Look for this in console!
            return;
        }

        container.innerHTML = ''; // Clear any existing content

        data.forEach(item => {
            const barItem = document.createElement('div');
            barItem.classList.add('bar-item');

            const bar = document.createElement('div');
            bar.classList.add('bar');
            bar.style.height = `${item.percentage}%`; // This sets the height

            const categorySpan = document.createElement('span');
            categorySpan.classList.add('category');
            categorySpan.textContent = item.category;

            barItem.appendChild(bar);
            barItem.appendChild(categorySpan);
            container.appendChild(barItem);
        });
    }

    generateBarChart(portfolioData, barChartContainer);
});
import { loadHome } from './pages/home.js';
import { loadLogin } from './pages/login.js';
import { loadRegister } from './pages/register.js';
import { loadNews } from './pages/news.js';
import { loadDetail } from './pages/detail.js';
import { loadPortfolio } from './pages/portfolio.js';
import { loadBuyPro } from './pages/buyPro.js';

const routes = {
    '/': loadHome,
    '/login': loadLogin,
    '/register': loadRegister,
    '/news': loadNews,
    '/detail': loadDetail,       // detail.js будет читать symbol из queryString (например, ?symbol=AAPL)
    '/portfolio': loadPortfolio,
    '/buyPro': loadBuyPro
};

function router() {
    const path = window.location.pathname;
    const fn = routes[path] || loadNotFound;
    fn();
}

window.addEventListener('popstate', router);

document.addEventListener('DOMContentLoaded', () => {
    document.body.addEventListener('click', (evt) => {
        if (evt.target.matches('[data-link]')) {
            evt.preventDefault();
            history.pushState(null, null, evt.target.href);
            router();
        }
    });
    router();
});

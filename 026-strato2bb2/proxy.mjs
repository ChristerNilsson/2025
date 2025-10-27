import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';

const app = express();

app.use('/', createProxyMiddleware({
  target: 'https://storage.googleapis.com/bildbank2',
  changeOrigin: true,
  pathRewrite: (path, req) => {
    // Behåll querystring manuellt
    const url = new URL(req.url, 'http://local');
    if (url.pathname === '/') url.pathname = '/index.html';
    return url.pathname + url.search;  // inkl. ?query=Christer
  },
}));

app.listen(5500, () => {
  console.log('Proxy igång på http://127.0.0.1:5500');
});


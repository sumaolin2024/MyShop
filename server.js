const http = require("http");
const fs = require("fs");
const path = require("path");
const url = require("url");

const ROOT = path.resolve("D:\\MYSHOP\\MyShop_v2.3\\MyShop\\web");
const PORT = 8080;

const MIME = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "application/javascript",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".gif": "image/gif",
  ".svg": "image/svg+xml",
  ".ico": "image/x-icon",
  ".json": "application/json",
};

const server = http.createServer((req, res) => {
  try {
    const parsed = url.parse(req.url);
    let pathname = decodeURIComponent(parsed.pathname);
    if (pathname === "/") pathname = "/index.html";
    
    let filePath = path.join(ROOT, pathname);
    filePath = path.resolve(filePath);
    
    if (!filePath.toLowerCase().startsWith(ROOT.toLowerCase())) {
      res.writeHead(403);
      res.end("Forbidden");
      return;
    }

    const ext = path.extname(filePath).toLowerCase();
    const mime = MIME[ext] || "application/octet-stream";
    
    fs.stat(filePath, (err, stats) => {
      if (err || !stats.isFile()) {
        res.writeHead(404);
        res.end("Not Found");
        return;
      }
      res.writeHead(200, { "Content-Type": mime });
      fs.createReadStream(filePath).pipe(res);
    });
  } catch (e) {
    res.writeHead(500);
    res.end("Server Error");
  }
});

server.listen(PORT, () => {
  console.log("MyShop running at http://localhost:" + PORT + "/");
});
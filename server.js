const http = require("http");
const fs = require("fs");
const path = require("path");
const url = require("url");
const crypto = require("crypto");

const ROOT = path.resolve("D:\\MYSHOP\\MyShop_v2.3\\MyShop\\web");
const DATA_DIR = path.resolve("D:\\MYSHOP\\MyShop_v2.3\\MyShop\\data");
const PORT = 8080;
if (!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR, { recursive: true });

function loadDB(name) {
  const f = path.join(DATA_DIR, name + ".json");
  if (!fs.existsSync(f)) return name === "goods" ? defaultGoods() : [];
  try { return JSON.parse(fs.readFileSync(f, "utf8")); } catch (e) { return name === "goods" ? defaultGoods() : []; }
}
function saveDB(name, data) { fs.writeFileSync(path.join(DATA_DIR, name + ".json"), JSON.stringify(data, null, 2), "utf8"); }
function defaultGoods() {
  const g = [
    { id: 1, name:"葡萄柚", price:10.00, picture:"static/image/goods/grapefruit.png", stock:10, sales:122, isNew:0, isHot:1, spec:"大果 300g" },
    { id: 2, name:"葡萄", price:10.00, picture:"static/image/goods/grape.png", stock:20, sales:115, isNew:0, isHot:1, spec:"一级果" },
    { id: 3, name:"西红柿", price:3.00, picture:"static/image/goods/tomatoes.png", stock:20, sales:102, isNew:0, isHot:0, spec:"5斤装" },
    { id: 4, name:"生菜", price:6.00, picture:"static/image/goods/lettuce.png", stock:20, sales:89, isNew:0, isHot:0, spec:"1斤装" },
    { id: 5, name:"菠菜", price:4.00, picture:"static/image/goods/spinach.png", stock:50, sales:76, isNew:0, isHot:0, spec:"1斤装" },
    { id: 6, name:"脐橙", price:8.00, picture:"static/image/goods/orange.png", stock:50, sales:160, isNew:0, isHot:1, spec:"1斤装" },
    { id: 7, name:"香菇", price:8.00, picture:"static/image/goods/mushroom.jpg", stock:500, sales:42, isNew:0, isHot:0, spec:"1斤装" },
    { id: 8, name:"进口香蕉", price:2.00, picture:"static/image/goods/banana.jpeg", stock:60, sales:55, isNew:1, isHot:0, spec:"2根" },
    { id: 9, name:"陕西蜜梨", price:6.90, picture:"static/image/goods/pear.jpeg", stock:30, sales:33, isNew:1, isHot:0, spec:"约600g" },
    { id: 10, name:"加力果", price:26.80, picture:"static/image/goods/apple.jpeg", stock:19, sales:39, isNew:1, isHot:1, spec:"3个" },
  ];
  saveDB("goods", g); return g;
}

function parseJSON(req, cb) { let b = ""; req.on("data", c => b += c); req.on("end", () => { try { cb(JSON.parse(b)); } catch (e) { cb(null); } }); }
function sendJSON(res, code, data) { res.writeHead(code, { "Content-Type": "application/json; charset=utf-8" }); res.end(JSON.stringify(data)); }
function getSessionUser(req) {
  const c = req.headers.cookie || "";
  const m = c.match(/sid=([^;]+)/);
  if (!m) return null;
  const ss = loadDB("sessions");
  const s = ss.find(x => x.token === m[1] && x.expires > Date.now());
  if (!s) return null;
  return (loadDB("users").find(u => u.id === s.userId)) || null;
}

const MIME = { ".html":"text/html; charset=utf-8", ".css":"text/css; charset=utf-8", ".js":"application/javascript", ".png":"image/png", ".jpg":"image/jpeg", ".jpeg":"image/jpeg", ".gif":"image/gif", ".svg":"image/svg+xml", ".ico":"image/x-icon", ".json":"application/json" };

const server = http.createServer((req, res) => {
  try {
    const parsed = url.parse(req.url, true);
    const pathname = decodeURIComponent(parsed.pathname);
    const method = req.method.toUpperCase();

    if (pathname === "/api/register" && method === "POST") {
      parseJSON(req, body => {
        if (!body || !body.username || !body.password) return sendJSON(res, 400, { ok: false, msg: "请输入用户名和密码" });
        const users = loadDB("users");
        if (users.find(u => u.username === body.username)) return sendJSON(res, 409, { ok: false, msg: "用户名已存在" });
        users.push({ id: users.length > 0 ? Math.max(...users.map(u => u.id)) + 1 : 1, username: body.username, password: body.password });
        saveDB("users", users);
        sendJSON(res, 200, { ok: true, msg: "注册成功" });
      });
      return;
    }

    if (pathname === "/api/login" && method === "POST") {
      parseJSON(req, body => {
        if (!body || !body.username || !body.password) return sendJSON(res, 400, { ok: false, msg: "请输入用户名和密码" });
        const users = loadDB("users");
        const user = users.find(u => u.username === body.username && u.password === body.password);
        if (!user) return sendJSON(res, 401, { ok: false, msg: "用户名或密码错误" });
        const token = crypto.randomBytes(16).toString("hex");
        const sessions = loadDB("sessions");
        sessions.push({ token, userId: user.id, expires: Date.now() + 86400000 });
        saveDB("sessions", sessions);
        // 去掉 HttpOnly，设置 SameSite=Lax
        res.writeHead(200, {
          "Content-Type": "application/json; charset=utf-8",
          "Set-Cookie": "sid=" + token + "; Path=/; Max-Age=86400; SameSite=Lax"
        });
        res.end(JSON.stringify({ ok: true, user: { id: user.id, username: user.username } }));
      });
      return;
    }

    if (pathname === "/api/user" && method === "GET") {
      const u = getSessionUser(req);
      return sendJSON(res, 200, u ? { ok: true, user: { id: u.id, username: u.username } } : { ok: false });
    }

    if (pathname === "/api/logout" && method === "POST") {
      res.writeHead(200, { "Content-Type": "application/json", "Set-Cookie": "sid=; Path=/; Max-Age=0" });
      return res.end(JSON.stringify({ ok: true }));
    }

    const cu = getSessionUser(req);

    if (pathname === "/api/cart" && method === "GET") {
      if (!cu) return sendJSON(res, 401, { ok: false, msg: "请先登录" });
      const cart = loadDB("cart").filter(c => c.userId === cu.id);
      const goods = loadDB("goods");
      const items = cart.map(c => {
        const g = goods.find(x => x.id === c.goodsId);
        const n = c.goodsName || (g ? g.name : "(已下架)");
        const p = c.goodsPrice || (g ? g.price : 0);
        const pic = c.goodsPicture || (g ? g.picture : "");
        return { ...c, goodsName: n, goodsPrice: p, goodsPicture: pic, subtotal: p * c.goodsNum };
      });
      const total = items.filter(i => i.checked === 1).reduce((s, i) => s + i.subtotal, 0);
      return sendJSON(res, 200, { ok: true, data: items, total: Math.round(total * 100) / 100, count: items.length });
    }

    if (pathname === "/api/cart/add" && method === "POST") {
      if (!cu) return sendJSON(res, 401, { ok: false, msg: "请先登录" });
      parseJSON(req, body => {
        if (!body || !body.goodsId) return sendJSON(res, 400, { ok: false, msg: "缺少商品ID" });
        const num = body.num || 1;
        const cart = loadDB("cart");
        const exist = cart.find(c => c.userId === cu.id && c.goodsId === body.goodsId);
        if (exist) { exist.goodsNum += num; saveDB("cart", cart); return sendJSON(res, 200, { ok: true, msg: "已更新数量" }); }
        const maxId = cart.length > 0 ? Math.max(...cart.map(c => c.id)) : 0;
        cart.push({ id: maxId + 1, userId: cu.id, goodsId: body.goodsId, goodsNum: num, checked: 1, createTime: new Date().toISOString(), goodsName: body.goodsName || "", goodsPrice: body.goodsPrice || 0, goodsPicture: body.goodsPicture || "" });
        saveDB("cart", cart);
        sendJSON(res, 200, { ok: true, msg: "已加入购物车" });
      });
      return;
    }

    if (pathname === "/api/cart/update" && method === "PUT") {
      if (!cu) return sendJSON(res, 401, { ok: false, msg: "请先登录" });
      parseJSON(req, body => {
        const cart = loadDB("cart");
        const item = cart.find(c => c.id === body.id && c.userId === cu.id);
        if (!item) return sendJSON(res, 404, { ok: false });
        item.goodsNum = Math.max(1, body.num || 1);
        saveDB("cart", cart);
        sendJSON(res, 200, { ok: true });
      });
      return;
    }

    if (pathname === "/api/cart/delete" && method === "DELETE") {
      if (!cu) return sendJSON(res, 401, { ok: false, msg: "请先登录" });
      parseJSON(req, body => {
        const cart = loadDB("cart");
        const idx = cart.findIndex(c => c.id === body.id && c.userId === cu.id);
        if (idx === -1) return sendJSON(res, 404, { ok: false });
        cart.splice(idx, 1);
        saveDB("cart", cart);
        sendJSON(res, 200, { ok: true });
      });
      return;
    }

    // 静态文件
    let fp = path.join(ROOT, pathname === "/" ? "/index.html" : pathname);
    fp = path.resolve(fp);
    if (!fp.toLowerCase().startsWith(ROOT.toLowerCase())) { res.writeHead(403); return res.end("Forbidden"); }
    fs.stat(fp, (err, stats) => {
      if (err || !stats.isFile()) { res.writeHead(404); return res.end("Not Found"); }
      res.writeHead(200, { "Content-Type": MIME[path.extname(fp).toLowerCase()] || "application/octet-stream" });
      fs.createReadStream(fp).pipe(res);
    });
  } catch (e) { res.writeHead(500); res.end("Server Error"); }
});

server.listen(PORT, () => console.log("MyShop at http://localhost:" + PORT));
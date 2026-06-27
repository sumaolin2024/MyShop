# 🛒 MyShop — Java Web 电商商城系统

一个功能完整的 B2C 电商平台，提供 Java Web（JSP + Servlet）和 Node.js 两种实现版本。

---

## 📸 项目截图

> 在 MyEclipse 或浏览器中运行后查看

---

## 🚀 技术栈

### Java 版本（主版本）
| 层级 | 技术 |
|---|---|
| 前端 | JSP、HTML5、CSS3、Vanilla JavaScript |
| 后端 | Servlet 3.1、JDK 1.8 |
| 数据库 | MySQL 5.7+、DBCP2 连接池 |
| 安全 | BCrypt 密码加密、XSS 过滤、登录鉴权 |
| 序列化 | FastJSON |
| 服务器 | Apache Tomcat 9 |

### Node.js 版本（v2.3）
| 层级 | 技术 |
|---|---|
| 后端 | Node.js 原生 HTTP 模块 |
| 数据存储 | JSON 文件（无需数据库） |
| 前端 | 纯 HTML/CSS/JS（与 Java 版共享页面） |

---

## 📁 项目结构

```
D:\MYSHOP\
├── src/com/myshop/
│   ├── controller/       # Servlet 控制器（6 个）
│   ├── service/          # 业务逻辑层（6 个）
│   ├── dao/              # 数据访问层（7 个）
│   ├── entity/           # 实体类（10 个）
│   ├── filter/           # 过滤器（编码/XSS/鉴权）
│   └── util/             # 工具类（DB/BCrypt/JSON/XSS/Page）
├── web/
│   ├── index.jsp         # 首页（轮播 + 分类 + 热销 + 新品）
│   ├── fashion.jsp       # 潮流服饰专题页
│   ├── sports.jsp        # 户外运动专题页
│   ├── mobile.jsp        # 手机数码专题页
│   ├── goods/            # 商品列表 & 详情
│   ├── cart/             # 购物车
│   ├── user/             # 登录 / 注册 / 个人中心
│   ├── admin/            # 后台管理
│   ├── includes/         # 公共头尾
│   ├── css/global.css    # 全局样式
│   ├── js/global.js      # 全局脚本
│   ├── static/           # 静态资源（图片/字体）
│   └── WEB-INF/
│       ├── web.xml       # 部署描述符
│       └── lib/          # 依赖 JAR 包
├── mysql/
│   └── myShop.sql        # 数据库建表 & 初始数据
├── MyShop_v2.3/          # Node.js 版本（独立运行）
├── .project / .classpath # MyEclipse 项目配置
└── server.js             # Node.js 启动脚本
```

---

## ⚡ 快速开始

### 方式一：Java 版（MyEclipse + Tomcat + MySQL）

**1. 导入项目**
- MyEclipse → `File` → `Import` → `Existing Projects into Workspace`
- 选择 `D:\MYSHOP` → `Finish`

**2. 配置数据库**
- 启动 MySQL 服务
- 执行 `mysql/myShop.sql` 建库建表
- 检查 `src/com/myshop/util/DBUtil.java` 中的数据库连接信息

**3. 配置 Tomcat**
- MyEclipse → Servers 视图 → 添加 Apache Tomcat 9.0
- 将 MyShop 项目部署到 Tomcat

**4. 运行**
- 启动 Tomcat → 浏览器访问 `http://localhost:8080/MyShop`

**默认账号**
| 角色 | 用户名 | 密码 |
|---|---|---|
| 管理员 | admin | 123456 |
| 普通用户 | demo1 | 123456 |

---

### 方式二：Node.js 版（零依赖，即开即用）

```bash
cd D:\MYSHOP
node server.js
```

浏览器访问 `http://localhost:8080`

> Node.js 版使用 JSON 文件存储，无需安装 MySQL。

---

## 🧩 功能模块

| 模块 | 功能 |
|---|---|
| 🏠 首页 | 轮播图、商品分类导航、热销推荐、新品上架 |
| 📂 商品分类 | 7 大分类（服饰/食品/珠宝/百货/数码/运动）、多级子分类 |
| 🔍 商品浏览 | 按分类筛选、商品列表、商品详情（轮播图 + 规格参数） |
| 🛒 购物车 | 添加商品、修改数量、勾选/全选、删除、价格汇总 |
| 👤 用户系统 | 注册、登录、个人中心 |
| 🔐 后台管理 | 管理员登录、后台仪表盘 |
| 🛡️ 安全防护 | XSS 过滤、编码统一、登录鉴权拦截 |

---

## 🗄️ 数据库表结构

| 表名 | 说明 |
|---|---|
| `shop_admin` | 管理员账号 |
| `shop_user` | 普通用户 |
| `shop_category` | 商品分类（树形结构） |
| `shop_goods` | 商品信息 |
| `shop_goods_album` | 商品轮播图 |
| `shop_car` | 购物车记录 |

---

## 🛠️ IDE 配置

本项目已内置 MyEclipse 配置文件：
- `.project` — 项目识别
- `.classpath` — 构建路径（JDK 1.8 + Tomcat 9）
- `.settings/` — 动态 Web 3.1 模块配置
- `.mymetadata` — MyEclipse 专有元数据

导入即用，无需额外配置。

---

## 📦 依赖 JAR（WEB-INF/lib）

- `commons-dbcp2-2.9.0.jar` — 数据库连接池
- `commons-pool2-2.11.1.jar` — 对象池
- `commons-logging-1.2.jar` — 日志
- `fastjson-1.2.2.jar` — JSON 序列化
- `mysql-connector-java-5.1.47.jar` — MySQL 驱动

---

## 📄 License

MIT — 仅供学习参考使用。

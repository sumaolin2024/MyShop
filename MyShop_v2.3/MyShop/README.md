# MyShop v2.0 一键部署指南

## 环境要求
- JDK 8+ (下载: https://adoptium.net/download/)
- Apache Tomcat 9 (下载: https://tomcat.apache.org/download-90.cgi)
- MySQL 8.0 (或 5.7+)

## 快速启动 (3 步)

### 1. 导入数据库
打开 MySQL，执行:
```
source D:/MYSHOP/mysql/myShop_v2.sql
```
或者先执行原始建表:
```
source D:/MYSHOP/mysql/myShop.sql
```

### 2. 配置数据库连接
编辑 web/WEB-INF/classes/com/myshop/util/DBUtil.class 对应的源文件:
src/com/myshop/util/DBUtil.java
修改第 14 行的数据库密码:
  ds.setPassword("你的MySQL密码");

然后重新编译:
  javac -encoding UTF-8 -cp "tomcat/lib/servlet-api.jar;web/WEB-INF/lib/*" -d web/WEB-INF/classes src/com/myshop/**/*.java

### 3. 启动
Windows: 双击 START_SERVER.bat
Mac/Linux: 将 web/ 文件夹复制到 Tomcat 的 webapps/ROOT/，启动 Tomcat

访问: http://localhost:8080/

## 项目结构
```
MyShop/
├── src/           # Java 源码 (Controller/Service/DAO/Entity/Filter/Util)
├── web/           # Web 应用根目录
│   ├── WEB-INF/   # 配置 + 编译后的 class + JAR 依赖
│   ├── css/       # 样式
│   ├── js/        # 脚本
│   ├── includes/  # 公共头部/页脚
│   ├── goods/     # 商品页面
│   ├── cart/      # 购物车
│   ├── user/      # 用户系统
│   └── admin/     # 后台管理
├── mysql/         # 数据库脚本
└── static/        # 图片资源
```

## 技术栈
JSP + Servlet + MySQL + DBCP2 + FastJSON
MVC 三层架构

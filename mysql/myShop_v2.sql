-- ============================================
-- MyShop v2.0 数据库升级脚本
-- 基于原 myShop.sql，新增字段和表
-- ============================================

USE myShop;

-- 1. 修改管理员表密码字段长度（适配 BCrypt 60字符）
ALTER TABLE shop_admin MODIFY COLUMN `password` VARCHAR(64) DEFAULT '' NOT NULL COMMENT '密码(BCrypt)';
ALTER TABLE shop_admin MODIFY COLUMN `salt` VARCHAR(64) DEFAULT '' NOT NULL COMMENT '密码盐';

-- 2. 修改用户表密码字段长度
ALTER TABLE shop_user MODIFY COLUMN `password` VARCHAR(64) DEFAULT '' NOT NULL COMMENT '密码(BCrypt)';
ALTER TABLE shop_user MODIFY COLUMN `salt` VARCHAR(64) DEFAULT '' NOT NULL COMMENT '密码盐';

-- 3. 商品表新增字段
ALTER TABLE shop_goods ADD COLUMN `sales` INT DEFAULT 0 NOT NULL COMMENT '销量' AFTER `stock`;
ALTER TABLE shop_goods ADD COLUMN `is_new` TINYINT(1) DEFAULT 0 NOT NULL COMMENT '新品标记' AFTER `sales`;
ALTER TABLE shop_goods ADD COLUMN `is_hot` TINYINT(1) DEFAULT 0 NOT NULL COMMENT '热销标记' AFTER `is_new`;

-- 设默认热销和新品
UPDATE shop_goods SET is_hot = 1 WHERE id IN (1, 2, 6, 10);
UPDATE shop_goods SET is_new = 1 WHERE id IN (8, 9, 10);
UPDATE shop_goods SET sales = id * 13 + 5;

-- 4. 购物车表新增字段
ALTER TABLE shop_car ADD COLUMN `user_id` INT UNSIGNED DEFAULT 0 NOT NULL COMMENT '用户id' AFTER `id`;
ALTER TABLE shop_car ADD COLUMN `checked` TINYINT(1) DEFAULT 1 NOT NULL COMMENT '勾选状态' AFTER `goods_num`;
ALTER TABLE shop_car ADD COLUMN `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT '加入时间' AFTER `checked`;

-- 5. 新建收藏表
DROP TABLE IF EXISTS shop_favorite;
CREATE TABLE shop_favorite (
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT '收藏id',
    `user_id` INT UNSIGNED NOT NULL COMMENT '用户id',
    `goods_id` INT UNSIGNED NOT NULL COMMENT '商品id',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT '收藏时间',
    UNIQUE KEY uk_user_goods (user_id, goods_id)
) ENGINE=InnoDB CHARSET=utf8mb4;

-- 6. 新建订单表
DROP TABLE IF EXISTS shop_order;
CREATE TABLE shop_order (
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT '订单id',
    `order_no` VARCHAR(32) NOT NULL COMMENT '订单号',
    `user_id` INT UNSIGNED NOT NULL COMMENT '用户id',
    `total_amount` DECIMAL(10,2) DEFAULT 0 NOT NULL COMMENT '订单总额',
    `status` TINYINT DEFAULT 0 NOT NULL COMMENT '状态: 0待付款 1已付款 2已发货 3已完成 4已取消',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT '创建时间',
    `pay_time` DATETIME DEFAULT NULL COMMENT '付款时间',
    UNIQUE KEY uk_order_no (order_no)
) ENGINE=InnoDB CHARSET=utf8mb4;

-- 7. 新建订单明细表
DROP TABLE IF EXISTS shop_order_item;
CREATE TABLE shop_order_item (
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT '明细id',
    `order_id` INT UNSIGNED NOT NULL COMMENT '订单id',
    `goods_id` INT UNSIGNED NOT NULL COMMENT '商品id',
    `goods_name` VARCHAR(255) DEFAULT '' NOT NULL COMMENT '商品名称',
    `goods_price` DECIMAL(10,2) DEFAULT 0 NOT NULL COMMENT '商品单价',
    `goods_num` INT DEFAULT 1 NOT NULL COMMENT '数量',
    `goods_picture` VARCHAR(255) DEFAULT '' NOT NULL COMMENT '商品图片'
) ENGINE=InnoDB CHARSET=utf8mb4;

-- 完成
SELECT 'MyShop v2.0 数据库升级完成!' AS result;

/*
 Navicat Premium Data Transfer

 Source Server         : MySQL
 Source Server Type    : MySQL
 Source Server Version : 80012
 Source Host           : localhost:3306
 Source Schema         : social_media

 Target Server Type    : MySQL
 Target Server Version : 80012
 File Encoding         : 65001

 Date: 26/12/2024 12:31:03
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for announcement
-- ----------------------------
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement`  (
  `announcement_id` int(11) NOT NULL AUTO_INCREMENT,
  `publisher_id` int(11) NOT NULL,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` int(11) NULL DEFAULT 0,
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`announcement_id`) USING BTREE,
  INDEX `fk_publisher`(`publisher_id`) USING BTREE,
  CONSTRAINT `fk_publisher` FOREIGN KEY (`publisher_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of announcement
-- ----------------------------
INSERT INTO `announcement` VALUES (2, 2, '欢迎来到者也！', '为什么叫者也？因为“知乎”—“者也”', 2, '2024-12-09 11:01:05');
INSERT INTO `announcement` VALUES (6, 2, '社区Q&A', 'Q:什么是字块？\r\nA:我认为一段字不算句也不成文，所以为字块。\r\n\r\nQ:什么是回字?\r\nA:有去有回才为礼，多回字、少评论。\r\n\r\nQ:什么是群书?\r\nA:很多字块聚在一个话题不就是本书吗？\r\n\r\nQ:为何不能修改发出的内容，只可删除？\r\nA:因为在现实中的行动不能撤回，所以行动需三思\r\n（管理员可以改，因为是管理员）', 1, '2024-12-09 16:09:28');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `post_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`comment_id`) USING BTREE,
  INDEX `post_id`(`post_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 80 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (17, '顶一下，祝早日完成课设', 14, 15, '2024-12-09 15:10:45');
INSERT INTO `comment` VALUES (16, '看起来是成功了', 14, 10, '2024-12-09 15:05:23');
INSERT INTO `comment` VALUES (15, '测试成功了吗？', 14, 8, '2024-12-09 15:00:00');
INSERT INTO `comment` VALUES (11, '有点爽，但是好想睡觉', 14, 2, '2024-12-09 11:10:56');
INSERT INTO `comment` VALUES (18, '熬夜伤身，注意休息', 11, 12, '2024-12-09 11:15:30');
INSERT INTO `comment` VALUES (19, '我也是，课设写到头秃', 11, 8, '2024-12-09 11:20:12');
INSERT INTO `comment` VALUES (20, '坚持就是胜利！', 11, 16, '2024-12-09 11:25:45');
INSERT INTO `comment` VALUES (21, '快去睡吧，养好精神明天继续', 11, 9, '2024-12-09 11:30:18');
INSERT INTO `comment` VALUES (22, '不要熬夜太晚哦', 11, 13, '2024-12-09 11:35:24');
INSERT INTO `comment` VALUES (23, '已经完成了吗？', 11, 20, '2024-12-09 11:40:56');
INSERT INTO `comment` VALUES (24, '羡慕，我还在写', 11, 7, '2024-12-09 11:45:33');
INSERT INTO `comment` VALUES (25, '分享一下经验呗', 11, 21, '2024-12-09 11:50:27');
INSERT INTO `comment` VALUES (26, '记得写注释啊', 11, 6, '2024-12-09 11:55:42');
INSERT INTO `comment` VALUES (27, '代码能分享一下吗', 11, 19, '2024-12-09 12:00:15');
INSERT INTO `comment` VALUES (28, '这个公式总结得很全面，谢谢分享！', 1, 9, '2024-12-08 10:30:00');
INSERT INTO `comment` VALUES (29, '建议加入一些例题', 1, 15, '2024-12-08 10:45:00');
INSERT INTO `comment` VALUES (30, '收藏了，期末复习有用', 1, 7, '2024-12-08 11:00:00');
INSERT INTO `comment` VALUES (31, '特征值求解技巧很实用', 2, 8, '2024-12-08 11:15:00');
INSERT INTO `comment` VALUES (32, '我也经常算错，这个方法试试', 2, 16, '2024-12-08 11:30:00');
INSERT INTO `comment` VALUES (33, '听力进步很大啊，羡慕', 3, 12, '2024-12-08 12:00:00');
INSERT INTO `comment` VALUES (34, '推荐几个好用的APP吧', 3, 20, '2024-12-08 12:15:00');
INSERT INTO `comment` VALUES (35, '打卡跟练中...', 3, 14, '2024-12-08 12:30:00');
INSERT INTO `comment` VALUES (36, '数据库设计分享一下吧', 4, 10, '2024-12-08 14:45:00');
INSERT INTO `comment` VALUES (37, '前端用Bootstrap吗？', 4, 17, '2024-12-08 15:00:00');
INSERT INTO `comment` VALUES (38, '加油，马上就完成了', 4, 21, '2024-12-08 15:15:00');
INSERT INTO `comment` VALUES (39, '新食堂确实不错', 6, 13, '2024-12-08 18:30:00');
INSERT INTO `comment` VALUES (40, '价格也很实惠', 6, 19, '2024-12-08 18:45:00');
INSERT INTO `comment` VALUES (41, '下次去尝尝', 6, 8, '2024-12-08 19:00:00');
INSERT INTO `comment` VALUES (42, '建议加强管理', 7, 15, '2024-12-08 19:30:00');
INSERT INTO `comment` VALUES (43, '占座太过分了', 7, 11, '2024-12-08 19:45:00');
INSERT INTO `comment` VALUES (44, '我们宿舍自习好了', 7, 20, '2024-12-08 20:00:00');
INSERT INTO `comment` VALUES (45, '计划很详细，学习了', 8, 14, '2024-12-08 21:00:00');
INSERT INTO `comment` VALUES (46, '一起加油！', 8, 16, '2024-12-08 21:15:00');
INSERT INTO `comment` VALUES (47, '考研人不易啊', 8, 9, '2024-12-08 21:30:00');
INSERT INTO `comment` VALUES (48, '爬虫教程非常实用', 10, 17, '2024-12-09 09:15:00');
INSERT INTO `comment` VALUES (49, '有反爬处理的经验吗', 10, 8, '2024-12-09 09:30:00');
INSERT INTO `comment` VALUES (50, '代码能分享一下吗', 10, 21, '2024-12-09 09:45:00');
INSERT INTO `comment` VALUES (51, '模板很规范，感谢分享', 12, 22, '2024-12-09 10:15:00');
INSERT INTO `comment` VALUES (52, '帮大忙了！', 12, 19, '2024-12-09 10:30:00');
INSERT INTO `comment` VALUES (53, '报名了！', 13, 8, '2024-12-09 10:30:00');
INSERT INTO `comment` VALUES (54, '什么时候开始比赛？', 13, 20, '2024-12-09 10:45:00');
INSERT INTO `comment` VALUES (55, '我们系也组队了', 13, 16, '2024-12-09 11:00:00');
INSERT INTO `comment` VALUES (77, '考完自己算卷面刚33分，管理铁挂了家人们QAQ', 16, 2, '2024-12-17 19:22:19');
INSERT INTO `comment` VALUES (58, '一起加油', 15, 11, '2024-12-09 11:00:00');
INSERT INTO `comment` VALUES (59, '合理安排时间就好', 15, 13, '2024-12-09 11:15:00');
INSERT INTO `comment` VALUES (60, '压力别太大，注意休息', 15, 16, '2024-12-09 11:30:00');
INSERT INTO `comment` VALUES (78, '谁让你不跟着我复习\r\n6', 16, 24, '2024-12-17 19:44:05');
INSERT INTO `comment` VALUES (62, '一起复习啊', 16, 15, '2024-12-09 11:30:00');
INSERT INTO `comment` VALUES (63, '这科太难了...', 16, 7, '2024-12-09 11:45:00');
INSERT INTO `comment` VALUES (64, '暖心的故事', 17, 12, '2024-12-09 11:15:00');
INSERT INTO `comment` VALUES (65, '食堂阿姨人都很好', 17, 20, '2024-12-09 11:30:00');
INSERT INTO `comment` VALUES (66, '传递正能量', 17, 13, '2024-12-09 11:45:00');

-- ----------------------------
-- Table structure for post
-- ----------------------------
DROP TABLE IF EXISTS `post`;
CREATE TABLE `post`  (
  `post_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `topic_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`post_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `topic_id`(`topic_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 73 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of post
-- ----------------------------
INSERT INTO `post` VALUES (14, '某张同学的Java课设', '某张同学的Java课设在和老师软磨硬泡之中来回周旋，终于在2024/12/9的11:10分完成了！\r\n可喜可贺可喜可贺', 2, '2024-12-09 11:10:35', 5);
INSERT INTO `post` VALUES (16, '有没有大佬带带管理学复变函数', 'rt', 2, '2024-12-09 11:12:27', 7);
INSERT INTO `post` VALUES (18, '高数积分求解思路', '遇到一道定积分题目，求大佬指点：∫(0→1) x²ln(1+x)dx', 9, '2024-12-08 10:15:00', 1);
INSERT INTO `post` VALUES (19, '线代特征值怎么求？', '求解特征值时总是算错，有什么好的方法吗？', 6, '2024-12-08 10:30:00', 2);
INSERT INTO `post` VALUES (20, '四级听力备考经验', '分享一下我的四级听力备考方法，希望对大家有帮助', 16, '2024-12-08 11:00:00', 3);
INSERT INTO `post` VALUES (21, '课设进度分享', '已经完成了数据库设计和基本框架，前端还在施工中...', 8, '2024-12-08 14:20:00', 5);
INSERT INTO `post` VALUES (22, '求一个漂亮的前端模板', 'Bootstrap真的好丑，有没有好看点的模板推荐？', 10, '2024-12-08 15:30:00', 5);
INSERT INTO `post` VALUES (23, '新食堂探店报告', '今天去新食堂吃了麻辣香锅，味道不错，价格实惠！', 12, '2024-12-08 18:00:00', 4);
INSERT INTO `post` VALUES (24, '图书馆占座现象严重', '最近期末了，图书馆占座现象越来越多，建议大家自觉一点', 13, '2024-12-08 19:15:00', 4);
INSERT INTO `post` VALUES (25, '考研数学复习计划', '距离考研还有半年，分享一下我的数学复习计划', 15, '2024-12-08 20:30:00', 9);
INSERT INTO `post` VALUES (26, '考研英语作文模板', '整理了一些高分英语作文模板，希望对大家有帮助', 14, '2024-12-08 21:45:00', 9);
INSERT INTO `post` VALUES (27, 'Python爬虫入门教程', '分享一下Python爬虫的基础知识和实战经验', 17, '2024-12-09 09:00:00', 10);
INSERT INTO `post` VALUES (28, 'Java多线程问题', '在使用多线程时遇到了死锁，求解决方案', 8, '2024-12-09 09:30:00', 10);
INSERT INTO `post` VALUES (29, '物理实验报告模板', '整理了一份物理实验报告模板，欢迎取用', 22, '2024-12-09 10:00:00', 11);
INSERT INTO `post` VALUES (30, '篮球赛报名', '计算机学院篮球赛开始报名了，欢迎大家参加！', 19, '2024-12-09 10:15:00', 12);
INSERT INTO `post` VALUES (31, '计算机专业电子书分享', '整理了一些计算机专业课程的电子书，需要的可以私信', 21, '2024-12-09 10:30:00', 14);
INSERT INTO `post` VALUES (32, '期末压力好大', '快期末了，感觉学不完了，好焦虑...', 11, '2024-12-09 10:45:00', 15);
INSERT INTO `post` VALUES (33, '复变函数重点整理', '整理了复变函数的考试重点，一起复习吧', 7, '2024-12-09 11:00:00', 7);
INSERT INTO `post` VALUES (34, '今天食堂阿姨表扬我了', '因为主动帮忙收拾餐盘，被食堂阿姨夸了，心情好好！', 20, '2024-12-09 11:05:00', 6);
INSERT INTO `post` VALUES (35, '求导公式总结', '整理了一份常用求导公式，包含隐函数和参数方程求导', 9, '2024-12-07 10:15:00', 1);
INSERT INTO `post` VALUES (36, '泰勒公式应用', '泰勒公式的实际应用例题解析，建议收藏', 15, '2024-12-07 11:20:00', 1);
INSERT INTO `post` VALUES (37, '高数期末重点', '根据往年试卷整理的期末考试重点，希望对大家有帮助', 7, '2024-12-07 14:30:00', 1);
INSERT INTO `post` VALUES (38, '矩阵乘法技巧', '分享一些矩阵乘法的快速计算方法', 8, '2024-12-07 15:40:00', 2);
INSERT INTO `post` VALUES (39, '二次型化标准型', '总结二次型化标准型的几种方法，包含例题', 9, '2024-12-07 16:50:00', 2);
INSERT INTO `post` VALUES (40, '六级作文模板', '整理了几个六级高分作文模板和万能句型', 16, '2024-12-07 17:00:00', 3);
INSERT INTO `post` VALUES (41, '英语口语练习群', '建了一个口语练习群，有兴趣的同学可以加入', 14, '2024-12-07 18:10:00', 3);
INSERT INTO `post` VALUES (42, '宿舍电费充值指南', '整理了一份详细的电费充值教程，再也不怕半夜断电了', 12, '2024-12-07 19:20:00', 4);
INSERT INTO `post` VALUES (43, '校园网优化方法', '分享几个提升校园网速度的小技巧', 8, '2024-12-07 20:30:00', 4);
INSERT INTO `post` VALUES (44, '数据库连接池配置', '分享一下JDBC连接池的配置方法，可以提升系统性能', 8, '2024-12-07 21:40:00', 5);
INSERT INTO `post` VALUES (45, '登录功能实现', '用Session实现登录功能的完整代码，供参考', 10, '2024-12-07 22:50:00', 5);
INSERT INTO `post` VALUES (46, '今天见到校长了', '在图书馆偶遇校长，还和我们聊了几句', 13, '2024-12-08 08:00:00', 6);
INSERT INTO `post` VALUES (47, '食堂新来的小哥哥', '一食堂新来了个帅哥，今天排队的人特别多', 20, '2024-12-08 09:10:00', 6);
INSERT INTO `post` VALUES (48, '复变函数公式总结', '整理了复变函数的重要公式，欢迎补充', 15, '2024-12-08 10:20:00', 7);
INSERT INTO `post` VALUES (49, '留数计算题目', '几道典型的留数计算题目，包含详细解答', 9, '2024-12-08 11:30:00', 7);
INSERT INTO `post` VALUES (50, '考研调剂经验', '去年调剂的经验分享，希望对今年考研的同学有帮助', 15, '2024-12-08 12:40:00', 9);
INSERT INTO `post` VALUES (51, '考研政治复习', '考研政治复习资料和方法分享，建议收藏', 14, '2024-12-08 13:50:00', 9);
INSERT INTO `post` VALUES (52, 'Git使用教程', 'Git版本控制入门教程，包含常用命令', 17, '2024-12-08 14:00:00', 10);
INSERT INTO `post` VALUES (53, 'Spring Boot入门', 'Spring Boot框架学习笔记和示例代码', 8, '2024-12-08 15:10:00', 10);
INSERT INTO `post` VALUES (54, '化学实验注意事项', '整理了一些化学实验的安全注意事项', 23, '2024-12-08 16:20:00', 11);
INSERT INTO `post` VALUES (55, '物理实验数据处理', '物理实验数据处理方法和误差分析', 22, '2024-12-08 17:30:00', 11);
INSERT INTO `post` VALUES (56, '摄影大赛投票', '校园摄影大赛开始投票了，快来为喜欢的作品投票', 19, '2024-12-08 18:40:00', 12);
INSERT INTO `post` VALUES (57, '街舞社招新', '街舞社新学期招新，零基础也可以报名', 20, '2024-12-08 19:50:00', 12);
INSERT INTO `post` VALUES (58, '期末考试安排', '整理了本学期所有科目的考试时间和地点', 6, '2024-12-08 20:00:00', 13);
INSERT INTO `post` VALUES (59, '考试复习计划', '分享一下我的期末复习计划和时间安排', 7, '2024-12-08 21:10:00', 13);
INSERT INTO `post` VALUES (60, '考研视频资源', '整理了王道考研的全套视频资源，需要的私信', 21, '2024-12-08 22:20:00', 14);
INSERT INTO `post` VALUES (61, '编程类电子书', 'Java、Python、C++等编程书籍分享', 8, '2024-12-08 23:30:00', 14);
INSERT INTO `post` VALUES (62, '考研压力好大', '感觉学不完了，想找人聊聊天', 15, '2024-12-09 00:40:00', 15);
INSERT INTO `post` VALUES (63, '今天很开心', '实验成功了，终于可以睡个好觉了', 11, '2024-12-09 01:50:00', 15);

-- ----------------------------
-- Table structure for topic
-- ----------------------------
DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic`  (
  `topic_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`topic_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic
-- ----------------------------
INSERT INTO `topic` VALUES (3, '大学英语', '四六级、口语、写作、听力训练', '2024-12-09 10:02:00');
INSERT INTO `topic` VALUES (2, '线性代数', '矩阵、行列式、特征值、二次型', '2024-12-09 10:01:00');
INSERT INTO `topic` VALUES (1, '高等数学', '数学分析、微积分、极限、导数、积分', '2024-12-09 10:00:00');
INSERT INTO `topic` VALUES (4, '校园生活', '食堂、宿舍、图书馆、运动', '2024-12-09 10:03:00');
INSERT INTO `topic` VALUES (5, 'Java课设', '早八痛苦否？', '2024-12-09 11:06:19');
INSERT INTO `topic` VALUES (6, '新鲜事', '小事不新鲜，新鲜无小事', '2024-12-09 11:07:54');
INSERT INTO `topic` VALUES (7, '复变函数', '考试就和Java课设差两天', '2024-12-09 11:08:36');
INSERT INTO `topic` VALUES (8, '意见反馈', '骂骂我们，让我们变得更好', '2024-12-09 11:09:05');
INSERT INTO `topic` VALUES (9, '考研交流', '考研经验、资料分享、调剂信息', '2024-12-09 11:10:00');
INSERT INTO `topic` VALUES (10, '编程技术', 'Java、Python、C++、前端开发', '2024-12-09 11:11:00');
INSERT INTO `topic` VALUES (11, '实验课程', '物理实验、化学实验、编程实验', '2024-12-09 11:12:00');
INSERT INTO `topic` VALUES (12, '校园活动', '社团活动、比赛、讲座、志愿服务', '2024-12-09 11:13:00');
INSERT INTO `topic` VALUES (13, '考试周', '期中考试、期末考试、补考', '2024-12-09 11:14:00');
INSERT INTO `topic` VALUES (14, '资源共享', '电子书、视频教程、习题资料', '2024-12-09 11:15:00');
INSERT INTO `topic` VALUES (15, '心情驿站', '学习压力、生活感悟、情感交流', '2024-12-09 11:16:00');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_admin` tinyint(1) NULL DEFAULT 0,
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'zhangsan', '202cb962ac59075b964b07152d234b70', 0, '2024-12-08 20:17:47');
INSERT INTO `user` VALUES (2, 'admin', '21232f297a57a5a743894a0e4a801fc3', 1, '2024-12-08 20:50:53');
INSERT INTO `user` VALUES (3, 'MakinoStark', '30351b219bd633989518f2af469d64d0', 0, '2024-12-08 22:23:59');
INSERT INTO `user` VALUES (4, 'student001', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:00:00');
INSERT INTO `user` VALUES (5, 'student002', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:01:00');
INSERT INTO `user` VALUES (6, 'freshman2024', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:02:00');
INSERT INTO `user` VALUES (7, 'senior2020', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:03:00');
INSERT INTO `user` VALUES (8, 'coding_lover', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:04:00');
INSERT INTO `user` VALUES (9, 'math_genius', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:05:00');
INSERT INTO `user` VALUES (10, 'sleepy_coder', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:06:00');
INSERT INTO `user` VALUES (11, 'coffee_addict', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:07:00');
INSERT INTO `user` VALUES (12, '小明', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:08:00');
INSERT INTO `user` VALUES (13, '大白', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:09:00');
INSERT INTO `user` VALUES (14, '学习达人', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:10:00');
INSERT INTO `user` VALUES (15, '考研人', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:11:00');
INSERT INTO `user` VALUES (16, 'alice2024', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:12:00');
INSERT INTO `user` VALUES (17, 'bob_cs', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:13:00');
INSERT INTO `user` VALUES (18, 'charlie_math', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:14:00');
INSERT INTO `user` VALUES (19, 'basketball_fan', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:15:00');
INSERT INTO `user` VALUES (20, 'music_lover', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:16:00');
INSERT INTO `user` VALUES (21, 'book_worm', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:17:00');
INSERT INTO `user` VALUES (22, 'physics_guy', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:18:00');
INSERT INTO `user` VALUES (23, 'chemistry_lab', '202cb962ac59075b964b07152d234b70', 0, '2024-12-09 09:19:00');
INSERT INTO `user` VALUES (24, 'lgq', '202cb962ac59075b964b07152d234b70', 0, '2024-12-17 19:43:34');

SET FOREIGN_KEY_CHECKS = 1;

package zly.design.jsp.service;

import zly.design.jsp.dao.BaseDao;
import zly.design.jsp.model.*;
import java.util.ArrayList;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;

public class AllService {
    private BaseDao dao = new BaseDao();

    // MD5加密
    private String md5(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] array = md.digest(password.getBytes());
            StringBuffer sb = new StringBuffer();
            for (byte b : array) {
                sb.append(Integer.toHexString((b & 0xFF) | 0x100).substring(1, 3));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 用户相关业务
    public boolean register(String username, String password) {
        if (username == null || password == null ||
                username.trim().isEmpty() || password.trim().isEmpty()) {
            return false;
        }

        // 检查用户名是否已存在
        if (dao.findUserByUsername(username) != null) {
            return false;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(md5(password));
        user.setAdmin(false);
        return dao.addUser(user);
    }

    public User login(String username, String password) {
        if (username == null || password == null) {
            return null;
        }

        User user = dao.findUserByUsername(username);
        if (user != null && user.getPassword().equals(md5(password))) {
            return user;
        }
        return null;
    }

    // 字块相关业务

    public boolean createPost(String title, String content, int userId, Integer topicId) {
        if (title == null || content == null || title.isEmpty()) {
            return false;
        }

        Post post = new Post();
        post.setTitle(title.trim());
        post.setContent(content);
        post.setUserId(userId);
        if (topicId != null && topicId > 0) {
            post.setTopicId(topicId);
        }

        // debug
        //System.out.println("Service层收到的标题: " + title);
        //System.out.println("Service层收到的内容: " + content);
        //System.out.println("内容中的换行符数量: " + content.split("\n").length);

        return dao.addPost(post);
    }

    public List<Post> getPosts(int pageNum, int pageSize) {
        if (pageNum < 1) pageNum = 1;
        if (pageSize < 1) pageSize = 10;
        return dao.getAllPosts(pageNum, pageSize);
    }

    public boolean deletePost(int postId, int userId, boolean isAdmin) {
        return dao.deletePost(postId, userId, isAdmin);
    }

    // 修改搜索方法，支持分页
    public List<Post> searchPosts(String keyword, int offset, int limit) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return new ArrayList<>();
        }
        return dao.searchPosts(keyword, offset, limit);
    }

    public int getSearchResultCount(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return 0;
        }
        return dao.getSearchResultCount(keyword);
    }

    public int getTopicTotalPages(int topicId, int pageSize) {
        int totalPosts = dao.getPostCountByTopic(topicId);
        return (int) Math.ceil((double) totalPosts / pageSize);
    }

    // 评论相关业务
    public boolean addComment(String content, int postId, int userId) {
        if (content == null || content.trim().isEmpty()) {
            return false;
        }

        Comment comment = new Comment();
        comment.setContent(content);
        comment.setPostId(postId);
        comment.setUserId(userId);
        return dao.addComment(comment);
    }

    public List<Comment> getComments(int postId) {
        return dao.getCommentsByPostId(postId);
    }

    public boolean deleteComment(int commentId, boolean isAdmin) {
        if (!isAdmin) {
            return false;
        }
        return dao.deleteComment(commentId);
    }


    // 群书相关业务
    public List<Topic> getAllTopics() {
        return dao.getAllTopics();
    }
    public boolean addTopic(Topic topic) {
        if (topic == null || topic.getName() == null || topic.getName().trim().isEmpty()
                || topic.getDescription() == null || topic.getDescription().trim().isEmpty()) {
            return false;
        }
        return dao.addTopic(topic);
    }

    public boolean deleteTopic(int topicId) {
        if (topicId <= 0) {
            return false;
        }
        return dao.deleteTopic(topicId);
    }

    public List<Post> getPostsByTopic(int topicId, int pageNum, int pageSize) {
        if (topicId <= 0 || pageNum < 1 || pageSize < 1) {
            return null;
        }
        return dao.getPostsByTopic(topicId, pageNum, pageSize);
    }

    //公告相关业务
    public List<Announcement> getAnnouncements() {
        return dao.getAllAnnouncements();
    }

    public boolean addAnnouncement(Announcement announcement) {
        if (announcement.getTitle() == null || announcement.getTitle().trim().isEmpty() ||
                announcement.getContent() == null || announcement.getContent().isEmpty()) {
            return false;
        }

        if (announcement.getPriority() < 0 || announcement.getPriority() > 2) {
            return false;
        }

        announcement.setTitle(announcement.getTitle().trim());
        return dao.addAnnouncement(announcement);
    }

    public boolean deleteAnnouncement(int announcementId) {
        return dao.deleteAnnouncement(announcementId);
    }

    // 获取最新的公告（用于首页显示）
    public List<Announcement> getLatestAnnouncements(int limit) {
        if(limit <= 0) {
            limit = 5; // 设置默认值
        }
        List<Announcement> announcements = dao.getLatestAnnouncements(limit);
        return announcements;
    }

    // 分页相关
    public int getTotalPages(int pageSize) {
        if (pageSize < 1) pageSize = 10;
        int total = dao.getTotalPosts();
        return (total + pageSize - 1) / pageSize;
    }

    // 验证码校验
    public boolean validateCaptcha(String userInput, String sessionCaptcha) {
        if (userInput == null || sessionCaptcha == null) {
            return false;
        }
        return userInput.trim()//.toLowerCase()
                .equals(sessionCaptcha.toLowerCase());
    }

//    public Announcement getAnnouncementById(int announcementId) {
//        if (announcementId <= 0) {
//            return null;
//        }
//        return dao.getAnnouncementById(announcementId);
//    }

    public boolean updateAnnouncement(Announcement announcement) {
        if (announcement == null || announcement.getAnnouncementId() <= 0 ||
                announcement.getTitle() == null || announcement.getTitle().trim().isEmpty() ||
                announcement.getContent() == null || announcement.getContent().isEmpty()) {
            return false;
        }

        if (announcement.getPriority() < 0 || announcement.getPriority() > 2) {
            return false;
        }

        announcement.setTitle(announcement.getTitle().trim());
        return dao.updateAnnouncement(announcement);
    }

}
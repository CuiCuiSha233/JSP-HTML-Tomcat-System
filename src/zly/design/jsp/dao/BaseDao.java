package zly.design.jsp.dao;

import zly.design.jsp.model.*;
import zly.design.jsp.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
public class BaseDao {
    // 用户相关操作
    public User findUserByUsername(String username) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM user WHERE username = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setAdmin(rs.getBoolean("is_admin"));
                user.setCreateTime(rs.getTimestamp("create_time"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, rs);
        }
        return null;
    }

    public boolean addUser(User user) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO user (username, password, is_admin) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setBoolean(3, user.isAdmin());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, null);
        }
        return false;
    }


    public List<Post> getAllPosts(int pageNum, int pageSize) {
        List<Post> posts = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT p.*, u.username, t.name as topic_name " +
                    "FROM post p " +
                    "LEFT JOIN user u ON p.user_id = u.user_id " +
                    "LEFT JOIN topic t ON p.topic_id = t.topic_id " +
                    "ORDER BY p.create_time DESC LIMIT ?, ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, (pageNum - 1) * pageSize);
            stmt.setInt(2, pageSize);

            rs = stmt.executeQuery();
            while (rs.next()) {
                Post post = new Post();
                post.setPostId(rs.getInt("post_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setUserId(rs.getInt("user_id"));
                post.setUsername(rs.getString("username"));
                post.setCreateTime(String.valueOf(rs.getTimestamp("create_time")));
                post.setTopicId(rs.getInt("topic_id"));
                post.setTopicName(rs.getString("topic_name"));
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, rs);
        }
        return posts;
    }



    public boolean addPost(Post post) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO post (title, content, user_id, topic_id) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getContent());
            stmt.setInt(3, post.getUserId());
            if (post.getTopicId() > 0) {
                stmt.setInt(4, post.getTopicId());
            } else {
                stmt.setNull(4, java.sql.Types.INTEGER);
            }
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, null);
        }
        return false;
    }
    public boolean deletePost(int postId, int userId, boolean isAdmin) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = isAdmin ?
                    "DELETE FROM post WHERE post_id = ?" :
                    "DELETE FROM post WHERE post_id = ? AND user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, postId);
            if (!isAdmin) {
                stmt.setInt(2, userId);
            }
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, null);
        }
        return false;
    }

    // 评论相关操作
    public List<Comment> getCommentsByPostId(int postId) {
        List<Comment> comments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT c.*, u.username FROM comment c LEFT JOIN user u ON c.user_id = u.user_id " +
                    "WHERE c.post_id = ? ORDER BY c.create_time DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, postId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Comment comment = new Comment();
                comment.setCommentId(rs.getInt("comment_id"));
                comment.setContent(rs.getString("content"));
                comment.setPostId(rs.getInt("post_id"));
                comment.setUserId(rs.getInt("user_id"));
                comment.setUsername(rs.getString("username"));
                comment.setCreateTime(rs.getTimestamp("create_time"));
                comments.add(comment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, rs);
        }
        return comments;
    }

    public boolean addComment(Comment comment) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO comment (content, post_id, user_id) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, comment.getContent());
            stmt.setInt(2, comment.getPostId());
            stmt.setInt(3, comment.getUserId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, null);
        }
        return false;
    }

    public boolean deleteComment(int commentId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM comment WHERE comment_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, commentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, null);
        }
        return false;
    }


    // 群书相关操作
    public List<Topic> getAllTopics() {
        List<Topic> topics = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM topic ORDER BY create_time DESC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Topic topic = new Topic();
                topic.setTopicId(rs.getInt("topic_id"));
                topic.setName(rs.getString("name"));
                topic.setDescription(rs.getString("description"));
                topic.setCreateTime(String.valueOf(rs.getTimestamp("create_time")));
                topics.add(topic);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, rs);
        }
        return topics;
    }

    // 添加群书
    public boolean addTopic(Topic topic) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO topic (name, description) VALUES (?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, topic.getName());
            stmt.setString(2, topic.getDescription());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, null);
        }
        return false;
    }

    // 删除群书
    public boolean deleteTopic(int topicId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBUtil.getConnection();
            // 先更新相关字块的群书ID为null
            String updateSql = "UPDATE post SET topic_id = NULL WHERE topic_id = ?";
            stmt = conn.prepareStatement(updateSql);
            stmt.setInt(1, topicId);
            stmt.executeUpdate();

            // 然后删除群书
            String deleteSql = "DELETE FROM topic WHERE topic_id = ?";
            stmt = conn.prepareStatement(deleteSql);
            stmt.setInt(1, topicId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, null);
        }
        return false;
    }

    // 获取指定群书的字块
    public List<Post> getPostsByTopic(int topicId, int pageNum, int pageSize) {
        List<Post> posts = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT p.*, u.username FROM post p " +
                    "LEFT JOIN user u ON p.user_id = u.user_id " +
                    "WHERE p.topic_id = ? " +
                    "ORDER BY p.create_time DESC LIMIT ?, ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, topicId);
            stmt.setInt(2, (pageNum - 1) * pageSize);
            stmt.setInt(3, pageSize);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Post post = new Post();
                post.setPostId(rs.getInt("post_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setUserId(rs.getInt("user_id"));
                post.setUsername(rs.getString("username"));
                post.setCreateTime(String.valueOf(rs.getTimestamp("create_time")));
                post.setTopicId(topicId);
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, rs);
        }
        return posts;
    }

    // 搜索字块
    public List<Post> searchPosts(String keyword, int offset, int limit) {
        List<Post> posts = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT p.*, u.username, t.name as topic_name FROM post p " +
                    "LEFT JOIN user u ON p.user_id = u.user_id " +
                    "LEFT JOIN topic t ON p.topic_id = t.topic_id " +
                    "WHERE p.title LIKE ? OR p.content LIKE ? " +
                    "ORDER BY p.create_time DESC LIMIT ?, ?";
            stmt = conn.prepareStatement(sql);
            String likePattern = "%" + keyword + "%";
            stmt.setString(1, likePattern);
            stmt.setString(2, likePattern);
            stmt.setInt(3, offset);
            stmt.setInt(4, limit);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Post post = new Post();
                post.setPostId(rs.getInt("post_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setUserId(rs.getInt("user_id"));
                post.setUsername(rs.getString("username"));
                post.setCreateTime(String.valueOf(rs.getTimestamp("create_time")));
                post.setTopicId(rs.getInt("topic_id"));
                post.setTopicName(rs.getString("topic_name"));
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, rs);
        }
        return posts;
    }

    // 获取搜索结果总数
    public int getSearchResultCount(String keyword) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM post WHERE title LIKE ? OR content LIKE ?";
            stmt = conn.prepareStatement(sql);
            String likePattern = "%" + keyword + "%";
            stmt.setString(1, likePattern);
            stmt.setString(2, likePattern);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, rs);
        }
        return 0;
    }

    // 获取指定群书的字块总数
    public int getPostCountByTopic(int topicId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM post WHERE topic_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, topicId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, rs);
        }
        return 0;
    }

    // 公告相关操作
    public List<Announcement> getAllAnnouncements() {
        List<Announcement> announcements = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT a.*, u.username FROM announcement a " +
                    "LEFT JOIN user u ON a.publisher_id = u.user_id " +
                    "ORDER BY a.priority DESC, a.create_time DESC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Announcement announcement = new Announcement();
                announcement.setAnnouncementId(rs.getInt("announcement_id"));
                announcement.setPublisherId(rs.getInt("publisher_id"));
                announcement.setTitle(rs.getString("title"));
                announcement.setContent(rs.getString("content"));
                announcement.setPriority(rs.getInt("priority"));
                announcement.setCreateTime(rs.getTimestamp("create_time"));
                announcement.setPublisherName(rs.getString("username"));
                announcements.add(announcement);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, rs);
        }
        return announcements;
    }

    public boolean addAnnouncement(Announcement announcement) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO announcement (publisher_id, title, content, priority) " +
                    "VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, announcement.getPublisherId());
            stmt.setString(2, announcement.getTitle());
            stmt.setString(3, announcement.getContent());
            stmt.setInt(4, announcement.getPriority());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, null);
        }
        return false;
    }

    public boolean deleteAnnouncement(int announcementId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM announcement WHERE announcement_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, announcementId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, null);
        }
        return false;
    }

    // 获取最新的公告（用于首页显示）
    public List<Announcement> getLatestAnnouncements(int limit) {
        List<Announcement> announcements = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT a.*, u.username FROM announcement a " +
                    "LEFT JOIN user u ON a.publisher_id = u.user_id " +
                    "ORDER BY a.priority DESC, a.create_time DESC LIMIT ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Announcement announcement = new Announcement();
                announcement.setAnnouncementId(rs.getInt("announcement_id"));
                announcement.setPublisherId(rs.getInt("publisher_id"));
                announcement.setTitle(rs.getString("title"));
                announcement.setContent(rs.getString("content"));
                announcement.setPriority(rs.getInt("priority"));
                announcement.setCreateTime(rs.getTimestamp("create_time"));
                announcement.setPublisherName(rs.getString("username"));
                announcements.add(announcement);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, rs);
        }
        return announcements;
    }

    // 根据ID获取公告
    public Announcement getAnnouncementById(int announcementId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT a.*, u.username FROM announcement a " +
                    "LEFT JOIN user u ON a.publisher_id = u.user_id " +
                    "WHERE a.announcement_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, announcementId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                Announcement announcement = new Announcement();
                announcement.setAnnouncementId(rs.getInt("announcement_id"));
                announcement.setPublisherId(rs.getInt("publisher_id"));
                announcement.setTitle(rs.getString("title"));
                announcement.setContent(rs.getString("content"));
                announcement.setPriority(rs.getInt("priority"));
                announcement.setCreateTime(rs.getTimestamp("create_time"));
                announcement.setPublisherName(rs.getString("username"));
                return announcement;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, rs);
        }
        return null;
    }


    // 获取字块总数（用于分页）
    public int getTotalPosts() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM post";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, rs);
        }
        return 0;
    }

    // 修改公告
    public boolean updateAnnouncement(Announcement announcement) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE announcement SET title = ?, content = ?, priority = ? WHERE announcement_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, announcement.getTitle());
            stmt.setString(2, announcement.getContent());
            stmt.setInt(3, announcement.getPriority());
            stmt.setInt(4, announcement.getAnnouncementId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, null);
        }
        return false;
    }
}

package zly.design.jsp.servlet;

import zly.design.jsp.model.*;
import zly.design.jsp.service.AllService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.List;
import java.util.Random;
import javax.imageio.ImageIO;

@WebServlet("/")
public class AllServlet extends HttpServlet {
    private AllService service = new AllService();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        // 处理根路径访问
        if (path.equals("/")) {
            showHomePage(request, response);
            return;
        }

        // 其他路径的处理
        switch (path) {
            case "/login":
                showLoginPage(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            case "/captcha":
                generateCaptcha(request, response);
                break;
            case "/post":
                showPostPage(request, response);
                break;
            case "/manage":
                showManagePage(request, response);
                break;
            case "/topic":
                showTopicPage(request, response);
                break;
            case "/announcement/add":
                addAnnouncement(request, response);
                break;
            case "/announcement/delete":
                deleteAnnouncement(request, response);
                break;
            case "/announcement/update":
                updateAnnouncement(request, response);
                break;
            default:
                showHomePage(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        try {
            switch (path) {
                case "/login":
                    processLogin(request, response);
                    break;
                case "/register":
                    processRegister(request, response);
                    break;
                case "/post/add":
                    addPost(request, response);
                    break;
                case "/post/delete":
                    deletePost(request, response);
                    break;
                case "/comment/add":
                    addComment(request, response);
                    break;
                case "/comment/delete":
                    deleteComment(request, response);
                    break;
                case "/search":
                    searchPosts(request, response);
                    break;
                case "/topic/add":
                    addTopic(request, response);
                    break;
                case "/topic/delete":
                    deleteTopic(request, response);
                    break;
                case "/announcement/add":
                    addAnnouncement(request, response);
                    break;
                case "/announcement/delete":
                    deleteAnnouncement(request, response);
                    break;
                case "/announcement/update":
                    updateAnnouncement(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "操作失败：" + e.getMessage());
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }

    private void showHomePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 获取分页参数
            int page = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                page = Integer.parseInt(pageStr);
            }

            // 获取群书筛选参数
            String topicIdStr = request.getParameter("topic");
            Integer topicId = null;
            if (topicIdStr != null && !topicIdStr.trim().isEmpty()) {
                try {
                    topicId = Integer.parseInt(topicIdStr);
                } catch (NumberFormatException e) {
                    // 忽略无效的群书ID
                }
            }

            // 获取搜索参数
            String keyword = request.getParameter("keyword");
            List<Post> posts;
            int totalPages;

            // 根据条件获取字块列表
            if (keyword != null && !keyword.trim().isEmpty()) {
                int offset = (page - 1) * PAGE_SIZE;
                posts = service.searchPosts(keyword, offset, PAGE_SIZE);
                totalPages = (int) Math.ceil((double) service.getSearchResultCount(keyword) / PAGE_SIZE);
            } else if (topicId != null) {
                // 获取话题的总页数
                totalPages = service.getTopicTotalPages(topicId, PAGE_SIZE);

                // 确保页码有效
                if (page < 1) {
                    page = 1;
                } else if (page > totalPages && totalPages > 0) {
                    page = totalPages;
                }

                posts = service.getPostsByTopic(topicId, page, PAGE_SIZE);

                // 如果没有字块，设置总页数为0
                if (posts.isEmpty()) {
                    totalPages = 0;
                }
            } else {
                posts = service.getPosts(page, PAGE_SIZE);
                totalPages = service.getTotalPages(PAGE_SIZE);
            }

            // 获取评论
            if(posts != null) {
                for(Post post : posts) {
                    List<Comment> comments = service.getComments(post.getPostId());
                    request.setAttribute("comments_" + post.getPostId(), comments);
                }
            }

            // 获取最新的公告
            List<Announcement> announcements = service.getLatestAnnouncements(5);
            request.setAttribute("announcements", announcements);

            // 获取所有群书
            List<Topic> topics = service.getAllTopics();

            // 设置请求属性
            request.setAttribute("posts", posts);
            request.setAttribute("topics", topics);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("selectedTopic", topicId);
            request.setAttribute("keyword", keyword);

            // 转发到首页
            request.getRequestDispatcher("/index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "加载页面时发生错误");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }

    private void showLoginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    private void generateCaptcha(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int width = 100;
        int height = 30;
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics g = image.getGraphics();

        // 设置背景色
        g.setColor(Color.WHITE);
        g.fillRect(0, 0, width, height);

        // 生成随机验证码
        String chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        Random random = new Random();
        StringBuilder captcha = new StringBuilder();
        g.setFont(new Font("Arial", Font.BOLD, 20));

        for (int i = 0; i < 4; i++) {
            String ch = String.valueOf(chars.charAt(random.nextInt(chars.length())));
            captcha.append(ch);
            g.setColor(new Color(random.nextInt(255), random.nextInt(255), random.nextInt(255)));
            g.drawString(ch, 20 + i * 20, 20);
        }

        // 添加干扰线
        for (int i = 0; i < 6; i++) {
            g.setColor(new Color(random.nextInt(255), random.nextInt(255), random.nextInt(255)));
            g.drawLine(random.nextInt(width), random.nextInt(height),
                    random.nextInt(width), random.nextInt(height));
        }

        // 保存验证码session
        request.getSession().setAttribute("captcha", captcha.toString());

        // 输出图片
        response.setContentType("image/jpeg");
        ImageIO.write(image, "JPEG", response.getOutputStream());
    }

    private void processLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String captcha = request.getParameter("captcha");
        String sessionCaptcha = (String) request.getSession().getAttribute("captcha");

        if (!service.validateCaptcha(captcha, sessionCaptcha)) {
            request.setAttribute("error", "验证码错误");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = service.login(username, password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // 设置Cookie
            Cookie userCookie = new Cookie("username", username);
            userCookie.setMaxAge(24 * 60 * 60); // 24小时
            response.addCookie(userCookie);

            response.sendRedirect(request.getContextPath() + "/");
        } else {
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void processRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String captcha = request.getParameter("captcha");
        String sessionCaptcha = (String) request.getSession().getAttribute("captcha");

        if (!service.validateCaptcha(captcha, sessionCaptcha)) {
            request.setAttribute("error", "验证码错误");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (service.register(username, password)) {
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("error", "注册失败，用户名可能已存在");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // 清除会话
        request.getSession().invalidate();

        // 清除Cookie
        Cookie userCookie = new Cookie("username", "");
        userCookie.setMaxAge(0);
        response.addCookie(userCookie);

        // 直接重定向到登录页面
        response.sendRedirect(request.getContextPath() + "/login");
    }

    private void showPostPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 获取所有群书
        List<Topic> topics = service.getAllTopics();
        request.setAttribute("topics", topics);
        request.getRequestDispatcher("/post.jsp").forward(request, response);
    }

    private void addPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String topicIdStr = request.getParameter("topicId");

        //debug
        //System.out.println("提交的标题: " + title);
        //System.out.println("提交的内容: " + content);

        Integer topicId = null;
        if (topicIdStr != null && !topicIdStr.trim().isEmpty()) {
            try {
                topicId = Integer.parseInt(topicIdStr);
            } catch (NumberFormatException e) { }
        }

        if (service.createPost(title, content, user.getUserId(), topicId)) {
            response.sendRedirect(request.getContextPath() + "/");
        } else {
            response.sendRedirect(request.getContextPath() + "/post?error=true");
        }
    }

    private void addComment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String content = request.getParameter("content");
        int postId;
        try {
            postId = Integer.parseInt(request.getParameter("postId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/#post_" + postId);
            return;
        }

        if (service.addComment(content.trim(), postId, user.getUserId())) {
            // 添加成功后重定向到具体字块位置
            response.sendRedirect(request.getContextPath() + "/#post_" + postId);
        } else {
            response.sendRedirect(request.getContextPath() + "/?error=comment");
        }
    }

    private void deleteComment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int commentId = Integer.parseInt(request.getParameter("commentId"));
        int postId = Integer.parseInt(request.getParameter("postId")); // 用于重定向回原字块

        if (service.deleteComment(commentId, user.isAdmin())) {
            // 删除成功，重定向到原字块位置
            response.sendRedirect(request.getContextPath() + "/#post_" + postId);
        } else {
            response.sendRedirect(request.getContextPath() + "/?error=deleteComment");
        }
    }


    private void deletePost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int postId = Integer.parseInt(request.getParameter("postId"));

        if (service.deletePost(postId, user.getUserId(), user.isAdmin())) {
            response.sendRedirect(request.getContextPath() + "/manage");
        } else {
            response.sendRedirect(request.getContextPath() + "/manage?error=delete");
        }
    }

    private void showManagePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            // 分页使用默认值1
        }


        List<Post> posts = service.getPosts(page, PAGE_SIZE);
        int totalPages = service.getTotalPages(PAGE_SIZE);

        request.setAttribute("posts", posts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        if (user.isAdmin()) {
            List<Announcement> announcements = service.getAnnouncements();
            request.setAttribute("announcements", announcements);
        }
        request.getRequestDispatcher("/manage.jsp").forward(request, response);
    }

    private void addAnnouncement(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        int priority = Integer.parseInt(request.getParameter("priority"));

        Announcement announcement = new Announcement();
        announcement.setPublisherId(user.getUserId());
        announcement.setTitle(title);
        announcement.setContent(content);
        announcement.setPriority(priority);

        if (service.addAnnouncement(announcement)) {
            response.sendRedirect(request.getContextPath() + "/manage");
        } else {
            request.setAttribute("error", "发布公告失败");
            response.sendRedirect(request.getContextPath() + "/manage");
        }
    }

    private void deleteAnnouncement(HttpServletRequest request, HttpServletResponse response)
            throws  IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int announcementId = Integer.parseInt(request.getParameter("announcementId"));
        service.deleteAnnouncement(announcementId);
        response.sendRedirect(request.getContextPath() + "/manage");
    }


    private void showTopicPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Topic> topics = service.getAllTopics();
        request.setAttribute("topics", topics);
        request.getRequestDispatcher("/topic.jsp").forward(request, response);
    }


    private void addTopic(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");

        if (name == null || name.trim().isEmpty() ||
                description == null || description.trim().isEmpty()) {
            request.setAttribute("error", "群书名称和描述不能为空");
            response.sendRedirect(request.getContextPath() + "/topic");
            return;
        }

        Topic topic = new Topic();
        topic.setName(name.trim());
        topic.setDescription(description.trim());

        try {
            service.addTopic(topic);
            response.sendRedirect(request.getContextPath() + "/topic");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "创建群书失败：" + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/topic");
        }
    }

    private void deleteTopic(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int topicId = Integer.parseInt(request.getParameter("topicId"));

        if (service.deleteTopic(topicId)) {
            response.sendRedirect(request.getContextPath() + "/topic");
        } else {
            request.setAttribute("error", "删除群书失败");
            response.sendRedirect(request.getContextPath() + "/topic");
        }
    }

    private void searchPosts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        // 如果是搜索请求，则进行搜索
        if (keyword != null && !keyword.trim().isEmpty()) {
            int page = 1;
            try {
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.trim().isEmpty()) {
                    page = Integer.parseInt(pageStr);
                }
            } catch (NumberFormatException e) {
                // 使用默认值 page = 1
            }

            // 用 PAGE_SIZE 进行分页
            int offset = (page - 1) * PAGE_SIZE;
            List<Post> posts = service.searchPosts(keyword, offset, PAGE_SIZE);

            // 获取总记录数并计算总页数
            int totalRecords = service.getSearchResultCount(keyword);
            int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

            // 确保页码有效
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
                offset = (page - 1) * PAGE_SIZE;
                posts = service.searchPosts(keyword, offset, PAGE_SIZE);
            }

            // 获取评论
            if (posts != null) {
                for (Post post : posts) {
                    List<Comment> comments = service.getComments(post.getPostId());
                    request.setAttribute("comments_" + post.getPostId(), comments);
                }
            }

            // 设置请求属性
            request.setAttribute("posts", posts);
            request.setAttribute("keyword", keyword);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
        }

        // 获取其他必要的数据（公告和群书）
        List<Announcement> announcements = service.getLatestAnnouncements(5);
        List<Topic> topics = service.getAllTopics();
        request.setAttribute("announcements", announcements);
        request.setAttribute("topics", topics);

        // 转发到首页
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    private void updateAnnouncement(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int announcementId = Integer.parseInt(request.getParameter("announcementId"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        int priority = Integer.parseInt(request.getParameter("priority"));

        Announcement announcement = new Announcement();
        announcement.setAnnouncementId(announcementId);
        announcement.setTitle(title);
        announcement.setContent(content);
        announcement.setPriority(priority);
        announcement.setPublisherId(user.getUserId());

        if (service.updateAnnouncement(announcement)) {
            response.sendRedirect(request.getContextPath() + "/manage?success=updateAnnouncement");
        } else {
            response.sendRedirect(request.getContextPath() + "/manage?error=updateAnnouncement");
        }
    }
}
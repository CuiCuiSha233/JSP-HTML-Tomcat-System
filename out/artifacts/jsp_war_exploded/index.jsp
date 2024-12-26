<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="zly.design.jsp.model.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>社区问答系统 - 首页</title>
    <!-- Bootstrap 5 CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="css/fontawesome/css/all.min.css" rel="stylesheet">
    <link href="css/fontawesome/css/svg-with-js.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-light bg-white">
    <div class="container">
        <a class="navbar-brand" href="<%=request.getContextPath()%>/">
            <i class="fas fa-comments"></i> 社区问答系统
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="<%=request.getContextPath()%>/"><i class="fas fa-home"></i> 首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/topic"><i class="fas fa-book"></i> 群书</a>
                </li>
                <% User user = (User)session.getAttribute("user");
                    if(user != null) { %>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/post"><i class="fas fa-edit"></i> 回字</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/manage"><i class="fas fa-cog"></i> 管理</a>
                </li>
                <% } %>
            </ul>

            <!-- 搜索框 -->
            <form class="d-flex me-3" action="<%=request.getContextPath()%>/search" method="get">
                <div class="input-group">
                    <input class="form-control search-input" type="search" name="keyword"
                           placeholder="搜索..." value="<%=request.getAttribute("keyword") != null ? request.getAttribute("keyword") : ""%>">
                    <button class="btn btn-outline-primary" type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </form>

            <ul class="navbar-nav">
                <% if(user == null) { %>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/login">
                        <i class="fas fa-sign-in-alt"></i> 登录/注册
                    </a>
                </li>
                <% } else { %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user"></i> <%=user.getUsername()%>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/profile">
                            <i class="fas fa-user-circle"></i> 个人中心</a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/logout">
                            <i class="fas fa-sign-out-alt"></i> 退出</a>
                        </li>
                    </ul>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>
<!-- 主要内容 -->
<div class="container py-4">
    <div class="row">
        <!-- 左侧主要内容区 -->
        <div class="col-md-8">
            <!-- 字块列表 -->
            <%
                List<Post> posts = (List<Post>)request.getAttribute("posts");
                if(posts != null && !posts.isEmpty()) {
                    for(Post post : posts) {
            %>
            <div class="card shadow-sm mb-4" id="post_<%=post.getPostId()%>">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-file-lines text-primary"></i> <%=post.getTitle()%>
                    </h5>
                </div>
                <div class="card-body">
                    <pre class="card-text post-content"><%=post.getContent()%></pre>
                    <div class="post-meta text-muted small">
                        <i class="fas fa-user"></i> <%=post.getUsername()%>
                        <span class="ms-3"><i class="fas fa-clock"></i> <%=post.getCreateTime()%></span>
                    </div>
                </div>
                <div class="card-footer bg-white">
                    <!-- 评论表单 -->
                    <% if(user != null) { %>
                    <form class="comment-form mb-3" action="<%=request.getContextPath()%>/comment/add" method="post">
                        <input type="hidden" name="postId" value="<%=post.getPostId()%>">
                        <div class="mb-3">
                                <textarea class="form-control"
                                          name="content"
                                          rows="3"
                                          placeholder="写下你的评论..."
                                          required></textarea>
                        </div>
                        <div class="text-end">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane"></i> 评论
                            </button>
                        </div>
                    </form>
                    <% } %>

                    <!-- 评论列表 -->
                    <%
                        List<Comment> comments = (List<Comment>)request.getAttribute("comments_" + post.getPostId());
                        if(comments != null && !comments.isEmpty()) {
                    %>
                    <div class="comments-list">
                        <h6 class="mb-3"><i class="fas fa-comments text-primary"></i> 评论列表</h6>
                        <% for(Comment comment : comments) { %>
                        <div class="comment mb-2 pb-2 border-bottom">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <strong><i class="fas fa-user-circle"></i> <%=comment.getUsername()%></strong>
                                    <pre class="comment-content"><%=comment.getContent()%></pre>
                                </div>
                                <div class="text-muted small">
                                    <i class="fas fa-clock"></i> <%=comment.getCreateTime()%>
                                    <% if(user != null && (user.isAdmin() || user.getUserId() == comment.getUserId())) { %>
                                    <form class="d-inline ms-2" action="<%=request.getContextPath()%>/comment/delete" method="post">
                                        <input type="hidden" name="commentId" value="<%=comment.getCommentId()%>">
                                        <input type="hidden" name="postId" value="<%=post.getPostId()%>">
                                        <button type="submit" class="btn btn-link btn-sm text-danger p-0"
                                                onclick="return confirm('确定要删除这条评论吗？')">
                                            <i class="fas fa-trash"></i> 删除
                                        </button>
                                    </form>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    <% } %>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i> 暂无字块
            </div>
            <% } %>

            <!-- 分页 -->
            <%
                Integer currentPage = (Integer)request.getAttribute("currentPage");
                Integer totalPages = (Integer)request.getAttribute("totalPages");
                String keyword = (String)request.getAttribute("keyword");
                Integer selectedTopic = (Integer)request.getAttribute("selectedTopic");

                // 只有当总页数大于1时才显示分页
                if(totalPages != null && totalPages > 1) {
                    String pageUrl;
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        pageUrl = "?keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") + "&page=";
                    } else if (selectedTopic != null) {
                        pageUrl = "?topic=" + selectedTopic + "&page=";
                    } else {
                        pageUrl = "?page=";
                    }
            %>
            <nav aria-label="Page navigation" class="d-flex justify-content-center mt-4">
                <ul class="pagination">
                    <!-- 上一页 -->
                    <% if(currentPage > 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="<%=pageUrl + (currentPage-1)%>" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <% } %>

                    <!-- 页码 -->
                    <% for(int i = 1; i <= totalPages; i++) { %>
                    <li class="page-item <%= i==currentPage ? "active" : "" %>">
                        <a class="page-link" href="<%=pageUrl + i%>"><%=i%></a>
                    </li>
                    <% } %>

                    <!-- 下一页 -->
                    <% if(currentPage < totalPages) { %>
                    <li class="page-item">
                        <a class="page-link" href="<%=pageUrl + (currentPage+1)%>" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                    <% } %>
                </ul>
            </nav>
            <% } %>
        </div>

        <!-- 右侧边栏 -->
        <div class="col-md-4">
            <!-- 公告面板 -->
            <div class="card shadow-sm mb-4">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-bullhorn text-primary"></i> 系统公告
                    </h5>
                </div>
                <div class="card-body">
                    <%
                        List<Announcement> announcements = (List<Announcement>)request.getAttribute("announcements");
                        if(announcements != null && !announcements.isEmpty()) {
                            for(Announcement announcement : announcements) {
                    %>
                    <div class="announcement mb-3 pb-3 border-bottom">
                        <h6 class="mb-2">
                            <%
                                switch(announcement.getPriority()) {
                                    case 2: %><span class="badge bg-danger"><i class="fas fa-exclamation-circle"></i> 紧急</span><% break;
                            case 1: %><span class="badge bg-warning text-dark"><i class="fas fa-exclamation"></i> 重要</span><% break;
                            default: %><span class="badge bg-info"><i class="fas fa-info"></i> 普通</span><% break;
                        }
                        %>
                            <span class="ms-2"><%=announcement.getTitle()%></span>
                        </h6>
                        <pre class="mb-2 announcement-content"><%=announcement.getContent()%></pre>
                        <small class="text-muted">
                            <i class="fas fa-user"></i> <%=announcement.getPublisherName()%>
                            <span class="ms-2"><i class="fas fa-clock"></i> <%=announcement.getCreateTime()%></span>
                        </small>
                    </div>
                    <%
                        }
                    } else {
                    %>
                    <p class="text-muted mb-0"><i class="fas fa-info-circle"></i> 暂无公告</p>
                    <%
                        }
                    %>
                </div>
            </div>

            <!-- 热门话题面板 -->
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-fire text-primary"></i> 热门群书
                    </h5>
                </div>
                <div class="card-body">
                    <div class="topic-cloud">
                        <%
                            List<Topic> topics = (List<Topic>)request.getAttribute("topics");
                            if(topics != null && !topics.isEmpty()) {
                                for(Topic topic : topics) {
                        %>
                        <a href="<%=request.getContextPath()%>/?topic=<%=topic.getTopicId()%>"
                           class="btn btn-outline-primary btn-sm me-2 mb-2">
                            <i class="fas fa-tag"></i> <%=topic.getName()%>
                        </a>
                        <%
                            }
                        } else {
                        %>
                        <p class="text-muted mb-0"><i class="fas fa-info-circle"></i> 暂无群书</p>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS 和 Popper.js -->
<script src="js/popper.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="css/fontawesome/js/all.min.js"></script>
</body>
</html>
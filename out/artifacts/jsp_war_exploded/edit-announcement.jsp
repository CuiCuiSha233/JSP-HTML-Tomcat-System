<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="zly.design.jsp.model.Announcement" %>
<%@ page import="zly.design.jsp.model.User" %>
<%
    Announcement announcement = (Announcement) request.getAttribute("announcement");
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>编辑公告</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 5 CSS -->
    <link href="<%=request.getContextPath()%>/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="<%=request.getContextPath()%>/css/fontawesome/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/fontawesome/css/svg-with-js.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/style.css" rel="stylesheet">
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
                    <a class="nav-link" href="<%=request.getContextPath()%>/"><i class="fas fa-home"></i> 首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/topic"><i class="fas fa-book"></i> 群书</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/post"><i class="fas fa-edit"></i> 回字</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<%=request.getContextPath()%>/manage"><i class="fas fa-cog"></i> 管理</a>
                </li>
            </ul>

            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="#"><i class="fas fa-user"></i> <%=user.getUsername()%></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/logout">
                        <i class="fas fa-sign-out-alt"></i> 退出
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-edit"></i> 编辑公告
                    </h5>
                </div>
                <div class="card-body">
                    <form action="<%=request.getContextPath()%>/announcement/update" method="post">
                        <input type="hidden" name="announcementId" value="<%=announcement.getAnnouncementId()%>">
                        
                        <div class="mb-3">
                            <label for="title" class="form-label">
                                <i class="fas fa-heading"></i> 标题
                            </label>
                            <input type="text" class="form-control" id="title" name="title"
                                   value="<%=announcement.getTitle()%>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="content" class="form-label">
                                <i class="fas fa-align-left"></i> 内容
                            </label>
                            <textarea class="form-control" id="content" name="content"
                                      rows="5" required><%=announcement.getContent()%></textarea>
                        </div>
                        
                        <div class="mb-4">
                            <label for="priority" class="form-label">
                                <i class="fas fa-star"></i> 优先级
                            </label>
                            <select class="form-select" id="priority" name="priority">
                                <option value="0" <%=announcement.getPriority() == 0 ? "selected" : ""%>>普通</option>
                                <option value="1" <%=announcement.getPriority() == 1 ? "selected" : ""%>>重要</option>
                                <option value="2" <%=announcement.getPriority() == 2 ? "selected" : ""%>>紧急</option>
                            </select>
                        </div>
                        
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> 保存修改
                            </button>
                            <a href="<%=request.getContextPath()%>/manage" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> 返回
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS 和 Popper.js -->
<script src="<%=request.getContextPath()%>/js/popper.min.js"></script>
<script src="<%=request.getContextPath()%>/js/bootstrap.min.js"></script>
<script src="<%=request.getContextPath()%>/css/fontawesome/js/all.min.js"></script>
</body>
</html> 
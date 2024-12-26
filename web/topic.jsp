<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="zly.design.jsp.model.Topic" %>
<%@ page import="zly.design.jsp.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>群书列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
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
                    <a class="nav-link" href="<%=request.getContextPath()%>/"><i class="fas fa-home"></i> 首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<%=request.getContextPath()%>/topic"><i class="fas fa-book"></i> 群书</a>
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
                           placeholder="搜索..." aria-label="Search">
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
                <li class="nav-item">
                    <a class="nav-link" href="#"><i class="fas fa-user"></i> <%=user.getUsername()%></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/logout">
                        <i class="fas fa-sign-out-alt"></i> 退出
                    </a>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-4">
    <%
        String error = (String)request.getAttribute("error");
        String success = (String)request.getAttribute("success");
        if(error != null) {
    %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle"></i> <%=error%>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <% if(success != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle"></i> <%=success%>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <% if(user != null && user.isAdmin()) { %>
            <button class="btn btn-primary mb-4" data-bs-toggle="modal" data-bs-target="#addTopicModal">
                <i class="fas fa-plus-circle"></i> 创建新群书
            </button>
            <% } %>

            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="card-title mb-0"><i class="fas fa-list"></i> 所有群书</h5>
                </div>
                <div class="card-body">
                    <div class="topic-container">
                        <% List<Topic> topics = (List<Topic>)request.getAttribute("topics");
                            if(topics != null && !topics.isEmpty()) {
                                for(Topic topic : topics) { %>
                        <div class="topic-card">
                            <div class="card h-100">
                                <div class="card-body">
                                    <div class="topic-content">
                                        <div class="topic-info">
                                            <h5 class="card-title mb-3">
                                                <i class="fas fa-book text-primary"></i> <%=topic.getName()%>
                                            </h5>
                                            <p class="card-text mb-3"><%=topic.getDescription()%></p>
                                            <small class="text-muted">
                                                <i class="fas fa-clock"></i> 创建时间：<%=topic.getCreateTime()%>
                                            </small>
                                        </div>
                                        <div class="topic-actions">
                                            <div class="d-grid gap-2">
                                                <a href="<%=request.getContextPath()%>/?topic=<%=topic.getTopicId()%>"
                                                   class="btn btn-primary">
                                                    <i class="fas fa-eye"></i> 查看字块
                                                </a>
                                                <% if(user != null && user.isAdmin()) { %>
                                                <form action="<%=request.getContextPath()%>/topic/delete" method="post">
                                                    <input type="hidden" name="topicId" value="<%=topic.getTopicId()%>">
                                                    <button type="submit" class="btn btn-danger w-100"
                                                            onclick="return confirm('确定要删除这个群书吗？相关的字块将会被取消群书关联')">
                                                        <i class="fas fa-trash"></i> 删除群书
                                                    </button>
                                                </form>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% }
                        } else { %>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i> 目前还没有任何群书。
                            <% if(user != null && user.isAdmin()) { %>
                            <a href="#" data-bs-toggle="modal" data-bs-target="#addTopicModal">创建第一个群书</a>
                            <% } %>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 添加群书的模态框 -->
<div class="modal fade" id="addTopicModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-plus-circle"></i> 创建新群书</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%=request.getContextPath()%>/topic/add" method="post" id="addTopicForm">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="topicName" class="form-label">
                            <i class="fas fa-heading"></i> 群书名称
                        </label>
                        <input type="text" class="form-control" id="topicName" name="name" required
                               maxlength="100" placeholder="请输入群书名称">
                    </div>
                    <div class="mb-3">
                        <label for="topicDescription" class="form-label">
                            <i class="fas fa-align-left"></i> 群书描述
                        </label>
                        <textarea class="form-control" id="topicDescription" name="description"
                                  rows="3" required maxlength="500"
                                  placeholder="请输入群书描述"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times"></i> 取消
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-check"></i> 创建
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS 和 Popper.js -->
<script src="js/popper.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="css/fontawesome/js/all.min.js"></script>
<script>
    // 自动隐藏提示消息
    document.addEventListener('DOMContentLoaded', function() {
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 3000);
    });

    // 表单验证
    document.getElementById('addTopicForm').addEventListener('submit', function(e) {
        var name = document.getElementById('topicName').value.trim();
        var description = document.getElementById('topicDescription').value.trim();

        if(name === '' || description === '') {
            e.preventDefault();
            alert('群书名称和描述不能为空！');
            return false;
        }

        if(name.length > 100) {
            e.preventDefault();
            alert('群书名称不能超过100个字符！');
            return false;
        }

        if(description.length > 500) {
            e.preventDefault();
            alert('群书描述不能超过500个字符！');
            return false;
        }
    });
</script>
</body>
</html>
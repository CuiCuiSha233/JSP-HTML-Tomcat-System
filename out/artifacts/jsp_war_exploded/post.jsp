<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="zly.design.jsp.model.Topic" %>
<%@ page import="zly.design.jsp.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>发布字块</title>
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
                    <a class="nav-link" href="<%=request.getContextPath()%>/topic"><i class="fas fa-book"></i> 群书</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<%=request.getContextPath()%>/post"><i class="fas fa-edit"></i> 回字</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/manage"><i class="fas fa-cog"></i> 管理</a>
                </li>
            </ul>

            <ul class="navbar-nav">
                <% User user = (User)session.getAttribute("user"); %>
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

<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-pen-to-square text-primary"></i> 发布新字块
                    </h5>
                </div>
                <div class="card-body">
                    <form action="<%=request.getContextPath()%>/post/add" method="post" accept-charset="UTF-8">
                        <div class="mb-3">
                            <label for="title" class="form-label">
                                <i class="fas fa-heading"></i> 标题
                            </label>
                            <input type="text" class="form-control" id="title" name="title"
                                   required maxlength="100" placeholder="请输入标题">
                        </div>
                        <div class="mb-3">
                        <label for="content" class="form-label">
                            <i class="fas fa-align-left"></i> 内容
                        </label>
                        <textarea class="form-control" id="content" name="content"
                                  rows="10" required
                                  placeholder="请输入内容..."
                                  style="white-space: pre-line;"
                        ></textarea>
                        <div class="form-text">
                            <i class="fas fa-info-circle"></i> 支持换行，最多1000字
                        </div>
                    </div>
                        <div class="mb-4">
                            <label for="topicId" class="form-label">
                                <i class="fas fa-tags"></i> 群书（可选）
                            </label>
                            <select class="form-select" id="topicId" name="topicId">
                                <option value="">选择群书</option>
                                <%
                                    List<Topic> topics = (List<Topic>)request.getAttribute("topics");
                                    if(topics != null && !topics.isEmpty()) {
                                        for(Topic topic : topics) {
                                %>
                                <option value="<%=topic.getTopicId()%>"><%=topic.getName()%></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane"></i> 发布字块
                            </button>
                        </div>
                    </form>
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
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="zly.design.jsp.model.Post" %>
<%@ page import="zly.design.jsp.model.User" %>
<%@ page import="zly.design.jsp.model.Announcement" %>
<!DOCTYPE html>
<html>
<head>
    <title>内容管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 5 CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="<%=request.getContextPath()%>/css/fontawesome/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/fontawesome/css/svg-with-js.min.css" rel="stylesheet">
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
                    <a class="nav-link" href="<%=request.getContextPath()%>/post"><i class="fas fa-edit"></i> 回字</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<%=request.getContextPath()%>/manage"><i class="fas fa-cog"></i> 管理</a>
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
    <div class="row">
        <div class="col-12">
            <!-- Tab导航 -->
            <ul class="nav nav-tabs mb-4" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="posts-tab" data-bs-toggle="tab"
                            data-bs-target="#posts" type="button" role="tab">
                        <i class="fas fa-file-lines"></i> 字块管理
                    </button>
                </li>
                <% if(user.isAdmin()) { %>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="announcements-tab" data-bs-toggle="tab"
                            data-bs-target="#announcements" type="button" role="tab">
                        <i class="fas fa-bullhorn"></i> 公告管理
                    </button>
                </li>
                <% } %>
            </ul>

            <!-- Tab内容 -->
            <div class="tab-content" id="myTabContent">
                <!-- 字块管理面板 -->
                <div class="tab-pane fade show active" id="posts" role="tabpanel">
                    <div class="card shadow-sm">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-list text-primary"></i>
                                <%=user.isAdmin() ? "所有字块管理" : "我的字块管理"%>
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <colgroup>
                                        <col style="width: 20%">
                                        <col style="width: 35%">
                                        <col style="width: 15%">
                                        <col style="width: 15%">
                                        <col style="width: 15%">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>标题</th>
                                        <th>内容摘要</th>
                                        <th>作者</th>
                                        <th>发布时间</th>
                                        <th>操作</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% List<Post> posts = (List<Post>)request.getAttribute("posts");
                                        if(posts != null) {
                                            for(Post post : posts) {
                                                if(user.isAdmin() || user.getUserId() == post.getUserId()) { %>
                                    <tr>
                                        <td><%=post.getTitle()%></td>
                                        <td>
                                            <div class="content-preview">
                                                <%=post.getContent().length() > 50 ?
                                                        post.getContent().substring(0,50) + "..." :
                                                        post.getContent()%>
                                            </div>
                                        </td>
                                        <td>
                                            <i class="fas fa-user-circle"></i> <%=post.getUsername()%>
                                        </td>
                                        <td>
                                            <%=post.getCreateTime()%>
                                        </td>
                                        <td>
                                            <form action="<%=request.getContextPath()%>/post/delete"
                                                  method="post" class="d-inline">
                                                <input type="hidden" name="postId" value="<%=post.getPostId()%>">
                                                <button type="submit" class="btn btn-danger btn-sm"
                                                        onclick="return confirm('确定要删除这篇字块吗？')">
                                                    <i class="fas fa-trash"></i> 删除
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <%      }
                                    }
                                    } %>
                                    </tbody>
                                </table>
                            </div>

                            <!-- 字块分页 -->
                            <nav aria-label="Page navigation" class="d-flex justify-content-center mt-4">
                                <ul class="pagination">
                                    <%
                                        int currentPage = (Integer)request.getAttribute("currentPage");
                                        int totalPages = (Integer)request.getAttribute("totalPages");
                                        if(currentPage > 1) { %>
                                    <li class="page-item">
                                        <a class="page-link" href="?page=<%=currentPage - 1%>">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>
                                    <% }
                                        for(int i = 1; i <= totalPages; i++) { %>
                                    <li class="page-item <%=i == currentPage ? "active" : ""%>">
                                        <a class="page-link" href="?page=<%=i%>"><%=i%></a>
                                    </li>
                                    <% }
                                        if(currentPage < totalPages) { %>
                                    <li class="page-item">
                                        <a class="page-link" href="?page=<%=currentPage + 1%>">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                    <% } %>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>

                <!-- 公告管理面板 -->
                <% if(user.isAdmin()) { %>
                <div class="tab-pane fade" id="announcements" role="tabpanel">
                    <div class="card shadow-sm">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-bullhorn text-primary"></i> 公告管理
                            </h5>
                            <button type="button" class="btn btn-primary btn-sm"
                                    data-bs-toggle="modal" data-bs-target="#addAnnouncementModal">
                                <i class="fas fa-plus-circle"></i> 发布新公告
                            </button>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <colgroup>
                                        <col style="width: 20%">
                                        <col style="width: 35%">
                                        <col style="width: 15%">
                                        <col style="width: 15%">
                                        <col style="width: 15%">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>标题</th>
                                        <th>内容摘要</th>
                                        <th>优先级</th>
                                        <th>发布时间</th>
                                        <th>操作</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% List<Announcement> announcements = (List<Announcement>)request.getAttribute("announcements");
                                        if(announcements != null) {
                                            for(Announcement announcement : announcements) { %>
                                    <tr>
                                        <td><%=announcement.getTitle()%></td>
                                        <td>
                                            <div class="content-preview">
                                                <%=announcement.getContent().length() > 50 ?
                                                        announcement.getContent().substring(0,50) + "..." :
                                                        announcement.getContent()%>
                                            </div>
                                        </td>
                                        <td>
                                            <% switch(announcement.getPriority()) {
                                                case 0: %><span class="badge bg-info">普通</span><% break;
                                            case 1: %><span class="badge bg-warning text-dark">重要</span><% break;
                                            case 2: %><span class="badge bg-danger">紧急</span><% break;
                                        } %>
                                        </td>
                                        <td>
                                            <%=announcement.getCreateTime()%>
                                        </td>
                                        <td>
                                            <div class="btn-group">
                                                <button type="button" class="btn btn-sm btn-primary"
                                                        onclick="editAnnouncement(<%=announcement.getAnnouncementId()%>, 
                                                            '<%=java.net.URLEncoder.encode(announcement.getTitle(), "UTF-8")%>', 
                                                            '<%=java.net.URLEncoder.encode(announcement.getContent(), "UTF-8")%>', 
                                                            <%=announcement.getPriority()%>)">
                                                    编辑
                                                </button>
                                                <form action="<%=request.getContextPath()%>/announcement/delete" method="post" style="display:inline;">
                                                    <input type="hidden" name="announcementId" value="<%=announcement.getAnnouncementId()%>">
                                                    <button type="submit" class="btn btn-sm btn-danger"
                                                            onclick="return confirm('确定要删除这条公告吗？')">
                                                        删除
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                    <%  }
                                    } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- 添加公告的模态框 -->
<div class="modal fade" id="addAnnouncementModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-plus-circle text-primary"></i> 发布新公告
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%=request.getContextPath()%>/announcement/add" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="title" class="form-label">
                            <i class="fas fa-heading"></i> 标题
                        </label>
                        <input type="text" class="form-control" id="title" name="title"
                               required maxlength="100" placeholder="请输入公告标题">
                    </div>
                    <div class="mb-3">
                        <label for="content" class="form-label">
                            <i class="fas fa-align-left"></i> 内容
                        </label>
                        <textarea class="form-control" id="content" name="content"
                                  rows="5" required maxlength="500"
                                  style="white-space: pre-line; min-height: 150px;"
                                  placeholder="请输入公告内容..."></textarea>
                        <div class="form-text">
                            <i class="fas fa-info-circle"></i> 支持换行，最多500字
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="priority" class="form-label">
                            <i class="fas fa-flag"></i> 优先级
                        </label>
                        <select class="form-select" id="priority" name="priority">
                            <option value="0">普通</option>
                            <option value="1">重要</option>
                            <option value="2">紧急</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times"></i> 取消
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i> 发布
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 在文件末尾，添加编辑公告的模态框 -->
<div class="modal fade" id="editAnnouncementModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-edit text-primary"></i> 编辑公告
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%=request.getContextPath()%>/announcement/update" method="post">
                <div class="modal-body">
                    <input type="hidden" id="edit_announcementId" name="announcementId">
                    <div class="mb-3">
                        <label for="edit_title" class="form-label">标题</label>
                        <input type="text" class="form-control" id="edit_title" name="title"
                               required maxlength="100">
                    </div>
                    <div class="mb-3">
                        <label for="edit_content" class="form-label">内容</label>
                        <textarea class="form-control" id="edit_content" name="content"
                                  rows="5" required maxlength="500"
                                  style="white-space: pre-line; min-height: 150px;"></textarea>
                        <div class="form-text">支持换行，最多500字</div>
                    </div>
                    <div class="mb-3">
                        <label for="edit_priority" class="form-label">优先级</label>
                        <select class="form-select" id="edit_priority" name="priority">
                            <option value="0">普通</option>
                            <option value="1">重要</option>
                            <option value="2">紧急</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS 和 Popper.js -->
<script src="<%=request.getContextPath()%>/js/popper.min.js"></script>
<script src="<%=request.getContextPath()%>/js/bootstrap.min.js"></script>
<script src="<%=request.getContextPath()%>/css/fontawesome/js/all.min.js"></script>
<script>
function editAnnouncement(id, title, content, priority) {
    console.log('Editing announcement:', { id, title, content, priority });
    // 设置表单值
    document.getElementById('edit_announcementId').value = id;
    document.getElementById('edit_title').value = decodeURIComponent(title);
    document.getElementById('edit_content').value = decodeURIComponent(content.replace(/\\n/g, '\n'));
    document.getElementById('edit_priority').value = priority;
    
    // 显示模态框
    new bootstrap.Modal(document.getElementById('editAnnouncementModal')).show();
}
</script>
</body>
</html>
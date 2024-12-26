<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="zly.design.jsp.model.Announcement" %>
<%
    Announcement announcement = (Announcement) request.getAttribute("announcement");
%>
<!DOCTYPE html>
<html>
<head>
    <title>编辑公告</title>
    <jsp:include page="../components/head.jsp"/>
</head>
<body class="bg-light">
<jsp:include page="../components/nav.jsp"/>

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

<jsp:include page="../components/footer.jsp"/>
</body>
</html> 
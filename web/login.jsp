<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>登录/注册</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 5 CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="css/fontawesome/css/all.min.css" rel="stylesheet">
    <link href="css/fontawesome/css/svg-with-js.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
<div class="gradient-bg"></div>
<div class="container py-5 login-container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm login-card">
                <div class="card-body p-4">
                    <!-- 系统标题 -->
                    <div class="text-center mb-4">
                        <h3 class="text-primary">
                            <i class="fas fa-comments"></i> 社区问答系统-者也
                        </h3>
                        <p class="text-muted">欢迎回来，请登录或注册新账号</p>
                    </div>

                    <!-- 错误提示 -->
                    <% String error = (String)request.getAttribute("error");
                        if(error != null && !error.isEmpty()) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> <%=error%>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <!-- 标签页导航 -->
                    <ul class="nav nav-tabs nav-fill mb-4" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#login" type="button">
                                <i class="fas fa-sign-in-alt"></i> 登录
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#register" type="button">
                                <i class="fas fa-user-plus"></i> 注册
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content">
                        <!-- 登录表单 -->
                        <div class="tab-pane fade show active" id="login" role="tabpanel">
                            <form action="<%=request.getContextPath()%>/login" method="post">
                                <div class="mb-3">
                                    <label class="form-label">
                                        <i class="fas fa-user"></i> 用户名
                                    </label>
                                    <input type="text" class="form-control" name="username"
                                           required maxlength="20" placeholder="请输入用户名">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">
                                        <i class="fas fa-lock"></i> 密码
                                    </label>
                                    <input type="password" class="form-control" name="password"
                                           required maxlength="20" placeholder="请输入密码">
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">
                                        <i class="fas fa-shield-alt"></i> 验证码
                                    </label>
                                    <div class="d-flex gap-2">
                                        <input type="text" class="form-control" name="captcha"
                                               required maxlength="4" placeholder="请输入验证码"
                                               style="width: 60%;">
                                        <div class="captcha-container">
                                            <img src="<%=request.getContextPath()%>/captcha"
                                                 class="img-fluid rounded" style="cursor: pointer;"
                                                 onclick="this.src='<%=request.getContextPath()%>/captcha?'+Math.random()"
                                                 alt="验证码">
                                        </div>
                                    </div>
                                </div>
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-sign-in-alt"></i> 登录
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- 注册表单 -->
                        <div class="tab-pane fade" id="register" role="tabpanel">
                            <form action="<%=request.getContextPath()%>/register" method="post">
                                <div class="mb-3">
                                    <label class="form-label">
                                        <i class="fas fa-user"></i> 用户名
                                    </label>
                                    <input type="text" class="form-control" name="username"
                                           required maxlength="20" placeholder="请输入用户名">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">
                                        <i class="fas fa-lock"></i> 密码
                                    </label>
                                    <input type="password" class="form-control" name="password"
                                           required maxlength="20" placeholder="请输入密码">
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">
                                        <i class="fas fa-shield-alt"></i> 验证码
                                    </label>
                                    <div class="d-flex gap-2">
                                        <input type="text" class="form-control" name="captcha"
                                               required maxlength="4" placeholder="请输入验证码"
                                               style="width: 60%;">
                                        <div class="captcha-container">
                                            <img src="<%=request.getContextPath()%>/captcha"
                                                 class="img-fluid rounded" style="cursor: pointer;"
                                                 onclick="this.src='<%=request.getContextPath()%>/captcha?'+Math.random()"
                                                 alt="验证码">
                                        </div>
                                    </div>
                                </div>
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-user-plus"></i> 注册
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <br>
                    <p class="text-center text-muted">Copyright © 2024 <a class="link" title="Yebken" href="https://yebken.cn/" target="_blank">Yebken</a> All Rights Reserved.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS 和 Popper.js -->
<script src="js/popper.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="css/fontawesome/js/all.min.js"></script>

<script>
    // 更新颜色数组
    const colors = [
        '#FF6B6B', '#4ECDC4', '#45B7D1', '#A06CD5', '#F7D794',
        '#786FA6', '#F8C291', '#00D2D3', '#EA8685', '#63CDDA',
        '#FD7272', '#58B19F', '#3DC1D3', '#9B59B6', '#F6B93B',
        '#6C5CE7', '#E66767', '#2BCBBA', '#FF9FF3', '#45AAF2',
        '#D6A2E8', '#82CCDD', '#B8E994', '#F8C291', '#6AB04C',
        '#C4E538', '#7ED6DF', '#E056FD', '#686DE0', '#30336B'
    ];

    function updateGradient() {
        // 随机选择8个颜色
        const selectedColors = [];
        const usedIndices = new Set();

        while(selectedColors.length < 8) {
            const randomIndex = Math.floor(Math.random() * colors.length);
            if(!usedIndices.has(randomIndex)) {
                usedIndices.add(randomIndex);
                selectedColors.push(colors[randomIndex]);
            }
        }

        // 更新渐变背景
        document.querySelector('.gradient-bg').style.background =
            `linear-gradient(125deg, ${selectedColors.join(', ')})`;
    }

    // 每20秒更新一次颜色
    setInterval(updateGradient, 20000);
    updateGradient(); // 初始化颜色

    // 添加鼠标移动效果
    document.addEventListener('mousemove', (e) => {
        const x = e.clientX / window.innerWidth;
        const y = e.clientY / window.innerHeight;

        document.querySelector('.gradient-bg').style.backgroundPosition =
            `${x * 100}% ${y * 100}%`;
    });
</script>

</body>
</html>
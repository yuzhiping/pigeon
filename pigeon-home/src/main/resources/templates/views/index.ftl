<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>首页</title>
    <script src="https://cdn.jsdelivr.net/npm/vue@2.5.17/dist/vue.js"></script>
    <script src="/js/jquery-3.3.1.min.js"></script>
    <script src="/js/common.js"></script>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <!-- 引入组件库 -->
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
    <link rel="stylesheet" href="/css/index.css">
    <link rel="stylesheet" href="/css/common.css">
</head>

<body>
<div id="app" v-cloak>
    <el-container>
        <el-header>
            <div class="header clearfix">
                <div class="right">
                    <el-button type="text" @click="dialogTeamVisible = true">添加</el-button>
                </div>
            </div>
        </el-header>
        <el-container>
            <el-aside width="0px"></el-aside>
            <el-container>
                <el-main>
                    <div class="content">
                        <el-tabs v-model="activeGroupName" @tab-click="handleClick">
                            <el-tab-pane label="我关注的" name="first"></el-tab-pane>
                            <el-tab-pane label="所有团队" name="second"></el-tab-pane>
                            <div class="card-list clearfix">
                                <div class="card-wrapper clearfix" v-for="(item, index) in projectsList" :key="index">
                                    <el-card class="box-card">
                                        <div slot="header" class="clearfix">
                                            <el-button type="text" @click="editTeam(item.groupNo)" v-if="[-1, 1, 2].includes(item.roleType)">编辑</el-button>
                                            <el-button type="text" @click="deleteTeam(item.groupNo)">删除</el-button>
                                            <el-button type="text" @click="changeFocusStatus(item.groupNo, item.userFollow)">{{item.userFollow ? "已关注" : "关注"}}</el-button>
                                        </div>
                                        <div @click="goDetail(item.groupNo)">
                                            <p>{{item.groupName}}</p>
                                            <p>{{item.groupDesc}}</p>
                                        </div>
                                    </el-card>
                                </div>
                            </div>
                            <div v-show="!pullRefreshss && !loadEnd" style="text-align: center">加载中</div>
                            <div v-show="loadEnd" style="text-align: center">暂无更多</div>
                        </el-tabs>
                    </div>
                </el-main>
                <el-footer></el-footer>
            </el-container>
        </el-container>
    </el-container>
	<div class="add-team">
        <el-dialog title="添加/编辑团队" :visible.sync="dialogTeamVisible" @close="cleanTeam">
            <el-form :model="team">
                <el-form-item label="名称" :label-width="formLabelWidth">
                    <el-input v-model="team.name" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="描述" :label-width="formLabelWidth">
                    <el-input type="textarea" :rows="2" placeholder="请输入内容" v-model="team.desc"></el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="saveTeam">保存</el-button>
            </div>
        </el-dialog>
	</div>
</div>
<script>
    var app = new Vue({
        el: '#app',
        data: function() {
            return {
                message: 'hi',
                num: 10,
                activeGroupName: 'first',
	            projectsList: [],
                formLabelWidth: '120px',
                dialogTeamVisible: false,
                team: {
                    no: '',
                    name: '',
                    desc: ''
                },
	            // true代表可上拉加载
                pullRefreshss: true,
	            pageNumber: 1,
	            scrollY: null,
                totalCount: 1,
	            totalPages: 1,
                loadEnd: false,
                groupRoleItems: []
            }
        },
        created: function() {
            this.pullRefresh();
        },
	    mounted: function() {
            var self = this
            if(sessionStorage.getItem("activeGroupName")) {
                self.activeGroupName = sessionStorage.getItem("activeGroupName")
            }
            self.getGroup()
	    },
        methods: {
            handleClick: function(tab, event) {
                this.activeGroupName = tab.name
                sessionStorage.setItem("activeGroupName", this.activeGroupName)
	            this.getGroup()
            },
            // 跳转到详情页
            goDetail: function (groupNo) {
                location.href = "/detail?groupNo=" + groupNo
            },
            // 编辑团队
            editTeam: function (groupNo) {
                var self = this
                $.ajax({
                    url: "/rest/group/getgroupbyno?groupNo=" + groupNo,
                    success: function (data) {
                        if (data.code === "0" && data.data) {
                            self.team.no = data.data.groupNo
                            self.team.name = data.data.groupName
                            self.team.desc = data.data.groupDesc
                            self.dialogTeamVisible = true
                        } else {
                            self.$message.error(data.message)
                        }
                    }
                })
            },
            // 添加团队
            saveTeam: function () {
                var self = this
                if (!self.team.name) {
                    self.$message.error("团队名称为必填项")
                    return
                }
                var postData = {
                    groupName: self.team.name,
                    groupDesc: self.team.desc,
                    groupNo: self.team.no
                }
                $.ajax({
                    type: "post",
                    contentType: "application/json",
                    url: "/rest/group/addupdategroup",
                    data: JSON.stringify(postData),
                    success: function (data) {
                        if (data.code === "0") {
                            if (self.team.no) {
                                self.$message.success("修改成功!")
                            } else {
                                self.$message.success("添加成功!")
                            }
                            self.getGroup()
                            self.dialogTeamVisible = false
                        } else {
                            self.$message.error(data.message)
                        }
                    }
                })
            },
            // 清空弹窗中的数据
            cleanTeam: function () {
                this.team = cleanParams(this.team)
            },
            // 删除团队
            deleteTeam: function (groupNo) {
                var self = this
                $.ajax({
                    url: "/rest/group/deletegroup?groupNo=" + groupNo,
                    success: function (data) {
                        if (data.code === "0") {
                            self.$message.success("删除成功!")
                        } else {
                            self.$message.error(data.message)
                        }
                        self.getGroup()
                    }
                })
            },
	        // 关注/取消关注团队
            changeFocusStatus: function (groupNo, userFollow) {
                var self = this
	            if (!userFollow) {
                    $.ajax({
                        url: "/rest/follow/follow?groupNo=" + groupNo,
                        success: function (data) {
                            if (data.code === "0") {
                                self.$message.success("关注成功!")
                            } else {
                                self.$message.error(data.message)
                            }
                            self.getGroup()
                        }
                    })
	            } else {
                    $.ajax({
                        url: "/rest/follow/cancelfollow?groupNo=" + groupNo,
                        success: function (data) {
                            if (data.code === "0") {
                                self.$message.success("取消关注成功!")
                            } else {
                                self.$message.error(data.message)
                            }
                            self.getGroup()
                        }
                    })
	            }
            },
            // 请求团队列表
            getGroup: function (more) {
                var self = this
	            var allUrl = "/rest/group/pagegroup"
	            var followUrl = "/rest/follow/userfollows"
                if (!more) {
                    self.projectsList = []
                    self.pageNumber = 1
                    self.totalPages = 1
                    self.loadEnd = false
                }
                if (!self.pullRefreshss || self.loadEnd) {
                    return
                }
                self.pullRefreshss = false
                var postData = {
                    pageNumber: self.pageNumber,
	                pageSize: 12
                }
                $.ajax({
                    type: "post",
                    contentType: "application/json",
                    url: (self.activeGroupName === "second") ? allUrl : followUrl,
                    data: JSON.stringify(postData),
                    success: function (data) {
                        self.pullRefreshss = true
                        if (data.code === "0" && data.data) {
                            self.totalCount = data.data.totalCount
                            if (self.pageNumber === data.data.totalPages) {
                                self.loadEnd = true
                            }
                            self.projectsList = self.projectsList.concat(data.data.results)
	                        self.pageNumber++
                        } else {
                            self.$message.error(data.message)
                        }
                    },
                    error: function () {
                        self.pullRefreshss = true
                    }
                })
            },
            //文档的总高度
            getScrollTop: function () {
                var scrollTop = 0, bodyScrollTop = 0, documentScrollTop = 0;
                if (document.body) {
                    bodyScrollTop = document.body.scrollTop;
                }
                if (document.documentElement) {
                    documentScrollTop = document.documentElement.scrollTop;
                }
                scrollTop = (bodyScrollTop - documentScrollTop > 0) ? bodyScrollTop : documentScrollTop;
                return scrollTop;
            },
            //浏览器视口的高度
            getScrollHeight: function () {
                var scrollHeight = 0, bodyScrollHeight = 0, documentScrollHeight = 0;
                if (document.body) {
                    bodyScrollHeight = document.body.scrollHeight;
                }
                if (document.documentElement) {
                    documentScrollHeight = document.documentElement.scrollHeight;
                }
                scrollHeight = (bodyScrollHeight - documentScrollHeight > 0) ? bodyScrollHeight : documentScrollHeight;
                return scrollHeight;
            },
            //浏览器视口的高度
            getWindowHeight: function () {
                var windowHeight = 0;
                if (document.compatMode == "CSS1Compat") {
                    windowHeight = document.documentElement.clientHeight;
                } else {
                    windowHeight = document.body.clientHeight;
                }
                return windowHeight;
            },
            // 下拉加载ajax
            pullRefresh: function () {
                var _this = this;
                window.onscroll = function () {
                    _this.scrollChange()
                }
            },
            scrollChange: function () {
                var _this = this
                this.scollY = this.getScrollTop() + this.getWindowHeight() - this.getScrollHeight();
                // 把下拉刷新置为false，防止多次请求
                if (this.scollY >= -50) {
                    if (!this.pullRefreshss) {
                        return false;
                    }
                    // 模拟ajax请求
                    setTimeout(_this.getGroup(true), 2000)
                    _this.pullRefreshss = false;
                } else {
                    // 其他时候把下拉刷新置为true
                    _this.pullRefreshss = true;
                }
            }
        }
    })
</script>
</body>

</html>
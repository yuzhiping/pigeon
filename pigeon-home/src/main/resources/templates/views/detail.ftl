<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>详情页</title>
    <script src="https://cdn.jsdelivr.net/npm/vue@2.5.17/dist/vue.js"></script>
    <script src="/js/jquery-3.3.1.min.js"></script>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <!-- 引入组件库 -->
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
    <script src="/js/common.js"></script>
    <link rel="stylesheet" href="/css/common.css">
</head>

<body>
<div id="app" v-cloak>
    <div class="header clearfix">
        <div>
            <el-button type="text" @click="backHome()">首页/${groupName!}</el-button>
        </div>
    </div>
    <div class="content">
        <el-tabs v-model="activeName" @tab-click="handleTabClick">
            <el-tab-pane label="任务列表" name="first"></el-tab-pane>
            <el-tab-pane label="成员管理" name="second"></el-tab-pane>
			<div class="team-list" v-if="activeName === 'first'">
                <el-button style="padding: 8px 20px;margin-bottom: 10px;" @click="dialogTaskVisible = true">新增</el-button>
                <el-table :data="taskList" :key="1" border style="width: 100%">
                    <el-table-column prop="jobName" label="任务名称"></el-table-column>
                    <el-table-column prop="jobDesc" label="任务描述"></el-table-column>
                    <el-table-column prop="invokeType" label="调用类型" :formatter="formatterInvokeType"></el-table-column>
                    <el-table-column prop="cronExpression" label="定时时间"></el-table-column>
                    <el-table-column prop="lastExecuteResult" :formatter="formatterExecuteResult" label="上次执行结果"></el-table-column>
                    <el-table-column prop="lastExecuteTime" :formatter="formatterTime" label="上次执行时间"></el-table-column>
                    <el-table-column prop="nextExecuteTime" :formatter="formatterTime" label="下次执行时间"></el-table-column>
                    <el-table-column label="操作" width="260px">
                        <template slot-scope="scope">
                            <el-button @click="editTask(scope.$index)" type="text" size="small">编辑</el-button>
                            <el-button @click="deleteTask(scope.$index)" type="text" size="small">删除</el-button>
                            <el-button @click="openTip(scope.$index)" type="text" size="small">{{taskList[scope.$index].jobStatus ? "停止" : "启动"}}</el-button>
                            <el-button @click="doTask(scope.$index)" type="text" size="small">执行</el-button>
                            <el-button type="text" size="small" @click="goLog(taskList[scope.$index].jobNo)">执行记录</el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <div class="pagination" style="text-align: center; margin-top: 10px;">
                    <el-pagination @size-change="handleSizeChange" :current-page.sync="currentPageTask" @current-change="handleTaskCurrentChange"
                                   :page-size="pageSize" layout="total, prev, pager, next" :total="totalTask">
                    </el-pagination>
                </div>
			</div>
	        <div class="member-manager" v-else>
                <el-button style="padding: 8px 20px;margin-bottom: 10px;" @click="editMember">新增</el-button>
                <el-table :data="memberList" :key="2" border style="width: 100%">
                    <el-table-column prop="userName" label="姓名"></el-table-column>
                    <el-table-column prop="userNo" label="账号"></el-table-column>
                    <el-table-column prop="roleText" label="角色"></el-table-column>
                    <el-table-column label="操作" width="280px">
                        <template slot-scope="scope">
                            <el-button @click="editMember(memberList[scope.$index].userNo)" type="text" size="small">编辑</el-button>
                            <el-button @click="deleteMember(memberList[scope.$index].userNo)" type="text" size="small">删除</el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <div class="pagination" style="text-align: center; margin-top: 10px;">
                    <el-pagination @size-change="handleSizeChange" @current-change="handleMemberCurrentChange" :current-page.sync="currentPageMember"
                                   :page-size="pageSize" layout="total, prev, pager, next" :total="totalMember">
                    </el-pagination>
                </div>
	        </div>
        </el-tabs>
    </div>
    <div class="add-task">
        <el-dialog title="添加/编辑任务" :visible.sync="dialogTaskVisible" @close="cleanTask" width="70%">
            <el-form :model="task">
                <el-form-item label="名称" :label-width="formLabelWidth">
                    <el-input v-model="task.jobName" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="描述" :label-width="formLabelWidth">
                    <el-input type="textarea" :rows="2" placeholder="请输入内容" v-model="task.jobDesc"></el-input>
                </el-form-item>
                <el-form-item label="调用类型" :label-width="formLabelWidth">
                    <el-select v-model="task.invokeType">
                        <el-option label="dubbo" value="1"></el-option>
                        <el-option label="http" value="2"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="定时" :label-width="formLabelWidth">
                    <el-input v-model="task.cronExpression" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="创建人" :label-width="formLabelWidth">
                    <el-input v-model="task.staffCreated" :disabled="true" :placeholder="userNo"></el-input>
                </el-form-item>
                <el-form-item label="统计周期" :label-width="formLabelWidth">
                    <el-select v-model="task.statisticalPeriod" placeholder="请选择统计周期">
                        <el-option label="一天" value="1"></el-option>
                        <el-option label="一周" value="2"></el-option>
                        <el-option label="半月" value="3"></el-option>
                        <el-option label="月" value="4"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="参数" :label-width="formLabelWidth">
                    <el-button size="small" @click="addParams">添加</el-button>
                        <div v-for="(item, index) in task.jobParams" :key="index" v-if="task.hasParam">
                            <el-select size="small" v-model="item.paramType" placeholder="请选择参数类型" style="max-width: 200px">
                                <el-option v-for="(item, index) in typeList" :key="index" :label="item.typeText" :value="item.typeValue"></el-option>
                            </el-select>
                            <el-input size="small" placeholder="请输入参数名" v-model="item.paramName" style="max-width: 200px"></el-input>
                            <el-input size="small"  v-model="item.paramValue" placeholder="请输入参数的值" style="max-width: 200px"></el-input>
                            <i class="el-icon-delete" style="cursor: pointer;" size="small" @click="deleteParams(index)"></i>
                        </div>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="saveTask">保存</el-button>
            </div>
        </el-dialog>
    </div>
    <div class="add-member">
        <el-dialog title="添加/编辑成员" :visible.sync="dialogMemberVisible" @close="cleanMember">
            <el-form :model="member">
                <el-form-item label="账号" :label-width="formLabelWidth">
                    <el-input v-model="member.userNo" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="角色" :label-width="formLabelWidth">
                    <el-select v-model="member.role" placeholder="访客">
                        <el-option label="管理员" value="1"></el-option>
                        <el-option label="开发者" value="2"></el-option>
                        <el-option label="访客" value="3"></el-option>
                    </el-select>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="saveMember">保存</el-button>
            </div>
        </el-dialog>
    </div>
    <el-dialog title="提示" :visible.sync="dialogTipVisible" width="30%">
        <span>确认要{{tipStatus === 1 ? "停止" : "启动"}}？</span>
        <span slot="footer" class="dialog-footer" @close="cleanTipIndex">
            <el-button @click="dialogTipVisible = false">取 消</el-button>
            <el-button type="primary" @click="switchTaskStatus">确 定</el-button>
        </span>
    </el-dialog>

</div>
<script>
    var app = new Vue({
        el: '#app',
        data: function() {
            return {
                activeName: 'first',
                formLabelWidth: '120px',
                dialogTaskVisible: false,
                dialogMemberVisible: false,
                taskList: [],
                memberList: [],
                task: {
                    invokeType: "1",
	                jobParams: [],
                    statisticalPeriod: "1"
                },
                // 参数类型列表
                typeList: [],
                member: {
                    role: '3'
                },
	            pageSize: 5,
                currentPageTask: 1,
	            currentPageMember: 1,
                pageNum: 1,
                requestLock: false,
                totalTask: 0,
                totalMember: 0,
                jobParams: [],
                userNo: "${userNo}",
	            isAdd: false,
                dialogTipVisible: false,
	            tipIndex: -99,
	            tipStatus: -99,
	            // root -1, 管理员 1, 开发者 2
                roleType: 0
            }
        },
        mounted: function() {
            var self = this;
            if(sessionStorage.getItem("activeName")) {
                this.activeName = sessionStorage.getItem("activeName")
            }
            $.ajax({
                type: "post",
                url: "/rest/job/typelist",
                success: function (data) {
                    if (data.data) {
                        self.typeList = data.data.typeList
                    }
                }
            });
            $.ajax({
                url: "/rest/member/getgrouprole",
                success: function (data) {
                    if (data.data) {
                        if (data.data.isRootUser) {
                            self.roleType = -1;
                            return
                        }
                        data.data.groupRoleItems.filter(function (val) {
                            if (val.groupNo === "${groupNo}") {
                                self.roleType = val.roleType
                            }
                        })
                    }
                }
            });
            this.getList()
        },
        methods: {
            // 返回首页
            backHome: function() {
	            location.href = '/'
            },
	        // 切换tab
            handleTabClick: function(tab, event) {
                this.activeName = tab.name;
                sessionStorage.setItem("activeName", this.activeName);
                this.getList(1, true)
            },
	        // 跳转到执行记录页
	        goLog: function (jobNo) {
                location.href = "/joblog?jobNo=" + jobNo
	        },
            // 获取列表 index为页码数  tab为是否是tab切换
            getList: function (index, tab) {
                var self = this;
                var teamUrl = "/rest/job/pagejobinfo";
                var memberUrl = "/rest/member/pagemember";
                self.taskList = [];
                self.memberList = [];
                self.pageNumber = 1;
                if (self.requestLock) {
                    return
                }
                self.requestLock = true;
                var postData = {
                    groupNo: "${groupNo}",
                    pageNumber: index || 1,
                    pageSize: self.pageSize
                };
                $.ajax({
                    type: "post",
                    contentType: "application/json",
                    url: (self.activeName === "second") ? memberUrl : teamUrl,
                    data: JSON.stringify(postData),
                    success: function (data) {
                        self.requestLock = false;
                        if (data.code === "0" && data.data) {
                            if (self.activeName === "second") {
                                self.memberList = data.data.results;
                                self.totalMember = data.data.totalCount
                            } else {
                                self.taskList = data.data.results;
                                self.totalTask = data.data.totalCount
                            }
                        } else {
                            self.$message.error(data.message)
                        }
                    },
                    error: function () {
                        self.requestLock = false
                    }
                })
            },
			// 保存(新增/修改)任务
            saveTask: function () {
	            var self = this;
                var task = self.task;
	            if (task.jobName === "") {
                    self.$message.warning("名称为必填项")
	            }
                else if (task.jobDesc === "") {
                    self.$message.warning("任务描述为必填项")
                }
                else if (task.cronExpression === "") {
                    self.$message.warning("定时为必填项")
                }
                else if (task.statisticalPeriod === "") {
                    self.$message.warning("统计周期为必填项")
                }
                if (task.jobParams && task.jobParams.length) {
                    task.hasParam = true
                } else {
                    task.hasParam = false
                }
                var postData = {
                    groupNo: "${groupNo}",
                    jobNo: task.jobNo,
                    jobName: task.jobName,
                    jobDesc: task.jobDesc,
                    invokeType: task.invokeType,
                    cronExpression: task.cronExpression,
                    jobStatus: task.jobStatus,
                    statisticalPeriod: task.statisticalPeriod,
                    schedulerName: task.schedulerName,
                    hasParam: task.hasParam,
                    jobParams: task.jobParams
                };
                $.ajax({
                    type: "post",
                    url: "/rest/job/addupdatejobinfo",
	                contentType: "application/json",
	                data: JSON.stringify(postData),
                    success: function (data) {
	                    if(data.code === "0") {
	                        if (self.task.jobNo) {
                                self.$message.success("修改成功")
	                        } else {
                                self.$message.success("新增成功")
	                        }
	                        self.getList(self.activeName === "first" ? self.currentPageTask : self.currentPageMember);
                            self.dialogTaskVisible = false
	                    } else {
                            self.$message.error(data.message)
	                    }

                    }
                })
            },
	        // 清除任务弹窗中的数据
	        cleanTask: function () {
                this.task = cleanParams(this.task);
		        this.task.invokeType = "1";
                this.task.statisticalPeriod = "1"
	        },
	        // 编辑任务
	        editTask: function (index) {
                var self = this;
		        if (![-1, 1, 2].includes(self.roleType)) {
                    self.$message.warning("您没有权限!");
		            return
		        }
                $.ajax({
                    url: "/rest/job/getjobinfobyno?jobNo=" + self.taskList[index].jobNo,
                    success: function (data) {
                        if(data.code === "0" && data.data) {
                            self.dialogTaskVisible = true;
                            self.task = data.data;
	                        self.task.statisticalPeriod = self.task.statisticalPeriod + "";
                            self.task.invokeType = self.task.invokeType + ""
                        } else {
                            self.$message.error(data.message)
                        }
                    }
                })
	        },
	        // 删除任务
            deleteTask: function (index) {
                var self = this;
                if (![-1, 1, 2].includes(self.roleType)) {
                    self.$message.warning("您没有权限!");
                    return
                }
	            var groupNo = self.taskList[index].groupNo;
                var jobNo = self.taskList[index].jobNo;
                $.ajax({
                    url: "/rest/job/deljobbyno?groupNo=" + groupNo + "&jobNo=" + jobNo,
                    success: function (data) {
                        if(data.code === "0") {
                            self.$message.success("删除成功!")
                        } else {
                            self.$message.error(data.message)
                        }
                        self.getList(self.activeName === "first" ? self.currentPageTask : self.currentPageMember)
                    }
                })
            },
	        // 执行任务
            doTask: function (index) {
                var self = this;
                if (![-1, 1, 2].includes(self.roleType)) {
                    self.$message.warning("您没有权限!");
                    return
                }
                var jobNo = self.taskList[index].jobNo;
                $.ajax({
                    url: "/rest/job/execution?&jobNo=" + jobNo,
                    success: function (data) {
                        if(data.code === "0") {
                            self.$message.success("执行成功!")
                        } else {
                            self.$message.error(data.message)
                        }
                        self.getList(self.activeName === "first" ? self.currentPageTask : self.currentPageMember)
                    }
                })
            },
            openTip: function (index) {
                if (![-1, 1, 2].includes(this.roleType)) {
                    this.$message.warning("您没有权限!");
                    return
                }
				this.dialogTipVisible = true;
	            this.tipIndex = index;
	            this.tipStatus = this.taskList[this.tipIndex].jobStatus
            },
	        // 切换任务状态
            switchTaskStatus: function () {
                var self = this;
                var jobNo = self.taskList[self.tipIndex].jobNo;
	            // 1代表启动  要启动传1
                var status = self.taskList[self.tipIndex].jobStatus === 1 ? 0 : 1;
                $.ajax({
                    url: "/rest/job/updatestatus?&jobNo=" + jobNo + "&jobStatus=" +status,
                    success: function (data) {
                        if(data.code === "0") {
                            self.taskList[self.tipIndex].jobStatus = status
                        } else {
                            self.$message.error(data.message)
                        }
                        self.getList(self.activeName === "first" ? self.currentPageTask : self.currentPageMember);
                        self.dialogTipVisible = false
                    },
	                error: function () {
                        self.dialogTipVisible = false
                    }
                })
            },
	        // 添加参数
            addParams: function () {
	            this.task.jobParams.push({paramType:'', paramName: '', paramValue: ''});
                this.task.hasParam = true
            },
	        // 删除参数
            deleteParams: function (index) {
                var self = this;
	            var paramNo = self.task.jobParams[index].paramNo;
                $.ajax({
                    url: "/rest/job/delbyparamno?&paramNo=" + paramNo,
                    success: function (data) {
                        if(data.code === "0") {
                            self.task.jobParams.splice(index, 1);
                            if(self.task.jobParams.length === 0) {
                                self.hasParam = false
                            }
                        } else {
                            self.$message.error(data.message)
                        }
                    }
                })
            },
	        // 编辑成员信息
            editMember: function (userNo) {
                var self = this;
                if (![-1, 1].includes(self.roleType)) {
                    self.$message.warning("您没有权限!");
                    return
                }
	            if (typeof userNo !== "string") {
	                self.isAdd = true;
                    self.dialogMemberVisible = true;
		            return
	            }
	            self.isAdd = false;
                $.ajax({
                    url: "/rest/member/getmemberbyno?groupNo=${groupNo}&userNo=" + userNo,
                    success: function (data) {
                        if(data.code === "0" && data.data) {
                            self.member = data.data;
	                        switch (self.member.roleText) {
		                        case "管理员":
                                    self.member.role = "1";
			                        break;
                                case "开发者":
                                    self.member.role = "2";
                                    break;
                                case "访客":
                                    self.member.role = "3";
                                    break;
		                        default:
                                    self.member.role = "0"
                            }
                            self.dialogMemberVisible = true
                        } else {
                            self.$message.error(data.message)
                        }
                    }
                })
            },
            // 保存(新增/修改)成员
            saveMember: function () {
                var self = this;
	            var postData = {
                    groupNo: "${groupNo}",
		            userNo: self.member.userNo,
		            role: self.member.role
	            };
                $.ajax({
                    type: "post",
                    contentType: "application/json",
                    url: self.isAdd ? "/rest/member/newmember" : "/rest/member/updatemember",
                    data: JSON.stringify(postData),
                    success: function (data) {
                        if (data.code === "0") {
                            if (self.isAdd) {
                                self.$message.success("添加成功!")
                            } else {
                                self.$message.success("修改成功!")
                            }
                            self.dialogMemberVisible = false
                        } else {
                            self.$message.error(data.message)
                        }
                        self.getList(self.activeName === "first" ? self.currentPageTask : self.currentPageMember)
                    }
                })
            },
	        // 删除成员
            deleteMember: function (userNo) {
                var self = this;
                if (![-1, 1].includes(self.roleType)) {
                    self.$message.warning("您没有权限!");
                    return
                }
                $.ajax({
                    url: "/rest/member/deletemember?groupNo=${groupNo}&userNo=" + userNo,
                    success: function (data) {
                        if (data.code === "0") {
                            self.$message.success("删除成功!")
                        } else {
                            self.$message.error(data.message)
                        }
                        self.getList(self.activeName === "first" ? self.currentPageTask : self.currentPageMember)
                    }
                })
            },
	        // 清除弹窗中的数据
            cleanMember: function () {
                this.member = cleanParams(this.member)
            },
            handleSizeChange: function (val) {
            },
            handleTaskCurrentChange: function (val) {
                this.getList(val)
            },
            handleMemberCurrentChange: function (val) {
                this.getList(val)
            },
            cleanTipIndex: function () {
              this.tipIndex = -99;
	          this.tipStatus = -99
            },
            // 上次执行结果
            formatterExecuteResult: function (row, column, cellValue) {
                return (cellValue === null) ? "--" : (cellValue ? "成功" : "失败")
            },
            // 添0 时间格式化
            add0: function (m) {
                return m < 10 ? '0' + m : m
            },
            formatterTime: function (row, column, cellValue) {
                if (!cellValue) {
                    return "--"
                }
                var time = new Date(cellValue);
                var y = time.getFullYear();
                var m = time.getMonth()+1;
                var d = time.getDate();
                var h = time.getHours();
                var mm = time.getMinutes();
                var s = time.getSeconds();
                return y+'-'+this.add0(m)+'-'+this.add0(d)+' '+this.add0(h)+':'+this.add0(mm)+':'+this.add0(s);
            },
            formatterInvokeType: function (row, column, cellValue) {
                return cellValue === 1 ? "dubbo" : "http"
            }
        }
    })
</script>
</body>

</html>
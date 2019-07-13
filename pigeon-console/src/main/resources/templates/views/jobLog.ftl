<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    <script src="https://cdn.jsdelivr.net/npm/vue@2.5.17/dist/vue.js"></script>
    <script src="/js/jquery-3.3.1.min.js"></script>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <!-- 引入组件库 -->
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
    <!-- 仅含仪表盘 -->
    <script src="/js/echarts-gauge.js"></script>
    <link rel="stylesheet" href="/css/index.css">
</head>
<body>
<div id="log" style="overflow-x: hidden;">
    <div class="header">
        <span style="cursor: pointer;" onclick="history.back(-1);">返回</span>
    </div>
    <div id="gauge-wrapper" ref="gauge" style="height: 200px;"></div>
    <el-table class="log-list" :data="logList" :cell-style="setCellStyle" border style="width: 100%;">
        <el-table-column prop="logId" label="id" width="80"></el-table-column>
        <el-table-column prop="runningType" :formatter="formatterRunningType" width="80" label="运行类型"></el-table-column>
        <el-table-column prop="schedulingType" :formatter="formatterSchedulingType" width="80"
                         label="调度类型"></el-table-column>
        <el-table-column prop="gmtCreated" :formatter="formatterTime" label="创建时间"></el-table-column>
        <el-table-column prop="executeTime" :formatter="formatterTime" label="执行时间"></el-table-column>
        <el-table-column prop="staffName" label="调度节点/调度人"></el-table-column>
        <el-table-column prop="schedulingResult" :formatter="formatterResult" width="80" label="调度结果"></el-table-column>
        <el-table-column prop="executeResult" :formatter="formatterResult" width="80" label="执行结果"></el-table-column>
        <el-table-column prop="remark" label="备注" :show-overflow-tooltip="true"></el-table-column>
    </el-table>
    <div class="pagination" style="text-align: center; margin-top: 10px;">
        <el-pagination @size-change="handleSizeChange" @current-change="handleMemberCurrentChange"
                       :current-page.sync="currentLogIndex"
                       :page-size="pageSize" layout="total, prev, pager, next" :total="totalCount">
        </el-pagination>
    </div>
</div>
<script>
    var app = new Vue({
        el: '#log',
        data: function () {
            return {
                logList: [],
                currentLogIndex: 1,
                totalCount: 0,
                pageNumber: 1,
                pageSize: 20,
                totalPages: 1,
                successRate: ${successRate} * 100
        }
        },
        mounted: function () {
            const option = {
                tooltip: {
                    formatter: "{a} <br/>{b} : {c}%"
                },
                toolbox: {
                    feature: {
                        restore: {},
                        saveAsImage: {}
                    }
                },
                series: [
                    {
                        name: '业务指标',
                        type: 'gauge',
                        detail: {
                            formatter: '{value}%',
                            textStyle: {
                                fontSize: 20
                            }
                        },
                        data: [{value: this.successRate, name: '成功率'}],
                        radius: '100px',
                        // title
                        title: {
                            textStyle: {
                                fontSize: 14
                            }
                        },
                        // 表盘宽度
                        axisLine: {
                            lineStyle: {
                                color: [[0.2, '#dd5145'], [0.8, '#ffcd43'], [1, '#1fa363']],
                                width: 15
                            }
                        },
                        // 指针
                        pointer: {
                            length: "20px"
                        },
                        // 分割线
                        splitLine: {
                            length: 15,
                            lineStyle: {
                                width: 2
                            }
                        }
                    }
                ]
            };
            this.$nextTick(function () {
                var myGauge = echarts.init(this.$refs.gauge);
                if (option && typeof option === "object") {
                    myGauge.setOption(option, true);
                }
            });
            this.getLogList()
        },
        methods: {
            handleSizeChange(val) {
            },
            getLogList: function () {
                var self = this;
                if (self.pageNumber > self.totalPages) {
                    return
                }
                var postData = {
                    jobNo: "${jobNo}",
                    pageNumber: self.pageNumber,
                    pageSize: self.pageSize
                };
                $.ajax({
                    type: "post",
                    url: "/rest/joblog/pagelog",
                    contentType: "application/json",
                    data: JSON.stringify(postData),
                    success: function (data) {
                        if (data.code === "0" && data.data) {
                            self.totalCount = data.data.totalCount;
                            self.totalPages = data.data.totalPages;
                            self.logList = data.data.results
                        } else {
                            self.$message.error(data.message)
                        }
                    }
                })
            },
            handleMemberCurrentChange: function (val) {
                this.pageNumber = val;
                this.getLogList()
            },
            formatterResult: function (row, column, cellValue) {
                return cellValue ? '成功' : '失败'
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
                var m = time.getMonth() + 1;
                var d = time.getDate();
                var h = time.getHours();
                var mm = time.getMinutes();
                var s = time.getSeconds();
                return y + '-' + this.add0(m) + '-' + this.add0(d) + ' ' + this.add0(h) + ':' + this.add0(mm) + ':' + this.add0(s);
            },
            formatterRunningType: function (row, column, cellValue) {
                return cellValue === 1 ? "数据库" : "内存"
            },
            formatterSchedulingType: function (row, column, cellValue) {
                return cellValue === 1 ? "手动" : "自动"
            },
            setCellStyle: function (row) {
                var index = row.columnIndex;
                if ((index === 7 && !this.logList[row.rowIndex].schedulingResult) || (index === 8 && !this.logList[row.rowIndex].executeResult)) {
                    return "color: red;"
                }
            }
        }
    })
</script>
</body>
</html>
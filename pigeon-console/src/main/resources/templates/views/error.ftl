<h3>出错了！</h3>
<script type="text/javascript">
    var msg = '${errorMessage}';
    $(function () {
        if ('' == msg) {
            $.ligerDialog.error("出错了");
        } else {
            $.ligerDialog.error(msg);
        }
    });
</script>
${errorMessage}
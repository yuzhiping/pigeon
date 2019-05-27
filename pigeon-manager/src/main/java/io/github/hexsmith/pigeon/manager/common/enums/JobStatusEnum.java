package io.github.hexsmith.pigeon.manager.common.enums;

/**
 * 任务状态枚举
 *
 * @author hexsmith
 * @version v1.0
 * @since 2019-05-24 14:03
 */
public enum JobStatusEnum {
    /**
     * 已停止
     */
    STOP(0, "已停止"),
    /**
     * 已启动
     */
    STARTED(1, "已启动");

    private int code;

    private String message;

    JobStatusEnum(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public int getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }
}

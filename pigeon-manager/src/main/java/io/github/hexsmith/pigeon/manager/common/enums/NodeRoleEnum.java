package io.github.hexsmith.pigeon.manager.common.enums;

/**
 * 节点角色枚举
 *
 * @author hexsmith
 * @version v1.0
 * @since 2019-05-27 15:55
 */
public enum NodeRoleEnum {
    /**
     * admin节点，管理整个集群
     */
    ADMIN("admin", "admin"),
    /**
     * 主节点
     */
    MASTER("master", "master"),
    /**
     * 从节点
     */
    SLAVE("slave", "slave");

    /**
     * 角色值
     */
    private String value;

    /**
     * 角色描述
     */
    private String desc;

    NodeRoleEnum(String value, String desc) {
        this.value = value;
        this.desc = desc;
    }

    public String getValue() {
        return value;
    }

    public String getDesc() {
        return desc;
    }
}

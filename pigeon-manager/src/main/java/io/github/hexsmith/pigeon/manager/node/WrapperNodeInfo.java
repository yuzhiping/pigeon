package io.github.hexsmith.pigeon.manager.node;

import io.github.hexsmith.pigeon.manager.common.enums.NodeRoleEnum;

/**
 * @author hexsmith
 * @version v1.0
 * @since 2019-05-27 15:53
 */
public class WrapperNodeInfo extends NodeInfo {

    /**
     * 节点角色
     */
    private NodeRoleEnum nodeRole;

    public NodeRoleEnum getNodeRole() {
        return nodeRole;
    }

    public void setNodeRole(NodeRoleEnum nodeRole) {
        this.nodeRole = nodeRole;
    }
}

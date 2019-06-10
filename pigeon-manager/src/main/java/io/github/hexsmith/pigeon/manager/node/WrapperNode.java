package io.github.hexsmith.pigeon.manager.node;

import io.github.hexsmith.pigeon.manager.common.enums.NodeRoleEnum;

import java.io.Serializable;
import java.util.Objects;

/**
 * @author hexsmith
 * @version v1.0
 * @since 2019-05-27 15:53
 */
public class WrapperNode extends NodeInfo implements Serializable {


    private static final long serialVersionUID = -5730234449717270947L;
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

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        WrapperNode that = (WrapperNode) o;
        return nodeRole == that.nodeRole;
    }

    @Override
    public int hashCode() {
        return Objects.hash(nodeRole);
    }
}

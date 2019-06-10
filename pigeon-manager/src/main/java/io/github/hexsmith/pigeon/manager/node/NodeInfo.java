package io.github.hexsmith.pigeon.manager.node;

import java.io.Serializable;

/**
 * 节点信息
 *
 * @author hexsmith
 * @version v1.0
 * @since 2019-05-27 15:26
 */
public class NodeInfo implements Serializable {

    private static final long serialVersionUID = -6508277647540486452L;

    /**
     * 数据中心
     */
    private String idc;

    /**
     * 节点host
     */
    private String host;

    /**
     * 端口
     */
    private Integer port;

    /**
     * 分组
     */
    private String group;

    /**
     * 节点名称
     */
    private String nodeName;

    /**
     * 节点状态
     */
    private String nodeStatus;

    public String getIdc() {
        return idc;
    }

    public void setIdc(String idc) {
        this.idc = idc;
    }

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public Integer getPort() {
        return port;
    }

    public void setPort(Integer port) {
        this.port = port;
    }

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

    public String getNodeName() {
        return nodeName;
    }

    public void setNodeName(String nodeName) {
        this.nodeName = nodeName;
    }

    public String getNodeStatus() {
        return nodeStatus;
    }

    public void setNodeStatus(String nodeStatus) {
        this.nodeStatus = nodeStatus;
    }
}

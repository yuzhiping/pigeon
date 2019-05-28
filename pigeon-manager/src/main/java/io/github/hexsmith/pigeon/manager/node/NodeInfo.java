package io.github.hexsmith.pigeon.manager.node;

/**
 * 节点信息
 *
 * @author hexsmith
 * @version v1.0
 * @since 2019-05-27 15:26
 */
public class NodeInfo {

    /**
     * 数据中心
     */
    private String idc;

    /**
     * 节点IP
     */
    private String ip;

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

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
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

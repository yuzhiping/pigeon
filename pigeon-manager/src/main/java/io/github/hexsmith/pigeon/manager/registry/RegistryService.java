package io.github.hexsmith.pigeon.manager.registry;

import io.github.hexsmith.pigeon.manager.node.WrapperNode;

/**
 * registry node info to registry center
 *
 * @author hexsmith
 * @version v1.0
 * @since 2019-06-06 15:44
 */
public interface RegistryService {

    /**
     * 注册应用节点信息到注册中心
     *
     * @param wrapperNode 应用节点信息
     */
    void register(WrapperNode wrapperNode);

    /**
     * 取消注册节点
     *
     * @param wrapperNode 应用节点信息
     */
    void unregister(WrapperNode wrapperNode);

}

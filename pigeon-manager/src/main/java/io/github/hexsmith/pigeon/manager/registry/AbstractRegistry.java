package io.github.hexsmith.pigeon.manager.registry;

import com.google.common.collect.Sets;
import io.github.hexsmith.pigeon.manager.node.WrapperNode;

import java.util.Set;

/**
 * @author hexsmith
 * @version v1.0
 * @since 2019-06-06 15:56
 */
public abstract class AbstractRegistry implements RegistryService {

    private final Set<WrapperNode> registered = Sets.newConcurrentHashSet();

    private WrapperNode registryNode;

    protected void setRegistryNode(WrapperNode registryNode) {
        if (registryNode == null) {
            throw new IllegalArgumentException("registry node == null");
        }
        this.registryNode = registryNode;
    }

}

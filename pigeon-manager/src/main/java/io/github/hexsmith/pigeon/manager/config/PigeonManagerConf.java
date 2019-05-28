package io.github.hexsmith.pigeon.manager.config;

import io.github.hexsmith.pigeon.dal.config.PigeonDalConfig;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * manager层配置。
 * @author hexsmith
 * @version v1.0
 * @since 2019-05-24 13:51
 */
@Configuration
@Import(PigeonDalConfig.class)
public class PigeonManagerConf {
}

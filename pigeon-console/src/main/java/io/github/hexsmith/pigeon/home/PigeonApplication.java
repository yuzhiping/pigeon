package io.github.hexsmith.pigeon.home;

import com.alibaba.nacos.spring.context.annotation.config.NacosPropertySource;
import io.github.hexsmith.pigeon.manager.config.PigeonManagerConf;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;

/**
 * @author hexsmith
 * @version v1.0
 * @since 2019-05-24 13:30
 */
@SpringBootApplication
@Import(PigeonManagerConf.class)
@NacosPropertySource(dataId = "pigeon", autoRefreshed = true)
public class PigeonApplication {
    public static void main(String[] args) {
        SpringApplication.run(PigeonApplication.class, args);
    }
}

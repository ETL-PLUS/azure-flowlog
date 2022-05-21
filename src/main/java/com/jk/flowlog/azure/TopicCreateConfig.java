package com.jk.flowlog.azure;

import org.springframework.context.annotation.Configuration;

/**
 * @author chao
 * @description
 * @create 2022-05-21 16:12
 */
@Configuration
public class TopicCreateConfig {

    public static final String originalTopic = "azure_flowlog_topic";
    public static final String clearTopic = "azure_flowlog_clear_topic";

}

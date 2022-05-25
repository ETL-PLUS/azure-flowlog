package com.jk.flowlog.azure;

import com.alibaba.fastjson2.JSON;
import com.jayway.jsonpath.JsonPath;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * @author chao
 * @description
 * @create 2022-05-21 14:43
 */
@Component
@Slf4j
public class AzurelogListener {

    @Autowired
    KafkaTemplate<String, String> kafkaTemplate;

    @KafkaListener(topics = TopicCreateConfig.originalTopic)
    public void azureFlowlogTopicReceive(String message) {
        List<String> clearMessages = new ArrayList<>();
        try {
            String newMessage = JSON.parseObject(message).get("message").toString();
            log.info("原始数据为:{}",newMessage);
            clearMessages = handlerMessage(newMessage);
        } catch (Exception e) {
            log.error("azure_flowlog_topic hanlde message error,message :{}", message, e);
        }
        if (!clearMessages.isEmpty()) {
            log.info("发送的信息为:{}", clearMessages);
            clearMessages.forEach(clearMessage -> kafkaTemplate.send(TopicCreateConfig.clearTopic, clearMessage));
        }else {
            log.error("发送的信息解析错误，原始数据为:{}", clearMessages);
        }
    }

    private static List<String> handlerMessage(String message) {
        if (message.startsWith("b'")) {
            return JsonPath.read(message.substring(2,message.length()-1),"$..flowTuples[*]");
        } else if (message.startsWith("b")) {
            return JsonPath.read(message.substring(1),"$..flowTuples[*]");
        } else {
           return JsonPath.read(message, "$..flowTuples[*]");
        }
    }

}



package com.jk.flowlog.azure;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.kafka.annotation.EnableKafka;

@SpringBootApplication
@EnableKafka
public class AzureFlowlogApplication {

	public static void main(String[] args) {
		SpringApplication.run(AzureFlowlogApplication.class, args);
	}

}

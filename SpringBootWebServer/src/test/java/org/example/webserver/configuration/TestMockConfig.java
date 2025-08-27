package org.example.webserver.configuration;

import org.example.webserver.service.TaskService;
import org.mockito.Mockito;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;

@TestConfiguration

public class TestMockConfig {
    @Bean
    public TaskService taskService() {
        return Mockito.mock(TaskService.class);
    }
}

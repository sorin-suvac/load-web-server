package org.example.webserver;

import org.example.webserver.configuration.TestMockConfig;
import org.example.webserver.controller.TaskController;
import org.example.webserver.model.Task;
import org.example.webserver.model.TaskStatus;
import org.example.webserver.service.TaskService;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(TaskController.class)
@Import(TestMockConfig.class)
public class ServerApplicationTests {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private TaskService taskService;

    private static Task sampleTask;

    @BeforeAll
    public static void setUp() {
        sampleTask = new Task();
        sampleTask.setId(100L);
        sampleTask.setTitle("Test Task");
        sampleTask.setDescription("Description");
        sampleTask.setStatus(TaskStatus.PENDING);
        sampleTask.setDueDate(LocalDate.now().plusDays(1));
    }

    @ParameterizedTest
    @CsvSource({"100, 200", "101, 404"})
    public void testGetTask(int id, int statusCode) throws Exception {
        when(taskService.getTaskById(100)).thenReturn(sampleTask);
        when(taskService.getTaskById(101)).thenReturn(null);

        mockMvc.perform(get("/api/task/" + id))
                .andExpect(status().is(statusCode));
    }

    @Test
    public void testGetAllTasks() throws Exception {
        List<Task> taskList = Collections.singletonList(sampleTask);
        when(taskService.getAllTasks()).thenReturn(taskList);

        mockMvc.perform(get("/api/tasks"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].title").value("Test Task"));
    }

    @Test
    public void testAddTask() throws Exception {
        when(taskService.addTask(any(Task.class))).thenReturn(sampleTask);

        String json = String.format(
                "{\"title\": \"%s\", \"description\": \"%s\", \"status\": \"%s\", \"dueDate\": \"%s\"}",
                sampleTask.getTitle(), sampleTask.getDescription(), sampleTask.getStatus(), sampleTask.getDueDate()
        );

        mockMvc.perform(post("/api/add")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.title").value("Test Task"));
    }
}

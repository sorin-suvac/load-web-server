package org.example.webserver.controller;

import org.example.webserver.model.Task;
import org.example.webserver.service.TaskService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@SuppressWarnings("unused")
public class TaskController {
    private final TaskService taskService;

    public TaskController(TaskService taskService) {
        this.taskService = taskService;
    }

    @GetMapping("/task/{id}")
    @ResponseBody
    public ResponseEntity<Task> getTask(@PathVariable int id) {
        Task task = taskService.getTaskById(id);
        return task == null ? new ResponseEntity<>(HttpStatus.NOT_FOUND) : new ResponseEntity<>(task, HttpStatus.OK);
    }

    @GetMapping("/tasks")
    @ResponseBody
    public ResponseEntity<List<Task>> getAllTasks() {
        return new ResponseEntity<>(taskService.getAllTasks(), HttpStatus.OK);
    }

    @PostMapping("/add")
    @ResponseBody
    public ResponseEntity<Task> addTask(@RequestBody Task task) {
        Task t = taskService.addTask(task);
        return t == null ? new ResponseEntity<>(HttpStatus.BAD_REQUEST) : new ResponseEntity<>(t, HttpStatus.CREATED);
    }
}

package org.example.webserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import static org.example.webserver.utils.Constants.HOME;

@RestController
@SpringBootApplication
public class ServerApplication {

	private static int loadRequests = 0;

	public static void main(String[] args) {
		SpringApplication.run(ServerApplication.class, args);
	}

	@GetMapping("/")
	public String homeRequest() {
		return HOME;
	}

	@GetMapping("/load1")
	public String load1Request() {
		loadRequests ++;
		byte[] bytes = new byte[10_000_000]; // Allocate 10 MB
		return String.valueOf(loadRequests);
	}
}

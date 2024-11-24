package org.example.webserver;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static org.example.webserver.utils.Constants.HOME;

@SpringBootTest
class ServerApplicationTests {

	private static ServerApplication mApp;

	@BeforeAll
    public static void setup() {
		mApp = new ServerApplication();
	}

	@Test
	public void testHomeRequest() {
		Assertions.assertEquals(mApp.homeRequest(), HOME);
	}

	@Test
	public void testLoadRequest() {
		int requests = 5;
		String result = "";
		for (int i=0; i<requests; i++) {
			result = mApp.load1Request();
		}
		Assertions.assertEquals(requests, Integer.valueOf(result));
	}
}

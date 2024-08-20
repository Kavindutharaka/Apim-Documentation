package com.example;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/callback")
public class AsgardeoCallbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        // Exchange the code for tokens using Asgardeo's token endpoint
        // Verify the ID token and extract user information

        // Assuming user information is obtained successfully
        HttpSession session = request.getSession();
        session.setAttribute("user", "authenticatedUser");
        System.out.println("Welcome"+session.getAttribute("name"));

        response.sendRedirect("./site/index.html");
    }
}

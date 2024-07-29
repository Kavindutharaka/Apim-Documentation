package com.example.demo;


// import org.springframework.context.annotation.Configuration;
// import org.springframework.core.io.Resource;
// import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
// import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
// import org.springframework.web.servlet.resource.PathResourceResolver;

// import java.io.IOException;
// import java.nio.file.Path;
// import java.nio.file.Paths;

// @Configuration
// public class WebConfig implements WebMvcConfigurer {

//     @Override
//     public void addResourceHandlers(ResourceHandlerRegistry registry) {
//         registry.addResourceHandler("/**")
//                 .addResourceLocations("classpath:/site/")
//                 .resourceChain(true)
//                 .addResolver(new PathResourceResolver() {
//                     @Override
//                     protected org.springframework.core.io.Resource getResource(String resourcePath, org.springframework.core.io.Resource location) throws IOException {
//                         org.springframework.core.io.Resource requestedResource = location.createRelative(resourcePath);
//                         System.out.println(requestedResource);
//                         if (requestedResource.exists() && requestedResource.isReadable()) {
//                             System.out.println("f");
//                             return requestedResource;
//                         }
//                         Resource indexResource = location.createRelative(resourcePath + "/index.html");
//                         if (indexResource.exists() && indexResource.isReadable()) {
//                             return indexResource;
//                         }
//                         return null;
//                     }
//                 });
//     }
// }

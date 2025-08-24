import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")       // áp dụng cho tất cả endpoint
                        .allowedOrigins("*")     // cho phép mọi domain
                        .allowedMethods("*")     // GET, POST, PUT, DELETE, ...
                        .allowedHeaders("*");    // cho phép mọi header
            }
        };
    }
}
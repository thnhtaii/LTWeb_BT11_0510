package vn.iotstar.filter;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

public class SiteMeshFilter_24133050 extends ConfigurableSiteMeshFilter {

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        // Câu 1: Thiết lập Sitemesh Decorators cho project với 02 vai trò User và Admin
        builder.addDecoratorPath("/admin/*", "/admin.jsp")
               .addDecoratorPath("/admin", "/admin.jsp")
               .addDecoratorPath("/*", "/user.jsp")
               .addExcludedPath("/user.jsp")
               .addExcludedPath("/admin.jsp")
               .addExcludedPath("/WEB-INF/*")
               .addExcludedPath("/image*")
               .addExcludedPath("/assets/*")
               .addExcludedPath("/static/*")
               .addExcludedPath("/css/*")
               .addExcludedPath("/js/*")
               .addExcludedPath("/uploads/*");
    }
}

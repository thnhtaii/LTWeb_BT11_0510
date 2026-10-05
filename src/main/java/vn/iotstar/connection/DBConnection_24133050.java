package vn.iotstar.connection;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBConnection_24133050 {

    private final String serverName = "localhost";
    private final String dbName = "KT_QT";
    private final String portNumber = "64590";
    private final String userID = "sa";
    private final String password = loadPassword();

    private static String loadPassword() {
        String environmentPassword = System.getenv("APP_DB_PASSWORD");
        if (environmentPassword != null) {
            return environmentPassword;
        }
        Properties properties = new Properties();
        Path localConfig = Path.of("db.local.properties");
        if (Files.exists(localConfig)) {
            try (InputStream input = Files.newInputStream(localConfig)) {
                properties.load(input);
            } catch (IOException ex) {
                throw new IllegalStateException("Cannot read local database configuration", ex);
            }
        }
        return properties.getProperty("password", "");
    }

    public Connection getConnection() throws Exception {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://" + serverName + ":" + portNumber + ";databaseName=" + dbName
                + ";encrypt=true;trustServerCertificate=true;sendStringParametersAsUnicode=true;characterEncoding=UTF-8;";
        try {
            return DriverManager.getConnection(url, userID, password);
        } catch (Exception ex) {
            // Fallback sang named instance localhost\\SQLEXPRESS nếu port động thay đổi
            String fallbackUrl = "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=" + dbName
                    + ";encrypt=true;trustServerCertificate=true;sendStringParametersAsUnicode=true;characterEncoding=UTF-8;";
            return DriverManager.getConnection(fallbackUrl, userID, password);
        }
    }

    public static void main(String[] args) {
        try {
            DBConnection_24133050 db = new DBConnection_24133050();
            Connection conn = db.getConnection();
            if (conn != null) {
                System.out.println("Kết nối cơ sở dữ liệu KT_QT thành công!");
                conn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

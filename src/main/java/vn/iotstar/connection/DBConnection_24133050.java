package vn.iotstar.connection;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBConnection_24133050 {

    private final Properties properties = loadConfiguration();
    private final String serverName = setting("APP_DB_SERVER", "server", "localhost");
    private final String dbName = setting("APP_DB_NAME", "database", "KT_QT");
    private final String portNumber = setting("APP_DB_PORT", "port", "1433");
    private final String userID = setting("APP_DB_USER", "username", "sa");
    private final String password = setting("APP_DB_PASSWORD", "password", "");

    private static Properties loadConfiguration() {
        Properties properties = new Properties();
        Path localConfig = Path.of("db.local.properties");
        if (Files.exists(localConfig)) {
            try (InputStream input = Files.newInputStream(localConfig)) {
                properties.load(input);
            } catch (IOException ex) {
                throw new IllegalStateException("Cannot read local database configuration", ex);
            }
        }
        return properties;
    }

    private String setting(String environmentName, String propertyName, String defaultValue) {
        String value = System.getenv(environmentName);
        return value != null ? value : properties.getProperty(propertyName, defaultValue);
    }

    public Connection getConnection() throws Exception {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://" + serverName + ":" + portNumber + ";databaseName=" + dbName
                + ";encrypt=true;trustServerCertificate=true;sendStringParametersAsUnicode=true;loginTimeout=5;";
        return DriverManager.getConnection(url, userID, password);
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

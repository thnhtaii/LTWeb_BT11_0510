package vn.iotstar.entity;

import java.util.LinkedHashMap;
import java.util.Map;

public final class OrderStatus_24133050 {
    public static final Map<String, String> STATUS_LABELS = new LinkedHashMap<>();

    static {
        STATUS_LABELS.put("NEW", "Đơn hàng mới");
        STATUS_LABELS.put("CONFIRMED", "Đã xác nhận");
        STATUS_LABELS.put("PREPARING", "Chuẩn bị hàng");
        STATUS_LABELS.put("SHIPPING", "Vận chuyển");
        STATUS_LABELS.put("DELIVERING", "Giao hàng");
        STATUS_LABELS.put("DELIVERED", "Đã giao");
        STATUS_LABELS.put("CANCELED", "Đơn hàng hủy");
        STATUS_LABELS.put("RETURNED", "Đơn hàng hoàn");
    }

    private OrderStatus_24133050() {
    }

    public static String getLabel(String status) {
        return STATUS_LABELS.getOrDefault(status, "Không xác định");
    }

    public static boolean isValid(String status) {
        return status != null && STATUS_LABELS.containsKey(status);
    }
}

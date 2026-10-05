package vn.iotstar.entity;

import java.io.Serializable;

public class Category_24133050 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int categoryId;
    private String categoryname;
    private String categorycode;
    private String images;
    private boolean status;

    // Trường bổ sung để đếm số lượng video trong category (Câu 5 & Câu 6)
    private int videoCount;

    public Category_24133050() {
    }

    public Category_24133050(int categoryId, String categoryname, String categorycode, String images, boolean status) {
        this.categoryId = categoryId;
        this.categoryname = categoryname;
        this.categorycode = categorycode;
        this.images = images;
        this.status = status;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryname() {
        return categoryname;
    }

    public void setCategoryname(String categoryname) {
        this.categoryname = categoryname;
    }

    public String getCategorycode() {
        return categorycode;
    }

    public void setCategorycode(String categorycode) {
        this.categorycode = categorycode;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public int getVideoCount() {
        return videoCount;
    }

    public void setVideoCount(int videoCount) {
        this.videoCount = videoCount;
    }

    @Override
    public String toString() {
        return "Category_24133050 [categoryId=" + categoryId + ", categoryname=" + categoryname + ", videoCount="
                + videoCount + "]";
    }
}

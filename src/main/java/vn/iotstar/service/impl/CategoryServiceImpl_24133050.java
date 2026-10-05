package vn.iotstar.service.impl;

import java.util.List;

import vn.iotstar.dao.ICategoryDao_24133050;
import vn.iotstar.dao.impl.CategoryDaoImpl_24133050;
import vn.iotstar.entity.Category_24133050;
import vn.iotstar.service.ICategoryService_24133050;

public class CategoryServiceImpl_24133050 implements ICategoryService_24133050 {

    private ICategoryDao_24133050 categoryDao = new CategoryDaoImpl_24133050();

    @Override
    public List<Category_24133050> findAll() {
        return categoryDao.findAll();
    }

    @Override
    public List<Category_24133050> findAllWithVideoCount() {
        return categoryDao.findAllWithVideoCount();
    }

    @Override
    public Category_24133050 findById(int categoryId) {
        return categoryDao.findById(categoryId);
    }

    @Override
    public void insert(Category_24133050 category) {
        categoryDao.insert(category);
    }

    @Override
    public void update(Category_24133050 category) {
        categoryDao.update(category);
    }

    @Override
    public void delete(int categoryId) {
        categoryDao.delete(categoryId);
    }
}

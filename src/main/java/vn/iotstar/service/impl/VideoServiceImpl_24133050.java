package vn.iotstar.service.impl;

import java.util.List;

import vn.iotstar.dao.IVideoDao_24133050;
import vn.iotstar.dao.impl.VideoDaoImpl_24133050;
import vn.iotstar.entity.Video_24133050;
import vn.iotstar.service.IVideoService_24133050;

public class VideoServiceImpl_24133050 implements IVideoService_24133050 {

    private IVideoDao_24133050 videoDao = new VideoDaoImpl_24133050();

    @Override
    public Video_24133050 findById(String videoId) {
        return videoDao.findById(videoId);
    }

    @Override
    public void increaseViews(String videoId) {
        videoDao.increaseViews(videoId);
    }

    @Override
    public List<Video_24133050> findByCategoryId(int categoryId, int page, int pageSize) {
        return videoDao.findByCategoryId(categoryId, page, pageSize);
    }

    @Override
    public int countByCategoryId(int categoryId) {
        return videoDao.countByCategoryId(categoryId);
    }

    @Override
    public List<Video_24133050> findAll(int page, int pageSize) {
        return videoDao.findAll(page, pageSize);
    }

    @Override
    public int countAll() {
        return videoDao.countAll();
    }

    @Override
    public int countLikes(String videoId) {
        return videoDao.countLikes(videoId);
    }

    @Override
    public int countShares(String videoId) {
        return videoDao.countShares(videoId);
    }

    @Override
    public void insert(Video_24133050 video) {
        videoDao.insert(video);
    }

    @Override
    public void update(Video_24133050 video) {
        videoDao.update(video);
    }

    @Override
    public void delete(String videoId) {
        videoDao.delete(videoId);
    }
}

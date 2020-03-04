package com.jsict.biz.model;

import com.jsict.framework.core.dao.annotation.Dictionary;
import com.jsict.framework.core.dao.annotation.LogicDel;
import com.jsict.framework.core.model.BaseEntity;
import io.swagger.annotations.ApiModelProperty;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@LogicDel
@Entity
@Table(name = "wedding_photo")
public class WeddingPhoto extends BaseEntity<String> {

    /** 照片分类 */
    @Column(name = "photo_sort", length = 64)
    @Dictionary(dictField = "photoSort")
    @ApiModelProperty(value="照片分类")
    private String photoSort;

    /** 相册分类 */
    @Column(name = "album_sort", length = 64)
    @Dictionary(dictField = "albumSort")
    @ApiModelProperty(value="相册分类")
    private String albumSort;

    /** 照片 */
    @Column(name = "photo", length = 255)
    @ApiModelProperty(value="照片")
    private String photo;

    public String getPhotoSort() {
        return photoSort;
    }

    public void setPhotoSort(String photoSort) {
        this.photoSort = photoSort;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String getAlbumSort() {
        return albumSort;
    }

    public void setAlbumSort(String albumSort) {
        this.albumSort = albumSort;
    }
}

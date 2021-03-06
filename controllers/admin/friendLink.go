package admin

import (
	"encoding/json"
	"fmt"
	"gin-admin/config"
	db "gin-admin/database"
	"gin-admin/helper"
	"gin-admin/models"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
	"time"
)

type FriendLink struct{}

// GetFriendLinkList handles GET /admin/friend-link route
func (f *FriendLink) Index(c *gin.Context) {

	flash := helper.GetFlash(c)

	c.HTML(http.StatusOK, "friend-link/index", gin.H{
		"title": "友情链接管理",
		"flash": flash,
		"image": config.Setting["domain"]["image"],
	})
}

// Datatable
func (f *FriendLink) Data(c *gin.Context) {
	var friendLink []models.FriendLink

	query := db.Mysql.Model(&models.FriendLink{}).Preload("FriendLinkCategory").Preload("File")

	search := c.Query("search[value]")
	if search != "" {
		query = query.Where("id = ?", search).
			Or("title LIKE ?", "%"+search+"%").
			Or("content LIKE ?", "%"+search+"%")
	}
	total := 0
	query.Count(&total)

	order := c.Query("order[0][column]")
	sort := c.Query("order[0][dir]")
	query = query.Offset(c.Query("start")).Limit(c.Query("length"))

	switch order {
	case "1":
		query = query.Order("title " + sort)
	case "2":
		query = query.Order("category_id " + sort)
	case "3":
		query = query.Order("link " + sort)
	case "4":
		query = query.Order("image " + sort)
	case "5":
		query = query.Order("sort " + sort)
	case "6":
		query = query.Order("audit " + sort)
	case "7":
		query = query.Order("start_at " + sort)
	case "8":
		query = query.Order("end_at " + sort)
	case "9":
		query = query.Order("created_at " + sort)
	case "10":
		query = query.Order("updated_at " + sort)
	default:
		query = query.Order("id " + sort)
	}

	// find() will return data sorted by column name, but scan() return data with struct column order. scan() doesn't support Preload
	err := query.Find(&friendLink).Error
	if err != nil {
		_, _ = fmt.Fprintln(gin.DefaultWriter, err.Error())
	}

	c.JSON(http.StatusOK, gin.H{
		"draw":            c.Query("draw"),
		"recordsTotal":    len(friendLink),
		"recordsFiltered": total,
		"data":            friendLink,
	})
}

// Create handles GET /admin/friend-link/create route
func (f *FriendLink) Create(c *gin.Context) {

	flash := helper.GetFlash(c)

	var friendLinkCategories, data []models.FriendLinkCategory
	if err := db.Mysql.Model(&models.FriendLinkCategory{}).Order("level ASC, sort DESC").Find(&friendLinkCategories).Error; err != nil {
		_, _ = fmt.Fprintln(gin.DefaultWriter, err.Error())
	}
	(&models.FriendLinkCategory{}).SetSort(&friendLinkCategories, 0, &data)
	(&models.FriendLinkCategory{}).SetData(&data)

	c.HTML(http.StatusOK, "friend-link/create", gin.H{
		"title":                "创建友情链接",
		"flash":                flash,
		"friendLinkCategories": data,
	})
}

// Store handles POST /admin/friend-link route
func (f *FriendLink) Store(c *gin.Context) {

	friendLink := models.FriendLink{}
	// struct time.Time bing error
	friendLink.Title = c.PostForm("title")
	friendLink.Link = c.PostForm("link")
	friendLink.CategoryID, _ = strconv.ParseInt(c.PostForm("category_id"), 10, 64)
	friendLink.Image, _ = strconv.ParseInt(c.PostForm("image"), 10, 64)
	friendLink.Sort, _ = strconv.ParseInt(c.PostForm("sort"), 10, 64)
	friendLink.Audit, _ = strconv.ParseInt(c.PostForm("audit"), 10, 64)
	friendLink.StartAt, _ = time.ParseInLocation("2006-01-02 15:04:05", c.PostForm("start_at"), time.Local)
	friendLink.EndAt, _ = time.ParseInLocation("2006-01-02 15:04:05", c.PostForm("end_at"), time.Local)

	if old, err := json.Marshal(friendLink); err == nil {
		helper.SetFlash(c, string(old), "old")
	}

	if err := helper.ValidateStruct(friendLink); err != nil {
		helper.SetFlash(c, err.Error(), "error")
		c.Redirect(http.StatusFound, "/admin/friend-link/create")
		return
	}

	if err := db.Mysql.Omit("FriendLinkCategory", "File").Create(&friendLink).Error; err != nil {
		helper.SetFlash(c, err.Error(), "error")
		c.Redirect(http.StatusFound, "/admin/friend-link/create")
		return
	}

	helper.SetFlash(c, "创建友情链接成功", "success")
	c.Redirect(http.StatusFound, "/admin/friend-link")
}

func (f *FriendLink) Edit(c *gin.Context) {

	id := c.Param("id")
	flash := helper.GetFlash(c)

	friendLink := models.FriendLink{}
	if err := db.Mysql.Preload("FriendLinkCategory").Preload("File").First(&friendLink, id).Error; err != nil {
		_, _ = fmt.Fprintln(gin.DefaultWriter, err.Error())
	}

	var previewConfig []map[string]interface{}
	var preview []string
	var initialPreview, initialPreviewConfig []byte
	var err error

	if friendLink.Image > 0 {
		image := config.Setting["domain"]["image"]
		preview = append(preview, image+friendLink.File.Path)

		item := make(map[string]interface{})
		item["caption"] = friendLink.File.Name
		item["size"] = friendLink.File.Size
		item["url"] = "/admin/file/delete"
		item["key"] = friendLink.File.ID
		previewConfig = append(previewConfig, item)

		initialPreview, err = json.Marshal(preview)
		if err != nil {
			_, _ = fmt.Fprintln(gin.DefaultWriter, err.Error())
		}

		initialPreviewConfig, err = json.Marshal(previewConfig)
		if err != nil {
			_, _ = fmt.Fprintln(gin.DefaultWriter, err.Error())
		}
	}

	var friendLinkCategories, data []models.FriendLinkCategory
	if err := db.Mysql.Model(&models.FriendLinkCategory{}).Order("level ASC, sort DESC").Find(&friendLinkCategories).Error; err != nil {
		_, _ = fmt.Fprintln(gin.DefaultWriter, err.Error())
	}
	(&models.FriendLinkCategory{}).SetSort(&friendLinkCategories, 0, &data)
	(&models.FriendLinkCategory{}).SetData(&data)

	startAt := friendLink.StartAt.Format("2006-01-02 15:04:05")
	endAt := friendLink.EndAt.Format("2006-01-02 15:04:05")
	if startAt == "0001-01-01 00:00:00" {
		startAt = ""
	}
	if endAt == "0001-01-01 00:00:00" {
		endAt = ""
	}

	c.HTML(http.StatusOK, "friend-link/edit", gin.H{
		"title":                "编辑友情链接",
		"flash":                flash,
		"friendLink":           friendLink,
		"startAt":              startAt,
		"endAt":                endAt,
		"initialPreview":       string(initialPreview),
		"initialPreviewConfig": string(initialPreviewConfig),
		"friendLinkCategories": data,
	})
}

func (f *FriendLink) Update(c *gin.Context) {

	id := c.Param("id")
	friendLink := models.FriendLink{}
	// struct time.Time bing error
	friendLink.Title = c.PostForm("title")
	friendLink.Link = c.PostForm("link")
	friendLink.CategoryID, _ = strconv.ParseInt(c.PostForm("category_id"), 10, 64)
	friendLink.Image, _ = strconv.ParseInt(c.PostForm("image"), 10, 64)
	friendLink.Sort, _ = strconv.ParseInt(c.PostForm("sort"), 10, 64)
	friendLink.Audit, _ = strconv.ParseInt(c.PostForm("audit"), 10, 64)
	friendLink.StartAt, _ = time.ParseInLocation("2006-01-02 15:04:05", c.PostForm("start_at"), time.Local)
	friendLink.EndAt, _ = time.ParseInLocation("2006-01-02 15:04:05", c.PostForm("end_at"), time.Local)
	// when ID >0 use save() is for update.
	ID, err := strconv.ParseInt(id, 10, 64)
	if err != nil {
		helper.SetFlash(c, err.Error(), "error")
		c.Redirect(http.StatusFound, "/admin/friend-link/edit/"+id)
		return
	}
	friendLink.ID = ID

	if err := helper.ValidateStruct(friendLink); err != nil {
		helper.SetFlash(c, err.Error(), "error")
		c.Redirect(http.StatusFound, "/admin/friend-link/edit/"+id)
		return
	}

	// save() function can update empty,zero,bool column.
	if err := db.Mysql.Model(&models.FriendLink{}).Omit("FriendLinkCategory", "File").Save(&friendLink).Error; err != nil {
		helper.SetFlash(c, err.Error(), "error")
		c.Redirect(http.StatusFound, "/admin/friend-link/edit/"+id)
		return
	}
	helper.SetFlash(c, "修改友情链接成功", "success")
	c.Redirect(http.StatusFound, "/admin/friend-link")
}

func (f *FriendLink) Show(c *gin.Context) {
	id := c.Param("id")

	friendLink := models.FriendLink{}
	if err := db.Mysql.First(&friendLink, id).Error; err != nil {
		_, _ = fmt.Fprintln(gin.DefaultWriter, err.Error())
	}

	c.HTML(http.StatusOK, "friend-link/show", gin.H{
		"title":      "查看友情链接",
		"friendLink": friendLink,
	})
}

func (f *FriendLink) Destroy(c *gin.Context) {
	id := c.Param("id")

	if err := db.Mysql.Where("id = ?", id).Delete(&models.FriendLink{}).Error; err != nil {
		helper.SetFlash(c, err.Error(), "error")
	}

	helper.SetFlash(c, "删除友情链接成功", "success")
	c.Redirect(http.StatusFound, "/admin/friend-link")
}

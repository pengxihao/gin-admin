package models

type BookChapter struct {
	Base     `json:"base"`
	Title    string `json:"title" form:"title"`
	BookID   string `json:"book_id" form:"book_id" gorm:"column:book_id"`
	Chapter  string `json:"chapter" form:"chapter"`
	Audit    int64  `json:"audit" form:"audit"`
	Sort     int64  `json:"sort" form:"sort"`
	Hit      int64  `json:"hit" form:"hit"`
	Favorite int64  `json:"favorite" form:"favorite"`
	Comment  int64  `json:"comment" form:"comment"`
	Book     Book   `json:"book" validate:"-" gorm:"foreignKey:BookID"`
}

func (BookChapter) TableName() string {
	return "book_chapter"
}

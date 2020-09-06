package main

import (
	"log"
	"net/http"

	"github.com/go-chi/chi"
	"github.com/go-sql-driver/mysql"
	"github.com/jinzhu/gorm"
	"github.com/swaggo/http-swagger"
    _ "./docs"
    resp "github.com/nicklaw5/go-respond"
)

type (
	room struct {
		ID           uint64         `json:"id"`
		OwnerID      uint64         `json:"owner_id"`
		OwnerAddress string         `json:"owner_address"`
		Title        string         `json:"title"`
		Description  string         `json:"description"`
		EventCode    string         `json:"event_code"`
		Address      string         `json:"address"`
		CreateTxHash string         `json:"create_tx_hash"`
		IsPrivate    bool           `json:"is_private"`
		WeiBalance   uint64         `json:"wei_balance"`
		WeiPrize     uint64         `json:"wei_prize"`
		StartTime    mysql.NullTime `json:"start_time"`
		EndTime      mysql.NullTime `json:"end_time"`
		Active       bool           `json:"active"`
	}

	rooms []room
)

// API Documents
// @title Sample API
// @version 1.0.0
func main() {
    log.Println("Starting API Server!!")

    db := connectDB()
    defer db.Close()

    router := chi.NewRouter()

    // @Tags Room
    // @Accept json
    // @Summary 채팅방 정보를 불러옴
    // @Success 200 {array} []room
    // @Router /rooms [get]
    // /root에 접근하면 문자열의 root를 반환
    router.Get("/root", func(w http.ResponseWriter, r *http.Request) {
        rooms := []room{}
        db.Find(&rooms)

        resp.NewResponse(w).Ok(rooms)
    })

    router.Get("/swagger/*", httpSwagger.WrapHandler)
	http.ListenAndServe(":8080", router)
}

func connectDB() *gorm.DB {
	DBMS := "mysql"
	USER := "root"
	PASS := "password"
	PROTOCOL := "tcp(mysql)"
	DBNAME := "test_db"
	option := "?charset=utf8&parseTime=True"
	CONNECT := USER + ":" + PASS + "@" + PROTOCOL + "/" + DBNAME + option

	db, err := gorm.Open(DBMS, CONNECT)

	if err != nil {
		panic(err.Error())
	}
	return db
}
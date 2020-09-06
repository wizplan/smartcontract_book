package main

import (
	"./bindings"
	"context"
	"github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/go-sql-driver/mysql"
	"github.com/jinzhu/gorm"
	"log"
	"math/big"
	"math/rand"
	"os"
	"strings"
)

type Room struct {
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

type RoomCreatedEvent struct {
	Creator        common.Address
	Room           common.Address
	DepositedValue *big.Int
}

func main() {
	db := connectDB()
	defer db.Close()

	client, err := ethclient.Dial(os.Getenv("ws://localhost:7545"))
	if err != nil {
		log.Fatalf("err: %v\n", err)
	}

	topics := map[string]common.Hash{
		"RoomCreated": crypto.Keccak256Hash([]byte("RoomCreated(address,address,uint256)")),
	}

	query := ethereum.FilterQuery{
		Addresses: []common.Address{common.HexToAddress(os.Getenv("0x67f9604293167046f8838aA673974Fd00E9F68Fa"))},
		Topics: [][]common.Hash{{
			topics["RoomCreated"],
		}},
	}

	event := make(chan types.Log)
	sub, err := client.SubscribeFilterLogs(context.Background(), query, event)
	if err != nil {
		log.Fatal(err)
	}

	roomFactoryAbi, err := abi.JSON(strings.NewReader(string(bindings.RoomFactoryABI)))
	if err != nil {
		log.Fatal(err)
	}

	for {
		select {
		case err := <-sub.Err():
			log.Println(err)
			close(event)
		case vLog := <-event:
			if len(vLog.Topics) == 0 {
				log.Println("Topics is nothing.")
			}

			switch vLog.Topics[0] {
			case topics["RoomCreated"]:
				var roomCreatedEvent RoomCreatedEvent
				if err := roomFactoryAbi.Unpack(&roomCreatedEvent, "RoomCreated", vLog.Data); err != nil {
					log.Printf("Failed unpack: %v\n", err)
					continue
				}

				room := Room {
					Address: roomCreatedEvent.Room.Hex(),   // 새로 배포한 채팅방 계약 주소
					CreateTxHash: vLog.TxHash.Hex(),   // 트랜잭션 해시
					OwnerAddress: common.BytesToAddress(vLog.Topics[1].Bytes()).Hex(), // 배포한 사용자의 계약 주소
					WeiBalance: roomCreatedEvent.DepositedValue.Uint64(), // 배포할 때 설정한 착수금
					EventCode: getEventCode(4),   // 이벤트 코드
					OwnerID: 1,   // 더미
				}

				if err := db.Create(&room).Error; err != nil {
					log.Printf("Failed create room: %v\n", err)
				}

				break
			}
		}
	}
}

// Gorm으로 데이터베이스에 접속
func connectDB() *gorm.DB {
	DBMS := "mysql"
	USER := "root"
	PASS := "password"
	PROTOCOL := "tcp(mysql:3306)"
	DBNAME := "test_db"
	option := "?charset=utf8&parseTime=True"
	CONNECT := USER + ":" + PASS + "@" + PROTOCOL + "/" + DBNAME + option

	db, err := gorm.Open(DBMS, CONNECT)
	if err != nil {
		panic(err.Error())
	}

	return db
}

// n자리 이벤트 코드 반환
func getEventCode(n int) string {
	// 헷갈리기 쉬운 문자열 제외
	const allowedStrings = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ"

	eventCode := make([]byte, n)
	for i := range eventCode {
		eventCode[i] = allowedStrings[rand.Intn(len(allowedStrings))]
	}

	return string(eventCode)
}

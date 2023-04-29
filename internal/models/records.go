package models

type TgChannelPost struct {
	Id              int64
	ChannelName     string
	ChannelUsername string
	MessageId       int64
	MessageDate     uint64
	MessageText     string
}

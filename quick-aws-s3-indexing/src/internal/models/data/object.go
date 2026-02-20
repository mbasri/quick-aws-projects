package data

import (
	"fmt"
)

type Object struct {
	Key       string `json:"objectKey"`
	Size      int64  `json:"objectSize"`
	TimestampCreated string `json:"objectTimestampCreated"`
}

func NewObject(key string, size int64, timestampCreated string) *Object {
	return &Object{
		Key:       key,
		Size:      size,
		TimestampCreated: timestampCreated,
	}
}

func (o *Object) String() string {
	return fmt.Sprintf("Object{Key: %s, Size: %d, TimestampCreated: %s}", o.Key, o.Size, o.TimestampCreated)
}

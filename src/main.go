package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	r.GET("/check-health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "success",
		})
	})
	r.Run("127.0.0.1:8080")  // listen and serve on 0.0.0.0:8080
}
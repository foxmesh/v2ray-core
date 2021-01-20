package selector

import (
	"fmt"
	"io/ioutil"
)

func Init() error {
	buf, err:=ioutil.ReadFile("selector.json")
	if err != nil {
		fmt.Println("[warn] read selector.json failed, the feature will close that auto select better server")
		return err
	}


}
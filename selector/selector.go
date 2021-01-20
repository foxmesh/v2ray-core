package selector

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
)

const f = "selector.json"
// VMessPoint 服务节点
type VMessPoint struct {
	Ver int `json:"v"`
	Remark string `json:"ps"`
	Addr string `json:"add"`
	Port int `json:"port"`
	ID string `json:"id"`
	AlterID int `json:"aid"`
	NetType string `json:"net"`
	Type string `json:"type"`
	Host string `json:"host"`
	Path string `json:"path"`
	TLS string `json:"tls"`
}

// Selector 自动订阅，并从服务列表中选择 Ping 值最小的服务器
type Selector struct {
	SubAddr string `json:"subAddr"` // 订阅地址
	EndPoints []VMessPoint `json:"endPoints"`
}

var selector Selector

func init()  {
	buf, err:=ioutil.ReadFile(f)
	if err != nil {
		fmt.Println("[warn] read selector.json failed, the feature will close that auto select better server")
		return
	}

	_ = json.Unmarshal(buf, &selector)
}

// Fetch 从订阅地址获取服务列表
func Fetch() error {
	return nil
}

// 获取 Ping 值最小的一个服务地址, Ping 不通的服务地址将被移除
func Get() (VMessPoint, error) {
	return VMessPoint{}, nil
}

// Save 保存配置到文件
func Save() error{
	buf, _:=json.Marshal(selector)
	return ioutil.WriteFile(f, buf, 0644)
}

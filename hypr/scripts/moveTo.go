package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
)

type Workspace struct {
	Id              int    `json:"id"`
	Name            string `json:"name"`
	Monitor         string `json:"monitor"`
	MonitorID       int    `json:"monitorID"`
	Windows         int    `json:"windows"`
	Hasfullscreen   bool   `json:"hasfullscreen"`
	Lastwindow      string `json:"lastwindow"`
	Lastwindowtitle string `json:"lastwindowtitle"`
}

func main() {
	var id int
	if len(os.Args) != 2 {
		return
	}
	cmd, err := exec.Command("hyprctl", "activeworkspace", "-j").Output()
	if err != nil {
		panic(err)
	}

	workspace := Workspace{}
	err = json.Unmarshal(cmd, &workspace)
	if err != nil {
		panic(err)
	}
	id = workspace.Id

	if os.Args[1] == "right" {
		id++
	} else if os.Args[1] == "left" {
		id--
	} else {
		panic("Invalid argument")
	}

	exec.Command("hyprctl", "dispatch", "movetoworkspace", fmt.Sprintf("%d", id)).Run()
}

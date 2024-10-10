package main

import (
	"fmt"
	"os/exec"
	"strconv"
	"strings"
)

type BatteryState uint8

const (
	DISCHARGING BatteryState = iota
	CHARGING
	PENDING_CHARGE
	UNKNOWN
)

type Battery struct {
	Present          bool
	Rechargeable     bool
	State            string
	WarningLevel     string
	Energy           float64 // Wh
	EnergyEmpty      float64 // Wh
	EnergyFull       float64 // Wh
	EnergyFullDesign float64 // Wh
	EnergyRate       float64 // W
	Voltage          float64 // V
	ChargeCycles     int
	TimeToEmpty      float64 // Hours
	Percentage       int
}

type UserInfo struct {
	Percentage int
	EnergyRate float64
	State      BatteryState
}

func batteryList() []string {
	cmd := exec.Command("upower", "-e")

	batteryList, err := cmd.Output()
	if err != nil {
		fmt.Println(err.Error())
		return nil
	}

	lines := strings.Split(string(batteryList), "\n")
	var batteries []string

	for _, line := range lines {
		if strings.Contains(line, "battery") {
			parts := strings.Split(line, "/")
			batteries = append(batteries, parts[len(parts)-1])
		}
	}

	return batteries
}

func parseBatteryInfo(input string) Battery {
	lines := strings.Split(input, "\n")
	battery := Battery{}

	for _, line := range lines {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "present:") {
			battery.Present = parseBool(line)
		} else if strings.HasPrefix(line, "rechargeable:") {
			battery.Rechargeable = parseBool(line)
		} else if strings.HasPrefix(line, "state:") {
			battery.State = parseString(line)
		} else if strings.HasPrefix(line, "warning-level:") {
			battery.WarningLevel = parseString(line)
		} else if strings.HasPrefix(line, "energy:") {
			battery.Energy = parseFloat(line)
		} else if strings.HasPrefix(line, "energy-empty:") {
			battery.EnergyEmpty = parseFloat(line)
		} else if strings.HasPrefix(line, "energy-full:") {
			battery.EnergyFull = parseFloat(line)
		} else if strings.HasPrefix(line, "energy-full-design:") {
			battery.EnergyFullDesign = parseFloat(line)
		} else if strings.HasPrefix(line, "energy-rate:") {
			battery.EnergyRate = parseFloat(line)
		} else if strings.HasPrefix(line, "voltage:") {
			battery.Voltage = parseFloat(line)
		} else if strings.HasPrefix(line, "charge-cycles:") {
			battery.ChargeCycles = parseInt(line)
		} else if strings.HasPrefix(line, "time to empty:") {
			battery.TimeToEmpty = parseFloat(line)
		} else if strings.HasPrefix(line, "percentage:") {
			battery.Percentage = parsePercentage(line)
		}
	}

	return battery
}

func parseBool(line string) bool {
	parts := strings.Split(line, ":")
	return strings.TrimSpace(parts[1]) == "yes"
}

func parseString(line string) string {
	parts := strings.Split(line, ":")
	return strings.TrimSpace(parts[1])
}

func parseFloat(line string) float64 {
	parts := strings.Split(line, ":")
	valueStr := strings.Fields(strings.TrimSpace(parts[1]))[0]
	value, _ := strconv.ParseFloat(valueStr, 64)
	return value
}

func parseInt(line string) int {
	parts := strings.Split(line, ":")
	valueStr := strings.TrimSpace(parts[1])
	value, _ := strconv.Atoi(valueStr)
	return value
}

func parsePercentage(line string) int {
	parts := strings.Split(line, ":")
	valueStr := strings.TrimSpace(parts[1])
	valueStr = strings.TrimSuffix(valueStr, "%")
	value, _ := strconv.Atoi(valueStr)
	return value
}

func getUserInfo(info []Battery) UserInfo {
	output := UserInfo{
		Percentage: 0,
		EnergyRate: 0,
		State:      UNKNOWN,
	}

	if len(info) <= 1 {
		if info[0].State == "charging" {
			output.State = CHARGING
		} else if info[0].State == "discharging" {
			output.State = DISCHARGING
		} else if info[0].State == "pending-charge" {
			output.State = PENDING_CHARGE
		} else {
			output.State = UNKNOWN
		}
		output.Percentage = info[0].Percentage
		output.EnergyRate = info[0].EnergyRate
		return output
	}

	var totalCapacity float64
	var currentCapacity float64
	stateSet := false
	for _, b := range info {
		totalCapacity += b.EnergyFull
		currentCapacity += b.Energy
		if b.EnergyRate >= 0.1 {
			output.EnergyRate = b.EnergyRate
		}

		if !stateSet && b.State == "charging" {
			output.State = CHARGING
			stateSet = true
		} else if !stateSet && b.State == "discharging" {
			output.State = DISCHARGING
			stateSet = true
		} else if !stateSet && b.State == "pending-charge" {
			output.State = PENDING_CHARGE
		}
	}

	output.Percentage = int((currentCapacity / totalCapacity) * 100)

	return output
}

func main() {
	batteries := batteryList()
	if batteries == nil {
		fmt.Println("Error: Couldn't read any battery")
	}

	var batteriesInfo []Battery
	for _, batteryAddress := range batteries {
		batteryPath := "/org/freedesktop/UPower/devices/" + batteryAddress
		cmd := exec.Command("upower", "-i", batteryPath)
		batteryAttriutes, err := cmd.Output()
		if err != nil {
			fmt.Println(err.Error())
		}
		batteriesInfo = append(batteriesInfo, parseBatteryInfo(string(batteryAttriutes)))
	}

	userData := getUserInfo(batteriesInfo)
	var stateString string
	if userData.State == CHARGING {
		stateString = "Charging"
	} else if userData.State == DISCHARGING {
		stateString = "Discharging"
	} else {
		stateString = "???"
	}
	color := "\033[34m"
	if userData.Percentage <= 30 {
		color = "\033[31m"
	} else if userData.Percentage >= 80 {
		color = "\033[32m"
	}
	fmt.Println("\033[1mBattery:\033[0m")
	fmt.Printf("Charge is: %s%d%%\033[0m\n", color, userData.Percentage)
	if userData.State == PENDING_CHARGE {
		fmt.Println("Pending charge (stable)")
	} else {
		fmt.Printf("%s at a rate of: \033[34m%.3fW\033[0m\n", stateString, userData.EnergyRate)
	}
}

# "PC Manager" Fn key replacement with Bluetooth

This is a powershell script that replaces the "PC Manager" Fn key (F10) on Huawei laptops with a __Bluetooth toggle__.

- the idea is [here](https://gist.github.com/sk22/770960609386251989e14aee8b7877ce)

## Requirements
- It uses [ps2exe](https://www.powershellgallery.com/packages/ps2exe/1.0.13) powershell-module, that can be installed with:
```
Install-Module -Name ps2exe
```

## Installation
- run as administrator:
```
.\build.ps1
```

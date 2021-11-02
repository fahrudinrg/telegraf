@rem ##########################################################################
@rem
@rem  telegraf instalation script for Windows
@rem  list command:
@rem    - telegraf.exe --service uninstall	Remove the telegraf service
@rem    - telegraf.exe --service start	    Start the telegraf service
@rem    - telegraf.exe --service stop	    Stop the telegraf service
@rem
@rem ##########################################################################

@echo off
@rem powershell -command Invoke-WebRequest -OutFile telegraf-_windows_amd64.zip -Uri https://dl.influxdata.com/telegraf/releases/telegraf-1.20.2_windows_amd64.zip

start /WAIT "remove folder" powershell -command Remove-Item -LiteralPath "C:\Program Files\InfluxData\telegraf" -Force -Recurse
start /WAIT "download telegraf" powershell -command wget https://dl.influxdata.com/telegraf/releases/telegraf-1.20.2_windows_amd64.zip -UseBasicParsing -OutFile telegraf-1.20.2_windows_amd64.zip
start /WAIT "extract zip to C:\Program Files\InfluxData\telegraf\" powershell -command Expand-Archive .\telegraf-1.20.2_windows_amd64.zip -DestinationPath 'C:\Program Files\InfluxData\telegraf\'; pause
start /WAIT "go to telegraf source" powershell -command cd "C:\Program Files\InfluxData\telegraf"
start /WAIT "move telegraf binary and config to parent directory" powershell -command mv .\telegraf-1.20.2\telegraf.* .
start /WAIT "install Telegraf as a Windows service so that it starts automatically along with our system" powershell -command C:\'Program Files'\InfluxData\telegraf\telegraf.exe --service install --config 'C:\Program Files\InfluxData\telegraf\telegraf.conf'
start /WAIT "test once to check instalation work" powershell -command C:\'Program Files'\InfluxData\telegraf\telegraf.exe --config 'C:\Program Files\InfluxData\telegraf\telegraf.conf' --test; timeout 5
start /WAIT "start telegraf as a service and collect data" powershell -command  C:\'Program Files'\InfluxData\telegraf\telegraf.exe --config 'C:\Program Files\InfluxData\telegraf\telegraf.conf' --service start
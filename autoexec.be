class cmkserver
  var s
  def init()
    self.s = tcpserver(6556)
    tasmota.add_driver(self)
  end

  def every_50ms()
    import string
    if(self.s.hasclient())
      print("client") 
      var c = self.s.accept()

      var temp1 = ""
      import json
      var sensors=json.load(tasmota.read_sensors())
      if sensors != nil
        if sensors.contains('DS18B20')
          var temp_sensor = sensors['DS18B20']
          if temp_sensor.contains('Temperature')
            temp1 = "0,Temp Sensor 1,/temp1,Temperature," + str(sensors['DS18B20']['Temperature'])
          end
        end
      end


      c.write("<<<check_mk>>>\r\n" +
              "AgentOS: Tasmota\r\n" +
              "<<<openhardwaremonitor:sep(44)>>>\r\n" +
              temp1 + "\r\n"
      )
      c.close()

    end
  end
end

tasmota.add_rule('Wifi#Connected', /->cmkserver())

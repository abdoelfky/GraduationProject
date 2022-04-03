#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#define FIREBASE_AUTH "8QE9rJbqhCJEoIHV2gnik1ny5Ttkae6QsoNJijkX" 
#define FIREBASE_HOST "arduino-f73d3-default-rtdb.firebaseio.com"
#define WIFI_SSID "Etisalat-uwH5"
#define WIFI_PASSWORD "g9n9PUEb"

void setup() {
  Serial.begin(9600);

  // connect to wifi.
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());
  
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

int n = 0;

void loop() {

  
  String ssid;
  int32_t rssi;
  uint8_t encryptionType;
  uint8_t* bssid;
  int32_t channel;
  bool hidden;
  int scanResult;
  float rssi1=0;
  float rssi2=0; 
  float rssi3=0;
  

  scanResult = WiFi.scanNetworks(/*async=*/false, /*hidden=*/false);

  if (scanResult == 0) {
    Serial.println(F("No networks found"));
  } else if (scanResult > 0) {
//    Serial.printf(PSTR("%d networks found:\n"), scanResult);

    for (int8_t i = 0; i < scanResult; i++) {
      WiFi.getNetworkInfo(i, ssid, encryptionType, rssi, bssid, channel, hidden);
      if(WiFi.SSID(i)=="nagi1"){
          rssi1=rssi;
          }
      yield();
    }
        for (int8_t i = 0; i < scanResult; i++) {
      WiFi.getNetworkInfo(i, ssid, encryptionType, rssi, bssid, channel, hidden);
      if(WiFi.SSID(i)=="Etisalat-uwH5"){
          rssi2=rssi;
          }
      yield();
    }
        for (int8_t i = 0; i < scanResult; i++) {
      WiFi.getNetworkInfo(i, ssid, encryptionType, rssi, bssid, channel, hidden);
      if(WiFi.SSID(i)=="Adel"){
          rssi3=rssi;
          }
      yield();
    }
    

    
   
  } else {
    Serial.printf(PSTR("WiFi scan error %d"), scanResult);
  }
    Serial.printf(PSTR("FCB :%d"),rssi1);
    Serial.printf(PSTR("WE :%d"),rssi2);
    Serial.printf(PSTR("admin :%d \n"),rssi3);


  // set value
  Firebase.setFloat("FCB", rssi1);
  Firebase.setFloat("WE", rssi2);
  Firebase.setFloat("admin", rssi3);

  // handle error
  if (Firebase.failed()) {
      Serial.print("setting /number failed:");
      Serial.println(Firebase.error());  
      return;
  }
  delay(4000);

    
}

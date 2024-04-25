#include <EEPROM.h>
#include <SoftwareSerial.h>
#include "sleepbreathingradar.h"
#define Start_Byte 0x7E
#define Version_Byte 0xFF
#define Command_Length 0x06
#define End_Byte 0xEF
#define Acknowledge 0x00  //Returns info with command 0x41 [0x01: info, 0x00: no info]

#define ACTIVATED LOW

// SoftwareSerial mySerial(10, 11); // Replace with hardware serial port
SleepBreathingRadar radar;

String lastJudgment2 = "";
String lastBluetoothMessage = "";  // Variable to store the last Bluetooth message received

unsigned long previousMillis = 0;  // Will store last time the radar was updated
const long interval = 400;
// MP3 commands

// Setting buttons/pins
int buttonNext = 4;
int buttonPause = 5;
int buttonPrevious = 6;

const byte potPin = A3;
int analogValue = 0;  // Getting the value from the potentiometer
byte volumeLevel = 0;

boolean isPlaying = false;
int vol = 20;
int volOffset = 0;

boolean isDeep = false;

unsigned long prevMillis;

void setup() {
  //
  pinMode(buttonPause, INPUT);
  digitalWrite(buttonPause, HIGH);
  pinMode(buttonNext, INPUT);
  digitalWrite(buttonNext, HIGH);
  pinMode(buttonPrevious, INPUT);
  digitalWrite(buttonPrevious, HIGH);


  Serial1.begin(9600);  //  Serial1
  Serial.begin(9600);
  Serial2.begin(9600);
  radar.SerialInit();  // Initialize radar
  Serial.println("Ready");
  prevMillis = millis();
  playFirst();
  delay(1000);
  Serial.println("start");
  Serial.println("played");

  isPlaying = true;
}

void loop() {
  String receivedData = Serial2.readStringUntil('\n');
  Serial2.print(receivedData);

  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) {

    previousMillis = currentMillis;
    radar.recvRadarBytes();  // Receive radar data and start processing
    if (radar.newData) {
      byte dataMsg[radar.dataLen + 1] = { 0x00 };
      dataMsg[0] = 0x55;  // Add the header frame as the first element of the array
      for (byte n = 0; n < radar.dataLen; n++) {
        dataMsg[n + 1] = radar.Msg[n];  // Frame-by-frame transfer
      }
      radar.newData = false;  // Reset the newData flag

      String judgment2 = radar.Sleep_inf(dataMsg);
      if (judgment2 != lastJudgment2) {
        Serial2.println(judgment2);
        Serial.println(judgment2);
        if (judgment2 == "2Light" && !isDeep) {
          //Volume Down Function
          setHalfVolume();
        } else if (judgment2 == "2sleep") {
          autoPause();
          isDeep = true;
        }
        // Send the new judgment via HC-05
        lastJudgment2 = judgment2;  // Update the lastJudgment2 variable
      }
    }
  }


String aa =Serial.readStringUntil('\r');
  if ( aa== "2Light" && !isDeep) {
    //Volume Down Function
    setHalfVolume();
  } else if (aa == "2sleep") {
    Serial.println("into");
    autoPause();
    isDeep = true;
  }

  if (receivedData == "START") {
    // If the START command is received and the music is not playing, start playback
    if (!isPlaying) {
      playFirst();  // Play the first song
      isPlaying = true;
    }
  } else if (receivedData == "STOP") {
    isDeep = false;
    // If the STOP command is received and music is playing, stop playback
    if (isPlaying) {
      pause();  // pause (media player)
      isPlaying = false;
    }
  }

  setVolume();

  if (digitalRead(buttonPause) == ACTIVATED) {
    if (isPlaying) {
      pause();
      isPlaying = false;
    } else {
      isPlaying = true;
      play();
    }
  }

  if (digitalRead(buttonNext) == ACTIVATED) {
    if (isPlaying) {
      playNext();
    }
  }

  if (digitalRead(buttonPrevious) == ACTIVATED) {
    if (isPlaying) {
      playPrevious();
    }
  }
}

void playFirst() {
  execute_CMD(0x3F, 0, 0);
  delay(250);
  setVolume();
  delay(250);
  execute_CMD(0x11, 0, 1);
  delay(250);
}
void pause() {
  execute_CMD(0x0E, 0, 0);
  delay(100);
}

void play() {
  execute_CMD(0x0D, 0, 1);
  delay(100);
}

void playNext() {

  execute_CMD(0x01, 0, 1);
  delay(100);
}

//API behaviour to jump t the previous track
//to allow the user to get to the start of the current track, if its the first time the previous button is clicked
//go to the start of the track by skipping back then forward
//if the user clicks twice or more in quick succession just skip back
void playPrevious() {

  bool replayTrack = false;
  unsigned long curMillis = millis();

  if (curMillis - prevMillis > 1500) {
    replayTrack = true;
  }

  prevMillis = curMillis;

  //play previous track
  execute_CMD(0x02, 0, 1);

  if (replayTrack) {
    Serial.println("Restarting current");
    //if replay track, jump forward to te start of what was the current track
    delay(100);
    playNext();
  } else {
    Serial.println("Playing previous track");
  }
  delay(100);
}

//automatically dial the volume down to zero over 10 seconds using the adjustment
void volumeToZero() {
  //grab starting volume
  int startVol = vol;

  //incrementally reduce the volume every second
  for (int i = 1; i <= 10; i++) {
    volOffset = i * (startVol / -10);
    setVolume();
    delay(1000);
  }

  //reset the offset
  volOffset = 0;
}

//when user falls asleeep or criteria met for auto shut-off, gradually decrease volume and pause
void autoPause() {
  volumeToZero();
  if (isPlaying) {
    pause();
    isPlaying = false;
  }
}

void setVolume() {
  analogValue = analogRead(potPin);        // get value from pot
  vol = map(analogValue, 0, 1023, 0, 30);  //scale the pot value and volume level

  //use max of 0 and the current adjusted volume
  execute_CMD(0x06, 0, max(vol + volOffset, 0));  // Set the volume (0x00~0x30)
  delay(150);
}

void setHalfVolume() {
  Serial.println("123:" + analogRead(potPin));
  analogValue = analogRead(potPin);        // Get the current volume value from the potentiometer
  vol = map(analogValue, 0, 1023, 0, 30);  // Mapping analogue values to volume levels (0 to 30)
  Serial.println("vol:" + vol);
  int halfVol = vol / 2;  // Calculate half the volume level

  execute_CMD(0x06, 0, halfVol);  // Sends the adjusted volume level to the MP3 module
  delay(150);                     // Allow enough time to ensure the order is processed
}

void execute_CMD(byte CMD, byte Par1, byte Par2) {
  //calculate the checksum
  word checksum = -(Version_Byte + Command_Length + CMD + Acknowledge + Par1 + Par2);
  // bulid the command line
  byte Command_line[10] = { Start_Byte, Version_Byte, Command_Length, CMD, Acknowledge, Par1, Par2, highByte(checksum), lowByte(checksum), End_Byte };
  //send the command line to the module
  for (byte k = 0; k < 10; k++) {
    Serial1.write(Command_line[k]);  // Use the hardware serial port Serial1 to send
  }
}

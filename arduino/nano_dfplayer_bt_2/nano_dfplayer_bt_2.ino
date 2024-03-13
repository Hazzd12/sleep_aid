/////////////////////////////////////////////
// using basic nano with no BLE
// uses old bootloader
// pins: 
//  D11 to DF player RX via 1k resistor
//  D10 to TX player
// 5v to VCC
// GND to GND
// speakers cables  +/-
//
// 10k pot connected to A0, GND and 5V
// example of potentiometer at https://forum.arduino.cc/t/dfplayer-mini-volume-control-with-potentiometer/630524
//
// Bluetooth based on example from:
// https://www.mediafire.com/file/ch0b8crf53gtfq5/test_AT_cmd.rar/file
/////////////////////////////////////


///              MP3 PLAYER PROJECT
/// http://educ8s.tv/arduino-mp3-player/
//////////////////////////////////////////

#include <EEPROM.h>
#include "SoftwareSerial.h"
SoftwareSerial mySerial(10, 11); //not using TX and RX pins but 10 is for RX and 11 for TX

SoftwareSerial Bluetooth(2, 3);

// MP3 commands
# define Start_Byte 0x7E
# define Version_Byte 0xFF
# define Command_Length 0x06
# define End_Byte 0xEF
# define Acknowledge 0x00 //Returns info with command 0x41 [0x01: info, 0x00: no info]

# define ACTIVATED LOW

// set up buttons / pins
int buttonNext = 4;
int buttonPause = 5;
int buttonPrevious = 6;

const byte potPin = A0;
int  analogValue = 0; // get value from pot
byte volumeLevel = 0;

boolean isPlaying = false;
int vol = 20;
int volOffset = 0;

unsigned long prevMillis;
//char c = ' ';


void setup () {

  // pin config
  pinMode(buttonPause, INPUT);
  digitalWrite(buttonPause,HIGH);
  pinMode(buttonNext, INPUT);
  digitalWrite(buttonNext,HIGH);
  pinMode(buttonPrevious, INPUT);
  digitalWrite(buttonPrevious,HIGH);

  mySerial.begin (9600);
  Serial.begin(115200);
  Bluetooth.begin(38400);

  prevMillis = millis();

  delay(1000);
  Serial.println("playing");
  // start playing
  playFirst();
  Serial.println("played");

  isPlaying = true;


}



void loop () { 

 setVolume();

 if (digitalRead(buttonPause) == ACTIVATED)
  {
    
    if(isPlaying)
    {
      pause();
      isPlaying = false;
    }else
    {
      isPlaying = true;
      play();
    }
    
  }


 if (digitalRead(buttonNext) == ACTIVATED)
  {
    
    if(isPlaying)
    {
      playNext();
    }
    
  }

   if (digitalRead(buttonPrevious) == ACTIVATED)
  {
    if(isPlaying)
    {
      playPrevious();
    }
  }
}

void playFirst()
{
  execute_CMD(0x3F, 0, 0);
  delay(250);
  setVolume();
  delay(250);
  execute_CMD(0x11,0,1); 
  delay(250);
}

void pause()
{
  execute_CMD(0x0E,0,0);
  delay(100);
}

void play()
{
  execute_CMD(0x0D,0,1); 
  delay(100);
}

void playNext()
{
  
  execute_CMD(0x01,0,1);
  delay(100);
}

//API behaviour to jump t the previous track
//to allow the user to get to the start of the current track, if its the first time the previous button is clicked
//go to the start of the track by skipping back then forward
//if the user clicks twice or more in quick succession just skip back 
void playPrevious()
{

  bool replayTrack = false;
  unsigned long curMillis = millis();

  if (curMillis - prevMillis > 1500)
  {
    replayTrack = true;
  }

  prevMillis = curMillis;

  //play previous track
  execute_CMD(0x02,0,1);
  
  if (replayTrack)
  {
    Serial.println("Restarting current");
    //if replay track, jump forward to te start of what was the current track
    delay(100);
    playNext();
  }
  else {
    Serial.println("Playing previous track");
  }
  delay(100);
}

//automatically dial the volume down to zero over 10 seconds using the adjustment
void volumeToZero()
{
  //grab starting volume
  int startVol = vol;

  //incrementally reduce the volume every second
  for (int i=1; i<=10; i++)
  {
    volOffset = i*(startVol/-10);
    setVolume();
    delay(1000);
  }

  //reset the offset
  volOffset = 0;
}

//when user falls asleeep or criteria met for auto shut-off, gradually decrease volume and pause 
void autoPause()
{
  volumeToZero();
  if(isPlaying)
  {
    pause();
    isPlaying = false;
  }
}

void setVolume()
{
  analogValue = analogRead(potPin); // get value from pot
  vol = map(analogValue, 0, 1023, 0, 30);   //scale the pot value and volume level

  //use max of 0 and the current adjusted volume
  execute_CMD(0x06, 0, max(vol + volOffset, 0)); // Set the volume (0x00~0x30)
  delay(150);
}

void execute_CMD(byte CMD, byte Par1, byte Par2)
// Excecute the command and parameters
{
  // Calculate the checksum (2 bytes)
  word checksum = -(Version_Byte + Command_Length + CMD + Acknowledge + Par1 + Par2);
  // Build the command line
  byte Command_line[10] = { Start_Byte, Version_Byte, Command_Length, CMD, Acknowledge,
  Par1, Par2, highByte(checksum), lowByte(checksum), End_Byte};
  //Send the command line to the module
  for (byte k=0; k<10; k++)
  {
    mySerial.write( Command_line[k]);
  }
}

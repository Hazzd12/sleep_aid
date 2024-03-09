///              MP3 PLAYER PROJECT
/// http://educ8s.tv/arduino-mp3-player/
//////////////////////////////////////////

/////////////////////////////////////////////
// using basic none BLE nano with old bootloader
// pins: 
//  D11 to DFpllayer RX via 1k resistor
//  D10 to TX
// 5v to VCC
// GND to GND
// speakers cables  +/-
// 10k pot connected to A0, GND and 5V
// example of potentiometer at https://forum.arduino.cc/t/dfplayer-mini-volume-control-with-potentiometer/630524
///////////////////////////////////////


#include "SoftwareSerial.h"
SoftwareSerial mySerial(10, 11); //not using TX and RX pins but 10 is for RX and 11 for TX
# define Start_Byte 0x7E
# define Version_Byte 0xFF
# define Command_Length 0x06
# define End_Byte 0xEF
# define Acknowledge 0x00 //Returns info with command 0x41 [0x01: info, 0x00: no info]

# define ACTIVATED LOW

int buttonNext = 2;
int buttonPause = 3;
int buttonPrevious = 4;
boolean isPlaying = false;
int vol = 20;
int volOffset = 0;
const byte potPin = A0;
int  analogValue = 0; // get value from pot
byte volumeLevel = 0;


void setup () {

pinMode(buttonPause, INPUT);
digitalWrite(buttonPause,HIGH);
pinMode(buttonNext, INPUT);
digitalWrite(buttonNext,HIGH);
pinMode(buttonPrevious, INPUT);
digitalWrite(buttonPrevious,HIGH);

mySerial.begin (9600);
Serial.begin(115200);
delay(1000);
Serial.println("playing");
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
  delay(500);
  setVolume();
  delay(500);
  execute_CMD(0x11,0,1); 
  delay(500);
}

void pause()
{
  execute_CMD(0x0E,0,0);
  delay(500);
}

void play()
{
  execute_CMD(0x0D,0,1); 
  delay(500);
}

void playNext()
{
  execute_CMD(0x01,0,1);
  delay(500);
}

void playPrevious()
{
  execute_CMD(0x02,0,1);
  delay(500);
}

void setVolume()
{
  analogValue = analogRead(potPin); // get value from pot
  vol = map(analogValue, 0, 1023, 0, 30);   //scale the pot value and volume level

  execute_CMD(0x06, 0, vol + volOffset); // Set the volume (0x00~0x30)
  delay(1000);
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

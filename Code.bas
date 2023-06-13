$regfile = "M8def.dat"
$crystal = 1159200
'*****************************
Open "comb.5:9600,8,n,1" For Output As #1
Enable Interrupts
'*****************************
Config Watchdog = 2048
Stop Watchdog
'*****************************
Config Timer1 = Pwm , Prescale = 8 , Pwm = 8 , Compare A Pwm = Clear Down , Compare B Pwm = Clear Down
Enable Timer1
Enable Interrupts
Start Timer1

Config Timer2 = Pwm , Prescale = 8 , Pwm = On , Compare Pwm = Clear Up
Enable Timer2
Start Timer2

Ocr1a = 0
Ocr1b = 0
Ocr2 = 0
'*****************************
_in Alias Pind.7
Key_learn Alias Pind.4
Led_power Alias Portd.2
Led_learn Alias Portd.1
Voltage_trigger Alias Pind.3

Config _in = Input
Config Key_learn = Input
Config Led_power = Output
Config Led_learn = Output
Config Voltage_trigger = Input
'*****************************
Config Timer0 = Timer , Prescale = 1
Enable Timer0
Stop Timer0
'*****************************
Dim I As Word
Dim Ii As Word
Dim Pwmm As Word
Dim Flag As Byte
Dim Adcc As Word

Dim Time_count As Word
Dim Rf_data(50) As Word
Dim Remote_id As String * 30
Dim Remote_data As String * 30

Dim Save_id As String * 30
Dim Eram_save_id As Eram String * 30
Dim Eram_pwmm As Eram Word
Dim Eram_flag As Eram Byte

Save_id = Eram_save_id

Const Key_debounce = 300
Dim Data_save(301) As Word
'*****************************

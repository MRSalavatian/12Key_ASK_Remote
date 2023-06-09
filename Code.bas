$regfile = "M8def.dat"
$crystal = 11059200
'*****************************
Open "comb.5:9600,8,n,1" For Output As #1
Enable Interrupts
'*****************************
Config Watchdog = 2048
Stop Watchdog
'*****************************
Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc
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
Config Portd.3 = Input
'*****************************
Config Timer0 = Timer , Prescale = 1
Enable Timer0
Stop Timer0
'*****************************
Dim I As Word
Dim Ii As Word
Dim Flag As Byte
Dim Adcc As Word

Dim Time_count As Word
Dim Rf_data(50) As Word
Dim Remote_id As String * 30
Dim Remote_data As String * 30


Dim R_pwm As Word
Dim G_pwm As Word
Dim B_pwm As Word
Dim R_flag As Byte
Dim G_flag As Byte
Dim B_flag As Byte

Dim Eram_r_pwm As Eram Word
Dim Eram_g_pwm As Eram Word
Dim Eram_b_pwm As Eram Word
Dim Eram_r_flag As Eram Byte
Dim Eram_g_flag As Eram Byte
Dim Eram_b_flag As Eram Byte


Dim Save_id As String * 30
Dim Eram_save_id As Eram String * 30


If Key_learn = 1 Then                                       'reset eeprom
   Led_learn = 1
   Led_power = 1
   Eram_r_pwm = 51 : Waitms 100
   Eram_g_pwm = 51 : Waitms 100
   Eram_b_pwm = 51 : Waitms 100
   Eram_r_flag = 1 : Waitms 100
   Eram_g_flag = 1 : Waitms 100
   Eram_b_flag = 1 : Waitms 100

   Led_power = 1
   Do
      Reset Watchdog
      Waitms 100
      Toggle Led_learn
      Toggle Led_power
   Loop Until Key_learn = 0

   Led_learn = 0
   Led_power = 0
End If


R_pwm = Eram_r_pwm
G_pwm = Eram_g_pwm
B_pwm = Eram_b_pwm
R_flag = Eram_r_flag
G_flag = Eram_g_flag
B_flag = Eram_b_flag
Save_id = Eram_save_id
Const Key_debounce = 300
'*****************************
Waitms 500
Print #1 , "Save ID is :" ; Save_id
Print #1 , "R PWM= " ; R_pwm ; "   Flag=" ; R_flag
Print #1 , "R PWM= " ; G_pwm ; "   Flag=" ; G_flag
Print #1 , "R PWM= " ; B_pwm ; "   Flag=" ; B_flag

If R_flag = 1 Then Ocr1a = R_pwm
If G_flag = 1 Then Ocr1b = G_pwm
If B_flag = 1 Then Ocr2 = B_pwm
Led_power = 1
Led_learn = 0
Do
   Gosub Read_rf
   Reset Watchdog



   If Flag = 1 Then
      If Remote_data = "00000011" Then R_flag = 1
      If Remote_data = "00001100" Then R_flag = 0
      If Remote_data = "00001111" And R_pwm <= 204 Then R_pwm = R_pwm + 51
      If Remote_data = "00110000" And R_pwm => 102 Then R_pwm = R_pwm - 51

      If Remote_data = "00110011" Then G_flag = 1
      If Remote_data = "00111100" Then G_flag = 0
      If Remote_data = "00111111" And G_pwm <= 204 Then G_pwm = G_pwm + 51
      If Remote_data = "11000000" And G_pwm => 102 Then G_pwm = G_pwm - 51

      If Remote_data = "11000011" Then B_flag = 1
      If Remote_data = "11001100" Then B_flag = 0
      If Remote_data = "11001111" And B_pwm <= 204 Then B_pwm = B_pwm + 51
      If Remote_data = "11110000" And B_pwm => 102 Then B_pwm = B_pwm - 51

      If R_flag = 1 Then Ocr1a = R_pwm Else Ocr1a = 0
      If G_flag = 1 Then Ocr1b = G_pwm Else Ocr1b = 0
      If B_flag = 1 Then Ocr2 = B_pwm Else Ocr2 = 0
      Flag = 0
      Waitms 300
   End If

   Adcc = Getadc(1)
   If Adcc < 450 Then
      Led_power = 0
      Ocr1a = 0
      Ocr2 = 0
      Ocr1b = 0

      Eram_r_pwm = R_pwm : Waitms 10
      Eram_g_pwm = G_pwm : Waitms 10
      Eram_b_pwm = B_pwm : Waitms 10
      Eram_r_flag = R_flag : Waitms 10
      Eram_g_flag = G_flag : Waitms 10
      Eram_b_flag = B_flag : Waitms 10

      Print #1 , "Save Data"
      Led_power = 1
      Led_learn = 0
      Do
         Reset Watchdog
         Waitms 100
         Adcc = Getadc(1)
         Toggle Led_learn
         Toggle Led_power
      Loop Until Adcc > 500
      Led_learn = 0
   End If

Loop
'*****************************
Read_rf:
   Remote_data = ""
   Remote_id = ""
   If _in = 1 Then
      Do : Loop Until _in = 0

      Time_count = 0
      Do : Incr Time_count : Waitus 5 : Loop Until _in = 1


      If Time_count > 1550 And Time_count < 2100 Then       '1550   1950
         Led_learn = 1
         Remote_id = ""
         I = 1
         Do
            If _in = 1 Then
               Time_count = 0
               Do : Incr Time_count : Waitus 5 : Loop Until _in = 0
               Rf_data(i) = Time_count
               Incr I
            End If
            Reset Watchdog
         Loop Until I > 24

         For I = 1 To 24
            If Rf_data(i) > 45 And Rf_data(i) < 95 Then
               Rf_data(i) = 0
               Remote_id = Remote_id + "0"
            Else
               If Rf_data(i) > 140 And Rf_data(i) < 220 Then
                  Rf_data(i) = 1
                  Remote_id = Remote_id + "1"
               Else
                  'Print #1 , I ; ")" ; Rf_data(i)
                  Remote_id = ""
                  Remote_data = ""
                  Return
               End If
            End If
         Next I

         Remote_data = Right(remote_id , 8)
         Remote_id = Left(remote_id , 16)
         'Print #1 , "ID=" ; Remote_id ; "  Data=" ; Remote_data ; "   " ; Key_learn

         If Pind.4 = 1 Then                                 'Save new Remote
            Save_id = Remote_id
            Eram_save_id = Remote_id
            Waitms 10

            Print #1 , "Saved"
            Print #1 , "ID=" ; Remote_id ; "  Data=" ; Remote_data
            Led_learn = 1
            Waitms 100
            Do
               Reset Watchdog
               Waitms 10
            Loop Until Key_learn = 0
         End If

         If Save_id = Remote_id Then Flag = 1

      End If

      Led_learn = 0
   End If
Return
'*****************************
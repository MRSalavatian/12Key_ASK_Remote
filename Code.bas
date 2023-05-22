$regfile = "M8def.dat"
$crystal = 8000000
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
_in Alias Pinc.1
Key Alias Pinc.4
Ferq Alias Portc.3

Config _in = Input
Config Key = Input
Config Ferq = Output
'*****************************
Config Timer0 = Timer , Prescale = 1
Enable Timer0
Stop Timer0
'*****************************
Dim I As Word

Dim Led_r As Byte
Dim Led_g As Byte
Dim Led_b As Byte
Dim Led As Byte

Dim Time_count As Word
Dim Rf_data(50) As Word
Dim Remote_id As String * 30
Dim Remote_data As String * 30

Dim Save_id As String * 30
Dim Eram_save_id As Eram String * 30
Save_id = Eram_save_id

Const Key_debounce = 300
'*****************************
Led_r = 1
Led_g = 1
Led_b = 1
'(
Do
   For I = 1 To 255
      ocr1a=i
      Ocr1b = I
      Ocr2 = I
      Waitms 10
   Next I

Loop
')
Do
   Gosub Read_rf
   Reset Watchdog

   If Remote_data = "00000011" Then
      If Led_r < 5 Then Incr Led_r Else Led_r = 1
      Led = Led_r * 51
      Ocr1a = Led
      Waitms Key_debounce
   End If
   If Remote_data = "00001100" Then
      If Led_r > 1 Then Decr Led_r Else Led_r = 5
      Led = Led_r * 51
      Ocr1a = Led
      Waitms Key_debounce
   End If
   If Remote_data = "00001111" Then
      Led_r = 5
      Led = Led_r * 51
      Ocr1a = Led
      Waitms Key_debounce
   End If
   If Remote_data = "00110000" Then
      Led_r = 0
      Led = Led_r * 51
      Ocr1a = Led
      Waitms Key_debounce
   End If



   If Remote_data = "00110011" Then
      If Led_g < 5 Then Incr Led_g Else Led_g = 1
      Led = Led_g * 51
      Ocr1b = Led
      Waitms Key_debounce
   End If
   If Remote_data = "00111100" Then
      If Led_g > 1 Then Decr Led_g Else Led_g = 5
      Led = Led_g * 51
      Ocr1b = Led
      Waitms Key_debounce
   End If
   If Remote_data = "00111111" Then
      Led_g = 5
      Led = Led_g * 51
      Ocr1b = Led
      Waitms Key_debounce
   End If
   If Remote_data = "11000000" Then
      Led_g = 0
      Led = Led_g * 51
      Ocr1b = Led
      Waitms Key_debounce
   End If



   If Remote_data = "11000011" Then
      If Led_b < 5 Then Incr Led_b Else Led_b = 1
      Led = Led_b * 51
      ocr2 = Led
      Waitms Key_debounce
   End If
   If Remote_data = "11001100" Then
      If Led_b > 1 Then Decr Led_b Else Led_b = 5
      Led = Led_b * 51
      Ocr2 = Led
      Waitms Key_debounce
   End If
   If Remote_data = "11001111" Then
      Led_b = 5
      Led = Led_b * 51
      Ocr2 = Led
      Waitms Key_debounce
   End If
   If Remote_data = "11110000" Then
      Led_b = 0
      Led = Led_b * 51
      Ocr2 = Led
      Print #1 , Led_R ; "  " ; Led_G ; "  " ; Led_B
      Waitms Key_debounce
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

      If Time_count > 1550 And Time_count < 1950 Then
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
            If Rf_data(i) > 30 And Rf_data(i) < 85 Then
               Rf_data(i) = 0
               Remote_id = Remote_id + "0"
            Else
               If Rf_data(i) > 130 And Rf_data(i) < 200 Then
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
         Remote_id = Left(remote_id , 8)
         'Print #1 , "ID=" ; Remote_id ; "  Data=" ; Remote_data

         If Save_id = Remote_id Then                        'Check identity
            'Print #1 , "Data=" ; Remote_data
         Else
            Remote_data = ""
         End If


         If Key = 1 Then                                    'Save new Remote
            Save_id = Remote_id
            Eram_save_id = Remote_id
            Waitms 10

            Print #1 , "Saved"
            Print #1 , "ID=" ; Remote_id ; "  Data=" ; Remote_data
            Do
               Reset Watchdog
               Waitms 10
            Loop Until Key = 0
            Waitms 100
         End If
      End If
   End If
Return
'*****************************

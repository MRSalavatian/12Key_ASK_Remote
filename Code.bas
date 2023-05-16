$regfile = "M8def.dat"
$crystal = 8000000
'*****************************
Open "comb.5:9600,8,n,1" For Output As #1
Enable Interrupts
'*****************************
Config Watchdog = 2048
Stop Watchdog
'*****************************
Config Timer1 = Pwm , Prescale = 8 , Pwm = 8 , Compare A Pwm = Disconnect , Compare B Pwm = Clear Up
Enable Timer1
Enable Interrupts
Start Timer1

Config Timer2 = Pwm , Prescale = 8 , Pwm = On , Compare Pwm = Clear Down
Enable Timer2
Start Timer2
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
Dim Time_count As Word
Dim Rf_data(50) As Word
Dim Remote_id As String * 30
Dim Remote_data As String * 30

Dim Save_id As String * 30
Dim Eram_save_id As Eram String * 30
Save_id = Eram_save_id
'*****************************
Do
   Gosub Read_rf
   Reset Watchdog
Loop
'*****************************
Read_rf:
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

         If Save_id = Remote_id Then
            Print #1 , "Data=" ; Remote_data
         Else
            Remote_data = ""
         End If

         If Key = 1 Then
            Eram_save_id = Remote_id
            save_id = Remote_id
            Print #1 , "Saved"
            Waitms 500
            Reset Watchdog
         End If






      End If
   End If
Return
'*****************************

$regfile = "M8def.dat"
$crystal = 8000000
'*****************************
Open "comb.5:9600,8,n,1" For Output As #1
Enable Interrupts
'*****************************
Config Watchdog = 2048
Stop Watchdog
'*****************************
'(
Config Timer1 = Pwm , Prescale = 8 , Pwm = 8 , Compare A Pwm = Disconnect , Compare B Pwm = Clear Up
Enable Timer1
Enable Interrupts
Start Timer1

Config Timer2 = Pwm , Prescale = 8 , Pwm = On , Compare Pwm = Clear Down
Enable Timer2
Start Timer2
')
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
Dim S(400)as Word
Dim T As Word


Dim I As Word
Dim Time_count As Word
Dim Rf_data(50) As Word
Dim Remode_id_s As String * 20
Dim Remote_id As Long
Dim Remote_data_s As String * 6
Dim Remote_data As Long
'*****************************

'(
Do

   If Key = 1 Then
      For I = 1 To 300
      T = 0
      Do : Reset Watchdog : Incr T : Waitus 5 : Loop Until _in = 1
      S(i) = T

      Incr I
      T = 0
      Do : Reset Watchdog : Incr T : Waitus 5 : Loop Until _in = 0
      S(i) = T
      Next I

      Print #1 , "Satart "
      For I = 1 To 400
         T = 0
         Do
            Incr T
            Waitus 5
         Loop Until _in = 1
         S(i) = T

         Incr I

         T = 0
         Do
            Incr T
            Waitus 5
         Loop Until _in = 0
         S(i) = T
      Next I

      For I = 1 To 400
         Print #1 , I ; ") " ; S(i)
      Next I
   End If


Loop
')


Do
   Gosub Read_rf
   Reset Watchdog
Loop
'*****************************
Read_rf:
   If _in = 1 Then
      Do : Reset Watchdog : Loop Until _in = 0

      Time_count = 0
      Do : Reset Watchdog : Incr Time_count : Waitus 5 : Loop Until _in = 1

      If Time_count > 1550 And Time_count < 1950 Then

         I = 1
         Do
            If _in = 1 Then
               Time_count = 0
               Do : Reset Watchdog : Incr Time_count : Waitus 5 : Loop Until _in = 0
               Rf_data(i) = Time_count
               Incr I
            End If
         Loop Until I > 24

         For I = 1 To 24
            If Rf_data(i) > 30 And Rf_data(i) < 85 Then
               Rf_data(i) = 0
            Else
               If Rf_data(i) > 130 And Rf_data(i) < 200 Then
                  Rf_data(i) = 1
               Else
                  Print #1 , I ; ")" ; Rf_data(i)
                  Remote_id = 0
                  Remote_data = 0
                  Return
               End If
            End If
         Next I

         Print #1 , "Remote data is = ";
         For I = 1 To 24
            Print #1 , Rf_data(i);
         Next I
         Print #1 ,
         Waitms 200

      End If
   End If
Return
'*****************************





'(
      For I = 1 To 300
      T = 0
      Do : Reset Watchdog : Incr T : Waitus 5 : Loop Until _in = 1
      S(i) = T

      Incr I
      T = 0
      Do : Reset Watchdog : Incr T : Waitus 5 : Loop Until _in = 0
      S(i) = T
      Next I

      Print #1 , "Satart "
      For I = 1 To 400
         T = 0
         Do
            Incr T
            Waitus 5
         Loop Until _in = 1
         S(i) = T

         Incr I

         T = 0
         Do
            Incr T
            Waitus 5
         Loop Until _in = 0
         S(i) = T
      Next I


                                     '
Dim I As Word
Dim Ii As Word
Dim Count As Word

Dim S(24)as Word
Dim Saddress As String * 20
Dim Scode As String * 4
Dim Address As Long
Dim Code As Byte

Dim Relay1count As Word
Dim Relay2count As Word
Dim Relay3count As Word
Dim Relay4count As Word

Dim Save_data1 As Eram Byte
Dim Save_data2 As Eram Byte
Dim Save_data3 As Eram Byte
Dim Data1 As Byte
Dim Data2 As Byte
Dim Data3 As Byte

Dim Valid As Byte
Dim Locatee As Byte
Dim T_data(5) As Byte
Dim R_data(5) As Byte

Dim Sdata As String * 30
Dim Sdata2 As String * 30

Dim Selector As Byte
Dim Auto_mode As Byte
Dim Adcc As Word

Dim Loc_count As Byte
Const Maxsize = 85
Data1 = Save_data1
Data2 = Save_data2
Data3 = Save_data3
'*****************************
Selector = 2
Auto_mode = 0
Do
   Reset Watchdog

   If Key = 0 Then
      Count = 0
      Do
         Incr Count
         Waitms 50
         Reset Watchdog
            Red = 0
            Green = 0
            Blue = 0

         If Count > 10 Then
            Red = 1
            Green = 1
            Blue = 1
            Count = 0
            Ii = 0
            Do
               Gosub Readrf

               Incr Count
               If Count > 40000 Then Exit Do

               Incr Ii
               If Ii > 700 Then
                  Ii = 0
               End If

            Loop Until T_data(1) <> 0 And T_data(2) <> 0 And T_data(3) <> 0


            If T_data(1) <> 0 And T_data(2) <> 0 And T_data(3) <> 0 Then
               Gosub Check_valid
               If Valid = 0 Then
                  Red = 1
                  Waitms 900
                  Green = 1
                  Waitms 900
                  Red = 0
                  Waitms 900
                  Green = 0
                  Waitms 900
                  Save_data1 = T_data(1) : Waitms 50
                  Save_data2 = T_data(2) : Waitms 50
                  Save_data3 = T_data(3) : Waitms 50
                  Data1 = T_data(1)
                  Data2 = T_data(2)
                  Data3 = T_data(3)
               End If
            End If

            Do : Waitms 10 : Reset Watchdog : Loop Until Key = 1
         End If
      Loop Until Key = 1
   End If


   Gosub Readrf

   If T_data(1) <> 0 And T_data(2) <> 0 And T_data(3) <> 0 Then
      Gosub Check_valid

      If Valid <> 0 Then
         'Print #1 , "valid   " ; Valid
         Auto_mode = 0
         If Code.0 = 1 Then : Incr Selector : If Selector = 7 Then Selector = 0 : End If
         If Code.1 = 1 Then : Decr Selector : If Selector > 7 Then Selector = 6 : End If
         If Code.2 = 1 Then : Auto_mode = 1 : End If
         If Code.3 = 1 Then : Auto_mode = 0 : End If

         If Selector = 0 Then
            Red = 1
            Green = 1
            Blue = 1
         End If

         If Selector = 1 Then
            Red = 1
            Green = 0
            Blue = 0
         End If

         If Selector = 2 Then
            Red = 0
            Green = 1
            Blue = 0
         End If

         If Selector = 3 Then
            Red = 0
            Green = 0
            Blue = 1
         End If

         If Selector = 4 Then
            Red = 1
            Green = 1
            Blue = 0
         End If

         If Selector = 5 Then
            Red = 1
            Green = 0
            Blue = 1
         End If

         If Selector = 6 Then
            Red = 0
            Green = 1
            Blue = 1
         End If

         Waitms 300
         Count = 9999
      End If
   End If
      If Auto_mode = 1 Then
      Incr Count
      Adcc = Getadc(2)
      Adcc = Adcc * 5
      If Count > Adcc Then
         Incr Selector
         If Selector = 7 Then Selector = 0
         Count = 0
         If Selector = 0 Then
            Red = 1
            Green = 1
            Blue = 1
         End If

         If Selector = 1 Then
            Red = 1
            Green = 0
            Blue = 0
         End If

         If Selector = 2 Then
            Red = 0
            Green = 1
            Blue = 0
         End If

         If Selector = 3 Then
            Red = 0
            Green = 0
            Blue = 1
         End If

         If Selector = 4 Then
            Red = 1
            Green = 1
            Blue = 0
         End If

         If Selector = 5 Then
            Red = 1
            Green = 0
            Blue = 1
         End If

         If Selector = 6 Then
            Red = 0
            Green = 1
            Blue = 1
         End If
      End If
   End If


Loop
'*****************************
Readrf:
   T_data(1) = 0 : T_data(2) = 0 : T_data(3) = 0
   If _in = 1 Then
      Do
         Reset Watchdog
         If _in = 0 Then Exit Do
      Loop

      Timer1 = 0
      Start Timer1
      While _in = 0
         Reset Watchdog
      Wend
      Stop Timer1
      If Timer1 >= 3500 And Timer1 <= 8800 Then
         I = 0
         Do
            If _in = 1 Then
               Timer1 = 0
               Start Timer1
               While _in = 1
                  Reset Watchdog
               Wend
               Stop Timer1
               Incr I
               S(i) = Timer1
            End If
            Reset Watchdog
            If I = 24 Then Exit Do
         Loop

         For I = 1 To 24
            Reset Watchdog
            If S(i) >= 120 And S(i) <= 350 Then
               S(i) = 0
            Else
               If S(i) >= 400 And S(i) <= 850 Then
                  S(i) = 1
                  Else
                  I = 0
                  Address = 0
                  Code = 0
                  Return
               End If
            End If
         Next

         Sdata = ""
         For I = 1 To 8 : Sdata = Sdata + Str(s(i)) : Next I
         T_data(1) = Binval(sdata)

         Sdata = ""
         For I = 9 To 16 : Sdata = Sdata + Str(s(i)) : Next I
         T_data(2) = Binval(sdata)

         Sdata = ""
         For I = 17 To 20 : Sdata = Sdata + Str(s(i)) : Next I
         T_data(3) = Binval(sdata)

         Sdata = ""
         For I = 21 To 24 : Sdata = Sdata + Str(s(i)) : Next I
         Code = Binval(sdata)


         Print #1 , "Address= " ; T_data(1) ; "|" ; T_data(2) ; "|" ; T_data(3) ; "     Code=" ; Code
      End If
   End If

Return
'*****************************
Check_valid:
   Valid = 0
   'Print #1 , I ; ") " ; R_data(1) ; " " ; R_data(2) ; " " ; R_data(3)
   R_data(1) = Data1
   R_data(2) = Data2
   R_data(3) = Data3

   If R_data(1) = T_data(1) And R_data(2) = T_data(2) And R_data(3) = T_data(3) Then
      Valid = 1
      Return
   End If
      Reset Watchdog
Return
'*****************************

')
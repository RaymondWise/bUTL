VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "bUTLChartSeries"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public Values As Range
Public XValues As Range
Public name As Range
Public SeriesNumber As Integer
Public ChartType As XlChartType
Public series As series

Private Function FullAddress(rng As Range) As Variant

    If rng Is Nothing Then
        FullAddress = ""
    Else
        FullAddress = "'" & rng.Parent.name & "'!" & rng.Address(External:=False)
    End If

End Function

Public Property Get SeriesFormula() As String
    
    SeriesFormula = "=SERIES(" & FullAddress(Me.name) & "," & FullAddress(Me.XValues) & "," & FullAddress(Me.Values) & "," & Me.SeriesNumber & ")"

End Property


Function AddSeriesToChart(cht As Chart) As series

    Dim ser As series
    Set ser = cht.SeriesCollection.NewSeries
    
    ser.Formula = Me.SeriesFormula
    
    If Me.ChartType <> 0 Then
        ser.ChartType = Me.ChartType
    End If
    
    
    Set AddSeriesToChart = ser

End Function

Sub UpdateSeriesWithNewValues()

    Me.series.Formula = Me.SeriesFormula

End Sub

Sub UpdateFromChartSeries(ser As series)
    'this will work for the simple case where all items are references
    
    Set series = ser

    Dim form As Variant
    
    '          "=SERIES("Y",Sheet1!$C$8:$C$13,Sheet1!$D$8:$D$13,1)"
    
    'pull in teh formula
    form = ser.Formula
    
    'uppercase to remove match errors
    form = UCase(form)
    
    'remove the front of the formula
    form = Replace(form, "=SERIES(", "")
    
    'Debug.Print form & vbCrLf
    '   "Y",SHEET1!$C$8:$C$13,SHEET1!$D$8:$D$13,1)
    
    'find the first comma
    Dim comma
    comma = InStr(form, ",")
    
    'Debug.Print comma
    
    If comma > 1 Then
    Set Me.name = Range(left(form, comma - 1))
    End If
    
    'pull out the title from that
    form = Mid(form, comma + 1)
    
    'Debug.Print vbCrLf & form
    '   SHEET1!$C$8:$C$13,SHEET1!$D$8:$D$13,1)
    
    'check the xvalues for multiple references (include paren)
    
    comma = InStr(form, ",")
    
    If comma > 1 Then
    Set Me.XValues = Range(left(form, comma - 1))
    End If
    form = Mid(form, comma + 1)
    'Debug.Print vbCrLf & form
        
    comma = InStr(form, ",")
    Set Me.Values = Range(left(form, comma - 1))
    form = Mid(form, comma + 1)
    'Debug.Print vbCrLf & form
    
    comma = InStr(form, ")")
    Me.SeriesNumber = left(form, comma - 1)
    
    Me.ChartType = ser.ChartType
        
    'if parenth then bring in until ), // otherwise until next comma
    
    'do teh same thing for y values
    
    'pull in the series number
    
    
End Sub

Private Sub Class_Initialize()
    Me.SeriesNumber = 1
End Sub

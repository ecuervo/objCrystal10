VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsCrystal10"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Dim objCon As New ADODB.Connection
Dim objRst As New ADODB.Recordset
Private m_bbReg As Boolean
Private m_ssTítulo As String
Private m_ssReporte As String
Private m_objoRecordset As Recordset
Private m_bymodoForm As Byte
Private m_srepTítulo As String
Private m_srepComentario As String
Private m_ssubRep1 As String
Private m_ssubRep2 As String
Private m_objrstSubR1 As Recordset
Private m_objrstSubR2 As Recordset
Private m_saPDF As String
Private m_ssLogo As String
Private m_saXLS As String
Private m_bbAlFrente As Boolean

Private Sub Class_Terminate()

    Set m_objoRecordset = Nothing

    Set m_objrstSubR1 = Nothing
    Set m_objrstSubR2 = Nothing
End Sub


Public Sub VerReporte(Optional Ocultar As Boolean = False, Optional idImpresora As Integer = -1, Optional Orientacion As Byte = 0, Optional imprime As Boolean, Optional dialog As Boolean)
'Orientacion=0 Por defecto-crDefaultPaperOrientation
'Orientacion=1 Vertical-crPortrait
'Orientacion=2 Horizontal-crLandscape
On Local Error GoTo errH
Dim objCry As New CRAXDRT.Application
Dim objRpt As New CRAXDRT.Report
Dim logo As CRAXDRT.OLEObject
If oRecordset.EOF Then
    MsgBox "No hay registros para mostrar!", vbInformation
Else
    objCry.SetLicenseKeycode "AV860-01CS00G-U7000NC"
    
    Set objRpt = objCry.OpenReport(sReporte)
    With objRpt
        .DiscardSavedData
        .Database.SetDataSource oRecordset
        If subRep1 <> vbNullString Then
            .OpenSubreport(subRep1).Database.SetDataSource rstSubR1
        End If
        If subRep2 <> vbNullString Then
            .OpenSubreport(subRep2).Database.SetDataSource rstSubR2
        End If
        .ReportTitle = repTítulo
        .ReportComments = repComentario
        .PaperOrientation = Orientacion
        If idImpresora <> -1 Then
            .SelectPrinter Printers.Item(idImpresora).DriverName, Printers.Item(idImpresora).DeviceName, Printers.Item(idImpresora).Port
            .PaperOrientation = Orientacion
        End If
        If bREG And Trim(sLogo) <> vbNullString Then
            Set logo = .Sections(2).AddPictureObject(sLogo, .Sections(2).ReportObjects("logo").Left, .Sections(2).ReportObjects("logo").Top)
            logo.Width = .Sections(2).ReportObjects("logo").Width
            logo.Height = .Sections(2).ReportObjects("logo").Height
        End If
        .ReadRecords
        DoEvents
salto:
    End With
    If aPDF <> vbNullString Then
        objRpt.ExportOptions.DiskFileName = aPDF
        objRpt.ExportOptions.DestinationType = crEDTDiskFile
        objRpt.ExportOptions.FormatType = crEFTPortableDocFormat
        objRpt.ExportOptions.PDFExportAllPages = True
        objRpt.Export False
        DoEvents
        Exit Sub
    End If
    If aXLS <> vbNullString Then
        objRpt.ExportOptions.DiskFileName = aXLS
        objRpt.ExportOptions.DestinationType = crEDTDiskFile
        objRpt.ExportOptions.FormatType = crEFTExcelDataOnly
        objRpt.ExportOptions.PDFExportAllPages = True
        objRpt.Export False
        DoEvents
        MsgBox "Proceso finalizado!", vbInformation
        Exit Sub
    End If
    If imprime Then
        objRpt.PrintOut dialog
        DoEvents
        Exit Sub
    End If
    With frmVer.objVer
        .ReportSource = objRpt
        .EnableExportButton = True
        .DisplayGroupTree = False
        .ViewReport
        .Zoom 1 '1 PageWidth,2 Whole Page
        frmVer.Caption = sTítulo
        
        If Not Ocultar Then
            Load frmVer
            frmVer.bFrente = bAlFrente
            frmVer.FLoad
            frmVer.bRegi = bREG
            frmVer.Show modoForm
        End If
    End With
End If
Exit Sub
errH:
If Err.Number = 9 Then
    GoTo salto
Else
    MsgBox "Error " & Err.Number & ". " & Err.Description
End If

End Sub

Public Property Get sTítulo() As String

    sTítulo = m_ssTítulo

End Property

Public Property Let sTítulo(ByVal ssTítulo As String)

    m_ssTítulo = ssTítulo

End Property

Public Property Get sReporte() As String

    sReporte = m_ssReporte

End Property

Public Property Let sReporte(ByVal ssReporte As String)

    m_ssReporte = ssReporte

End Property

Public Property Get oRecordset() As Recordset

    Set oRecordset = m_objoRecordset

End Property

Public Property Set oRecordset(objoRecordset As Recordset)

    Set m_objoRecordset = objoRecordset

End Property

Public Property Get modoForm() As Byte

    modoForm = m_bymodoForm

End Property

Public Property Let modoForm(ByVal bymodoForm As Byte)

    m_bymodoForm = bymodoForm

End Property

Public Property Get repTítulo() As String

    repTítulo = m_srepTítulo

End Property

Public Property Let repTítulo(ByVal srepTítulo As String)

    m_srepTítulo = srepTítulo

End Property

Public Property Get repComentario() As String

    repComentario = m_srepComentario

End Property

Public Property Let repComentario(ByVal srepComentario As String)

    m_srepComentario = srepComentario

End Property

Public Property Get subRep1() As String

    subRep1 = m_ssubRep1

End Property

Public Property Let subRep1(ByVal ssubRep1 As String)

    m_ssubRep1 = ssubRep1

End Property

Public Property Get subRep2() As String

    subRep2 = m_ssubRep2

End Property

Public Property Let subRep2(ByVal ssubRep2 As String)

    m_ssubRep2 = ssubRep2

End Property

Public Property Get rstSubR1() As Recordset

    Set rstSubR1 = m_objrstSubR1

End Property

Public Property Set rstSubR1(objrstSubR1 As Recordset)

    Set m_objrstSubR1 = objrstSubR1

End Property

Public Property Get rstSubR2() As Recordset

    Set rstSubR2 = m_objrstSubR2

End Property

Public Property Set rstSubR2(objrstSubR2 As Recordset)

    Set m_objrstSubR2 = objrstSubR2

End Property

Public Property Get aPDF() As String

    aPDF = m_saPDF

End Property

Public Property Let aPDF(ByVal saPDF As String)

    m_saPDF = saPDF

End Property

Public Property Get bREG() As Boolean

    bREG = m_bbReg

End Property

Public Property Let bREG(ByVal bbReg As Boolean)

    m_bbReg = bbReg

End Property


Public Property Get sLogo() As String

    sLogo = m_ssLogo

End Property

Public Property Let sLogo(ByVal ssLogo As String)

    m_ssLogo = ssLogo

End Property

Public Property Get bAlFrente() As Boolean

    bAlFrente = m_bbAlFrente

End Property

Public Property Let bAlFrente(ByVal bbAlFrente As Boolean)

    m_bbAlFrente = bbAlFrente

End Property

Public Property Get aXLS() As String

    aXLS = m_saXLS

End Property

Public Property Let aXLS(ByVal saXLS As String)

    m_saXLS = saXLS

End Property

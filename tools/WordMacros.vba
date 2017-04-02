'Exports the contents of the document as a text file, into the parent folder of the current folder because
'that's where the segments are usually located.
'The exported data is a snapshot of the text in the document, stripped of all formatting and with
'all changes accepted (even if the changes weren't accepted yet).
Sub ExportStorySegment()
'
' ExportStorySegment Macro
'
'
    Dim oldFile As String
    oldFile = ActiveDocument.path + "\" + ActiveDocument.name
    
    Dim newNameWithoutExtension As String
    newNameWithoutExtension = Mid(ActiveDocument.name, 1, InStrRev(ActiveDocument.name, ".") - 1)
    
    Dim newPath As String
    newPath = Mid(ActiveDocument.path, 1, InStrRev(ActiveDocument.path, "\") - 1)
    
    Dim finalFileName As String
    finalFileName = newPath + "\" + newNameWithoutExtension + ".stseg"
    
    Application.ScreenUpdating = False
    
    ActiveDocument.Save
    ActiveDocument.SaveAs2 FileName:=finalFileName, FileFormat:=wdFormatText, _
                           LockComments:=False, Password:="", AddToRecentFiles:=False, WritePassword _
                           :="", ReadOnlyRecommended:=False, EmbedTrueTypeFonts:=False, _
                           SaveNativePictureFormat:=False, SaveFormsData:=False, SaveAsAOCELetter:= _
                           False, Encoding:=65001, InsertLineBreaks:=False, AllowSubstitutions:= _
                           False, LineEnding:=wdCRLF, CompatibilityMode:=0
            
    ActiveDocument.Close
    Documents.Open oldFile
        
    Application.ScreenUpdating = True
End Sub

'Imports the chosen story segment into this file. This is usually done when the template.html is opened.
'The macro will show the Open File dialog for the parent folder of the current folder because
'that's where the story segments are usually located.
Sub ImportStorySegment()
'
' ImportStorySegment Macro
'
'

    Dim selectedFile As String
    Dim storySegment As Document
    
    selectedFile = showOpenFileDialogParentFolder
    'No file selected.
    If (Len(selectedFile) < 3) Then
      Exit Sub
    End If
    
    'Temporarily disable tracking changes.
    ActiveDocument.TrackRevisions = False
    ActiveDocument.TrackMoves = False
    ActiveDocument.TrackFormatting = False
    
    Set storySegment = Documents.Open(FileName:=selectedFile, AddToRecentFiles:=False, Visible:=False, ConfirmConversions:=False)
    ActiveDocument.Range.InsertAfter storySegment.Range.Text
    
    ActiveDocument.TrackRevisions = True
    ActiveDocument.TrackMoves = True
    ActiveDocument.TrackFormatting = True

End Sub

'Allows the user to open a file from the parent folder.
Function showOpenFileDialogParentFolder() As String

    Dim dialogResult As Integer
    
    Dim newPath As String
    newPath = Mid(ActiveDocument.path, 1, InStrRev(ActiveDocument.path, "\") - 1)

    Application.FileDialog(msoFileDialogOpen).AllowMultiSelect = False
    Application.FileDialog(msoFileDialogOpen).InitialFileName = newPath + "\"

    dialogResult = Application.FileDialog(msoFileDialogOpen).Show
    If dialogResult <> 0 Then
        showOpenFileDialogParentFolder = Application.FileDialog(msoFileDialogOpen).SelectedItems(1)
    End If
    
End Function
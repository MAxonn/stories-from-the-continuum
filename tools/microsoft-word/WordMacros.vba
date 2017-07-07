#If VBA7 Then ' Excel 2010 or later
 
    Public Declare PtrSafe Sub Sleep Lib "kernel32" (ByVal Milliseconds As LongPtr)
 
#Else ' Excel 2007 or earlier
 
    Public Declare Sub Sleep Lib "kernel32" (ByVal Milliseconds As Long)
 
#End If

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
    oldFile = ActiveDocument.Path + "\" + ActiveDocument.Name
    
    Dim documentNameWithoutExtension As String
    documentNameWithoutExtension = Mid(ActiveDocument.Name, 1, InStrRev(ActiveDocument.Name, ".") - 1)
    
    Dim newPath As String
    newPath = Mid(ActiveDocument.Path, 1, InStrRev(ActiveDocument.Path, "\") - 1)
    
    Dim newFileName As String
    newFileName = newPath + "\" + documentNameWithoutExtension + ".stseg"
    
    'Used to return to previous location after exporting the text.
    ActiveDocument.Bookmarks.Add "OSLTMPRESTORECURSOR"

    Application.ScreenUpdating = False
    
    'Save this document and only after that delete all comments as we don't want these exported.
    ActiveDocument.Save
    'Stripping away comments.
    If ActiveDocument.Comments.Count > 0 Then ActiveDocument.DeleteAllComments
    
    'Now save as it as the exported segment, and then close the saved as so that we can to return to the old document.
    ActiveDocument.SaveAs2 FileName:=newFileName, FileFormat:=wdFormatText, _
                           LockComments:=False, Password:="", AddToRecentFiles:=False, WritePassword _
                           :="", ReadOnlyRecommended:=False, EmbedTrueTypeFonts:=False, _
                           SaveNativePictureFormat:=False, SaveFormsData:=False, SaveAsAOCELetter:= _
                           False, Encoding:=65001, InsertLineBreaks:=False, AllowSubstitutions:= _
                           False, LineEnding:=wdCRLF, CompatibilityMode:=0
    ActiveDocument.Close
    
    'Return to old document and restore selection.
    Documents.Open oldFile
    
    Application.ScreenUpdating = True
    
    Selection.GoTo what:=wdGoToBookmark, Name:="OSLTMPRESTORECURSOR"
    
    For i = ActiveDocument.Bookmarks.Count To 1 Step -1
      If ActiveDocument.Bookmarks(i).Name = "OSLTMPRESTORECURSOR" Then ActiveDocument.Bookmarks(i).Delete
    Next
    
    On Error GoTo RetrySave

    'Saving the removed bookmark, so that the document doesn't prompt for save. No changes have been made anyway.
    ActiveDocument.Save
    Exit Sub
    
'Sometimes the save fails, probably due to DropBox file sync. Retrying save if it failed.
RetrySave:

    Sleep 2000
    ActiveDocument.Save
    
End Sub

'Exports the contents of the document as a text file, into the parent folder of the current folder because
'that's where the segments are usually located.
'The exported data is a snapshot of the text in the document, WITH FORMATTING, and with
'all changes accepted (even if the changes weren't accepted yet).
Sub ExportStorySegmentNew()
'
' ExportStorySegmentNew Macro
'
'

    '@@@@@@@@@@@@@@@@@@@@@@@@@@
    'Setup.
    
    Dim oldFile As String
    oldFile = ActiveDocument.Path + "\" + ActiveDocument.Name
    
    Dim documentNameWithoutExtension As String
    documentNameWithoutExtension = Mid(ActiveDocument.Name, 1, InStrRev(ActiveDocument.Name, ".") - 1)
    
    Dim newPath As String
    newPath = Mid(ActiveDocument.Path, 1, InStrRev(ActiveDocument.Path, "\") - 1)
    
    Dim newFileName As String
    newFileName = newPath + "\" + documentNameWithoutExtension + ".stseg"
    
    'Used to return to previous location after exporting the text.
    ActiveDocument.Bookmarks.Add "OSLTMPRESTORECURSOR"
    
    'Save this document and only after that delete all comments & accept revisions.
    'We don't actually want to tamper with those, we only want the document to be "clean" before saving.
    ActiveDocument.Save
    'Stripping away comments & accepting all revisions.
    If ActiveDocument.Comments.Count > 0 Then ActiveDocument.DeleteAllComments
    ActiveDocument.AcceptAllRevisions
    
    'Remove any pre-existing file (overwriting doesn't seem to work).
    DeleteFile newFileName
    
    'Prepare new file.
    Dim objStreamUTF8: Set objStreamUTF8 = CreateObject("ADODB.Stream")
    objStreamUTF8.Charset = "UTF-8"
    objStreamUTF8.Mode = adSaveCreateOverWrite
    objStreamUTF8.Open
    
    '@@@@@@@@@@@@@@@@@@@@@@@@@@
    'Parse text line by line.
    
    Dim p As Paragraph
    For Each p In ActiveDocument.Paragraphs
        
        'Save all bolded words.
        Dim processedLine As String
        Dim bolds() As String
        Dim locations() As Long
        Dim i As Integer
        Dim location As Long
        i = 0
        location = 0
        
        For Each aSentence In p.Range.Sentences
          For Each aWord In aSentence.Words
            If aWord.Bold = True Then
              ReDim Preserve bolds(i)
              ReDim Preserve locations(i)
              bolds(i) = aWord
              locations(i) = location
              i = i + 1
            End If
            'Make sure we keep track of the current location.
            location = location + Len(aWord)
          Next
        Next
        
        processedLine = p.Range.Text
        
        'Update processedLine so that it reflects bolded characters.
        i = 0
        If Not IsVarArrayEmpty(bolds) Then
            For Each aBold In bolds
              'Will only replace words from the current location onwards.
              Dim test As Long
              test = locations(i)
              Dim test2 As String
              test2 = bolds(i)
              Dim firstPartOfString As String
              firstPartOfString = Mid(processedLine, 1, locations(i) - 1)
              processedLine = firstPartOfString + Replace(processedLine, Trim(aBold), "**" + Trim(aBold) + "**", locations(i), 1)
              i = i + 1
            Next
        End If
        
        objStreamUTF8.WriteText processedLine
        
        Erase bolds, locations
    
    Next p
    
    'Save & flush file.
    objStreamUTF8.Position = 0
    objStreamUTF8.SaveToFile newFileName
    objStreamUTF8.Flush
    objStreamUTF8.Close
    
    '@@@@@@@@@@@@@@@@@@@@@@@@@@
    'Finalize.
    
    ActiveDocument.Close SaveChanges:=wdDoNotSaveChanges
    'Return to old document and restore selection.
    Documents.Open oldFile
    Selection.GoTo what:=wdGoToBookmark, Name:="OSLTMPRESTORECURSOR"
    For i = ActiveDocument.Bookmarks.Count To 1 Step -1
      If ActiveDocument.Bookmarks(i).Name = "OSLTMPRESTORECURSOR" Then ActiveDocument.Bookmarks(i).Delete
    Next

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
    
    'Rename the template as something else.
    Dim storySegmentNameWithoutExtension As String
    storySegmentNameWithoutExtension = Mid(storySegment.Name, 1, InStrRev(storySegment.Name, ".") - 1)
    
    Dim newFileName As String
    newFileName = ActiveDocument.Path + "\" + storySegmentNameWithoutExtension + ".htm"
    
    ActiveDocument.SaveAs2 FileName:=newFileName, FileFormat:=wdFormatHTML, _
                           LockComments:=False, Password:="", AddToRecentFiles:=True, _
                           WritePassword:="", ReadOnlyRecommended:=False, EmbedTrueTypeFonts:=False, _
                           SaveNativePictureFormat:=False, SaveFormsData:=False, SaveAsAOCELetter:= _
                           False, CompatibilityMode:=0
    
    'Turn tracking back on.
    ActiveDocument.TrackRevisions = True
    ActiveDocument.TrackMoves = True
    ActiveDocument.TrackFormatting = True

    storySegment.Close 'Politely closing the imported story segment.
End Sub

'Allows the user to open a file from the parent folder.
Function showOpenFileDialogParentFolder() As String

    Dim dialogResult As Integer
    
    Dim newPath As String
    newPath = Mid(ActiveDocument.Path, 1, InStrRev(ActiveDocument.Path, "\") - 1)

    Application.FileDialog(msoFileDialogOpen).AllowMultiSelect = False
    Application.FileDialog(msoFileDialogOpen).InitialFileName = newPath + "\"

    dialogResult = Application.FileDialog(msoFileDialogOpen).Show
    If dialogResult <> 0 Then
        showOpenFileDialogParentFolder = Application.FileDialog(msoFileDialogOpen).SelectedItems(1)
    End If
    
End Function

Function FileExists(ByVal FileToTest As String) As Boolean
   FileExists = (Dir(FileToTest) <> "")
End Function

Sub DeleteFile(ByVal FileToDelete As String)
   If FileExists(FileToDelete) Then 'See above
      ' First remove readonly attribute, if set
      SetAttr FileToDelete, vbNormal
      ' Then delete the file
      Kill FileToDelete
   End If
End Sub

Function IsVarArrayEmpty(anArray As Variant)

Dim i As Integer

On Error Resume Next
    i = UBound(anArray, 1)
If Err.Number = 0 Then
    IsVarArrayEmpty = False
Else
    IsVarArrayEmpty = True
End If

End Function

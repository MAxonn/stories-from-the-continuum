'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
'@@@@@@@@@@@@@@@ WIN32 API DECLARATIONS
'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

#If VBA7 Then ' Excel 2010 or later
 
    Public Declare PtrSafe Sub Sleep Lib "kernel32" (ByVal Milliseconds As LongPtr)
 
#Else ' Excel 2007 or earlier
 
    Public Declare Sub Sleep Lib "kernel32" (ByVal Milliseconds As Long)
 
#End If

'Combines multiple stories into a single story.
'IMPORTANT: this macro is to be executed by a template-COLOR.htm file located in any story's "compiled" directory.
'If a story does not have such a directory, it can be created and in it the template-COLOR.htm (and
'optionally the footer-COLOR.htm) can be copied in there. The files can be found here: stories-from-the-continuum\tools\microsoft-word\
Sub CombineStories()
'
' CombineStories Macro
'
'

    '@@@@@@@@@@@@@@@@@@@@@@@@@@
    'Construct and save various vital paths & file names
    
    Dim launchingDocumentFileFullPath As String
    launchingDocumentFileFullPath = ActiveDocument.FullName
    
    Dim launchingDocumentPath As String 'The path where the current document is located.
    launchingDocumentPath = ActiveDocument.Path
    
    Dim documentParentPath As String 'The Document Parent Path is in fact the Book path.
    documentParentPath = Mid(ActiveDocument.Path, 1, InStrRev(ActiveDocument.Path, "\") - 1)
    
    'Extracting the book name.
    Dim bookName As String
    bookName = Mid(documentParentPath, InStrRev(documentParentPath, "\") + 1)
    
    'Using the story name, we can infer the name that the ST Data (Story Teller Data) file has. We will need this to compose the story ST Data path.
    Dim bookNameWithoutNumberPrefix As String
    bookNameWithoutNumberPrefix = Mid(bookName, InStr(1, bookName, "-") + 1)
    bookNameWithoutNumberPrefix = Mid(bookNameWithoutNumberPrefix, InStr(1, bookNameWithoutNumberPrefix, "-") + 1)
    
    'Composing book name data file name.
    Dim bookDataFile As String
    bookDataFile = documentParentPath & "\" & bookNameWithoutNumberPrefix & "-data.json"
    
    '@@@@@@@@@@@@@@@@@@@@@@@@@@
    'Read story information from ST Data file.

    'Open the JSON file that describes the components of this book.
    Dim FileNum As Integer
    Dim fileLine As String
    FileNum = FreeFile()
    Open bookDataFile For Input As #FileNum
    
    'Extract information from the JSON file.
    
    Dim bookNameFromJSONData As String 'Will store the title of the story that owns all documents that we're about to combine.
    Dim bookNameFound As Boolean
    bookNameFound = False
    'Array to store information about all HTML files that we need to process.
    Dim storySTDATAFilesFullPath() As String
    Dim totalStoryFiles As Integer
    totalStoryFiles = 0
        
    'Go through the file line by line.
    While Not EOF(FileNum)
        Line Input #FileNum, fileLine
        
        'Hunt for the book name.
        If Not bookNameFound And InStr(1, fileLine, """") <> 0 Then
            bookNameFromJSONData = Mid(fileLine, InStr(1, fileLine, """") + 1)
            bookNameFromJSONData = Mid(bookNameFromJSONData, 1, InStr(1, bookNameFromJSONData, """") - 1)
            bookNameFound = True
        End If
        
        'Stop at lines that mention URLs for ST Data (Story Teller Data) files. The format of such a line is:
        '"stdata-url": "01-a-source-of-creation/data/a-source-of-creation.stdata.js"
        'Of course, if the format changes, this will crash.
        If InStr(1, fileLine, """stdata-url"":") <> 0 Then
            'Extracting the path where the ST Data file is located & process it.
            Dim storyDataFileRelativePath As String
            storyDataFileRelativePath = Trim(Mid(fileLine, InStr(1, fileLine, """stdata-url"":") + 13))
            storyDataFileRelativePath = Trim(Mid(storyDataFileRelativePath, 2, Len(storyDataFileRelativePath) - 2))
            storyDataFileRelativePath = Replace(storyDataFileRelativePath, "/", "\")
            
            'Save all data files involved in a book.
            ReDim Preserve storySTDATAFilesFullPath(totalStoryFiles)
            storySTDATAFilesFullPath(totalStoryFiles) = documentParentPath & "\" & storyDataFileRelativePath
            totalStoryFiles = totalStoryFiles + 1
        End If
    Wend
    
    '@@@@@@@@@@@@@@@@@@@@@@@@@@
    'Create combined document.
    
    'This IS the template.
    Dim templateDocumentFullPath As String
    templateDocumentFullPath = ActiveDocument.FullName
    
    'Create Document to merge all the changes in. If there is a tempalte defined, using it.
    Dim combinedDoc As Word.Document
    If Dir(templateDocumentFullPath) <> "" Then
        Set combinedDoc = Documents.Open(templateDocumentFullPath)
    Else
        Set combinedDoc = Documents.Add(DocumentType:=wdNewBlankDocument)
    End If
    combinedDoc.TrackFormatting = False
    combinedDoc.TrackMoves = False
    combinedDoc.TrackRevisions = False
    
    'Add the title of the book into the document.
    Dim title As Paragraph
    Set title = combinedDoc.Range.Paragraphs.Add
    title.Style = Word.WdBuiltinStyle.wdStyleHeading1
    title.Range.Text = bookNameFromJSONData & vbCrLf & vbCrLf
    
    'This section is used to restrict how far the macro is processing.
    'Dim howFarToProcess As Integer
    'Dim currentDocument As Integer
    'currentDocument = 1
    'howFarToProcess = 1
    
    Dim i As Integer
    'Go through all ST (Story Teller) Data files.
    For i = 0 To totalStoryFiles - 1
    
        'If currentDocument <= howFarToProcess Then
    
            'Every story should be on its own page.
            Dim newPage As Paragraph
            Set newPage = combinedDoc.Range.Paragraphs.Add
            newPage.Range.InsertBreak Type:=Word.WdBreakType.wdPageBreak

            'Tracked files path.
            Dim trackedSegmentFilesPath As String
            trackedSegmentFilesPath = Mid(storySTDATAFilesFullPath(i), 1, InStrRev(storySTDATAFilesFullPath(i), "\")) & "tracked"
            'Open target Word HTML document, clean it up.
            Dim wordHTMLDocument As Word.Document
            'Using our own function for getting a document that contains a Story.
            Set wordHTMLDocument = GetStoryDocument(storySTDATAFilesFullPath(i), trackedSegmentFilesPath)
            
            'Copy.
            wordHTMLDocument.Activate
            'Copy processed document into our combined document.
            Selection.WholeStory
            Selection.Copy
            
            'Paste
            combinedDoc.Activate
            Selection.EndKey wdStory
            Selection.PasteSpecial , , , False, wdPasteHTML
            
            'Processed document has been stripped of changes, so of course it should NOT be saved on close.
            wordHTMLDocument.Close SaveChanges:=wdDoNotSaveChanges

            currentDocument = currentDocument + 1
        'End If
    
    Next i

    'Using our own function for adding a footer & compilation time to the end of the produced document.
    'Footer is optional and if not present, the function will skip it.
    AddFooterAndCompilationDateTime combinedDoc, launchingDocumentPath

    'Re-enable tracking of changes.
    combinedDoc.TrackFormatting = True
    combinedDoc.TrackMoves = True
    combinedDoc.TrackRevisions = True
    
    'Export data.
    combinedDoc.SaveAs2 FileName:=documentParentPath & "\" & bookName & ".pdf", FileFormat:=wdFormatPDF, _
                        LockComments:=False, Password:="", AddToRecentFiles:=False, WritePassword _
                        :="", ReadOnlyRecommended:=False, EmbedTrueTypeFonts:=False, _
                        SaveNativePictureFormat:=False, SaveFormsData:=False, SaveAsAOCELetter:= _
                        False, Encoding:=65001, InsertLineBreaks:=False, AllowSubstitutions:= _
                        False, LineEnding:=wdCRLF, CompatibilityMode:=0
                        
    combinedDoc.SaveAs2 FileName:=documentParentPath & "\" & bookName & ".docx", FileFormat:=wdFormatXMLDocument, _
                        LockComments:=False, Password:="", AddToRecentFiles:=False, WritePassword _
                        :="", ReadOnlyRecommended:=False, EmbedTrueTypeFonts:=False, _
                        SaveNativePictureFormat:=False, SaveFormsData:=False, SaveAsAOCELetter:= _
                        False, Encoding:=65001, InsertLineBreaks:=False, AllowSubstitutions:= _
                        False, LineEnding:=wdCRLF, CompatibilityMode:=0
    
    combinedDoc.Close SaveChanges:=wdDoNotSaveChanges
    'Return to original document.
    Documents.Open (launchingDocumentFileFullPath)
End Sub

'Combines multiple story segments into a single story document.
'IMPORTANT: this macro is to be executed from within any of a story's segments, located inside a
'story's "data" directory.
Sub CombineDocuments()
'
' CombineDocuments Macro
'
'

    '@@@@@@@@@@@@@@@@@@@@@@@@@@
    'Construct and save various vital paths & file names.
    
    Dim launchingDocumentFileFullPath As String
    launchingDocumentFileFullPath = ActiveDocument.FullName
    
    Dim launchingDocumentPath As String 'The path where the current document is located.
    launchingDocumentPath = ActiveDocument.Path
    
    Dim documentParentPath As String 'The Document Parent Path is in fact the Story Data path.
    documentParentPath = Mid(ActiveDocument.Path, 1, InStrRev(ActiveDocument.Path, "\") - 1)
    
    'Obtaining main story path because that's where we can infer the story name from.
    Dim storyMainPath As String
    storyMainPath = Mid(documentParentPath, 1, InStrRev(documentParentPath, "\") - 1)
    
    'Extracting the story name.
    Dim storyName As String
    storyName = Mid(storyMainPath, InStrRev(storyMainPath, "\") + 1)
    
    'Using the story name, we can infer the name that the ST Data (Story Teller Data) file has. We will need this to compose the story ST Data path.
    Dim storyNameWithoutNumberPrefix As String
    storyNameWithoutNumberPrefix = Mid(storyName, InStr(1, storyName, "-") + 1)
    
    'Compose ST Data full path.
    Dim stDataFullPath As String
    stDataFullPath = documentParentPath & "\" & storyNameWithoutNumberPrefix & ".stdata.js"
        
    Dim storyDocument As Word.Document
    'Get the story document using our own special-built function.
    Set storyDocument = GetStoryDocument(stDataFullPath, launchingDocumentPath)
    'Using our own function for adding a footer & compilation time to the end of the produced document.
    'Footer is optional and if not present, the function will skip it.
    AddFooterAndCompilationDateTime storyDocument, launchingDocumentPath

    'Export data.
    storyDocument.SaveAs2 FileName:=storyMainPath & "\" & storyNameWithoutNumberPrefix & ".pdf", FileFormat:=wdFormatPDF, _
                        LockComments:=False, Password:="", AddToRecentFiles:=False, WritePassword _
                        :="", ReadOnlyRecommended:=False, EmbedTrueTypeFonts:=False, _
                        SaveNativePictureFormat:=False, SaveFormsData:=False, SaveAsAOCELetter:= _
                        False, Encoding:=65001, InsertLineBreaks:=False, AllowSubstitutions:= _
                        False, LineEnding:=wdCRLF, CompatibilityMode:=0
                        
    storyDocument.SaveAs2 FileName:=storyMainPath & "\" & storyNameWithoutNumberPrefix & ".docx", FileFormat:=wdFormatXMLDocument, _
                        LockComments:=False, Password:="", AddToRecentFiles:=False, WritePassword _
                        :="", ReadOnlyRecommended:=False, EmbedTrueTypeFonts:=False, _
                        SaveNativePictureFormat:=False, SaveFormsData:=False, SaveAsAOCELetter:= _
                        False, Encoding:=65001, InsertLineBreaks:=False, AllowSubstitutions:= _
                        False, LineEnding:=wdCRLF, CompatibilityMode:=0
    
    storyDocument.Close SaveChanges:=wdDoNotSaveChanges
    'Return to original document.
    Documents.Open (launchingDocumentFileFullPath)

End Sub

'Returns a Word Document that contains all of the Story Segments (STSEG), as listed in a story's Story Teller Data (STData) file.
'PARAM stDataFullPath: the full path to a stdata.js file (soon to be converted into stdata.json).
'PARAM launchingDocumentPath: the path where the document was launched from. This is important for two reasons:
'                             1. (and most important) the function will look for Word HTML documents in this path,
'                                based on the names of the Story Segments that it finds in the ST Data file.
'                             2. the function will use this path to attempt and use a template document which will
'                                become the combined document. For now, the template file name is hardcoded to "template-white.htm".
Function GetStoryDocument(stDataFullPath As String, launchingDocumentPath As String) As Word.Document

    '@@@@@@@@@@@@@@@@@@@@@@@@@@
    'Read story information from ST Data file.
        
    'Open ST Data file of the story to which this document belongs to.
    Dim FileNum As Integer
    Dim fileLine As String
    FileNum = FreeFile()
    'We are opening here the STORY NAME.stdata.js file. It is the JavaScript file that contains the story's Table of Contents.
    'In the future this will be a JSON.
    Open stDataFullPath For Input As #FileNum
    
    'Extract information from ST Data file.
    
    Dim storyTitleFromSTData As String 'Will store the title of the story that owns all documents that we're about to combine.
    'Array to store information about all HTML files that we need to process.
    Dim wordHTMLFiles() As String
    Dim totalHTMLFiles As Integer
    totalHTMLFiles = 0
    
    'Go through the file line by line.
    While Not EOF(FileNum)
        Line Input #FileNum, fileLine
        'Stop at lines that mention files. The format of such a line is:
        'SS_01_SFTC_JonasIsFlying_TOC.push( { file: "01.stseg", rawDescription: "1", authors: "Michael Axonn"} );
        'Of course, if the format changes, this will crash.
        If InStr(1, fileLine, "file:") <> 0 Then
          
          'Extracting the data file string.
          Dim dataFileString As String
          dataFileString = Trim(Mid(fileLine, InStr(1, fileLine, "file:") + 5))
          dataFileString = Mid(dataFileString, 2, InStr(2, dataFileString, """") - 2)
          'From it, only taking the name, not the extension, since that is how the Word HTML file is EXPECTED to be named.
          Dim dataFileStringWithoutExtension As String
          dataFileStringWithoutExtension = Mid(dataFileString, 1, InStr(1, dataFileString, ".") - 1)
          
          'Composing Word file name to open.
          Dim wordHTMLDocumentFullPath As String
          wordHTMLDocumentFullPath = launchingDocumentPath & "\" & dataFileStringWithoutExtension & ".htm"
          
          ReDim Preserve wordHTMLFiles(totalHTMLFiles)
          wordHTMLFiles(totalHTMLFiles) = wordHTMLDocumentFullPath
          totalHTMLFiles = totalHTMLFiles + 1
        End If
        
        'Hunt for the story title.
        If InStr(1, fileLine, "title:") <> 0 Then
          storyTitleFromSTData = Trim(Mid(fileLine, InStr(1, fileLine, "title:") + 6))
          storyTitleFromSTData = Mid(storyTitleFromSTData, 2, InStr(2, storyTitleFromSTData, """") - 2)
        End If
    Wend
    
    '@@@@@@@@@@@@@@@@@@@@@@@@@@
    'Create combined document.
    
    'Compose Document Template path. If it is valid, we will use whatever Document Template is already used.
    Dim templateDocumentFullPath As String
    templateDocumentFullPath = launchingDocumentPath & "\template-white.htm"
    'Create Document to merge all the changes in. If there is a tempalte defined, using it.
    Dim combinedDoc As Word.Document
    If Dir(templateDocumentFullPath) <> "" Then
        Set combinedDoc = Documents.Open(templateDocumentFullPath)
    Else
        Set combinedDoc = Documents.Add(DocumentType:=wdNewBlankDocument)
    End If
    combinedDoc.TrackFormatting = False
    combinedDoc.TrackMoves = False
    combinedDoc.TrackRevisions = False
    
    combinedDoc.Range.Style = Word.WdBuiltinStyle.wdStyleHeading1
    combinedDoc.Range.Text = storyTitleFromSTData & vbCrLf
    
    'This section is used to restrict how far the macro is processing.
    'Dim howFarToProcess As Integer
    'Dim currentDocument As Integer
    'currentDocument = 1
    'howFarToProcess = 1
    
    Dim i As Integer
    For i = 0 To totalHTMLFiles - 1
    
        'If currentDocument <= howFarToProcess Then
        
            'Open target Word HTML document, clean it up.
            Dim wordHTMLDocument As Word.Document
            Set wordHTMLDocument = Documents.Open(wordHTMLFiles(i))
            wordHTMLDocument.Activate
            wordHTMLDocument.AcceptAllRevisions
            'Stripping away comments.
            If wordHTMLDocument.Comments.Count > 0 Then wordHTMLDocument.DeleteAllComments
            
            'Copy processed document into our combined document.
            Selection.WholeStory
            Selection.Copy
            
            'Paste
            combinedDoc.Activate
            Selection.EndKey wdStory
            Selection.PasteSpecial , , , False, wdPasteHTML
            
            'Processed document has been stripped of changes, so of course it should NOT be saved on close.
            wordHTMLDocument.Close SaveChanges:=wdDoNotSaveChanges

            currentDocument = currentDocument + 1
        'End If
    
    Next i

    'Re-enable tracking of changes.
    combinedDoc.TrackFormatting = True
    combinedDoc.TrackMoves = True
    combinedDoc.TrackRevisions = True
    
    Set GetStoryDocument = combinedDoc
End Function

'Inside a Word Document, adds a footer (optional) and the current date & time.
'PARAM targetDocument: the document into which to add these.
'PARAM launchingDocumentPath: the path where the document was launched from. This is used to find the footer file.
'                             The footer is currently hardcoded to "footer-white.htm". If this file is not found,
'                             no footer will be added. Therefore passing nothing here will cause the footer to be skipped.
Sub AddFooterAndCompilationDateTime(targetDocument As Word.Document, launchingDocumentPath As String)
    
    targetDocument.TrackFormatting = False
    targetDocument.TrackMoves = False
    targetDocument.TrackRevisions = False
    
    'Compose Document Footer path. If it is valid, no Footer will be added
    Dim footerDocumentFullPath As String
    footerDocumentFullPath = launchingDocumentPath & "\footer-white.htm"
    Dim wordHTMLDocumentFooter As Word.Document
    If Dir(footerDocumentFullPath) <> "" Then
        Set wordHTMLDocumentFooter = Documents.Open(footerDocumentFullPath)

        wordHTMLDocumentFooter.Activate
        'Copy processed document into our combined document.
        Selection.WholeStory
        Selection.Copy
        targetDocument.Activate
        Selection.EndKey wdStory
        Selection.PasteSpecial , , , False, wdPasteHTML
        
        'Processed document has been stripped of changes, so of course it should NOT be saved on close.
        wordHTMLDocumentFooter.Close SaveChanges:=wdDoNotSaveChanges
    End If

    'Add information about when the file was compiled.
    Dim compiledOn As Paragraph
    Set compiledOn = targetDocument.Range.Paragraphs.Add
    compiledOn.Style = Word.WdBuiltinStyle.wdStyleBodyText
    compiledOn.Range.Italic = True
    compiledOn.Range.Text = vbCrLf & vbCrLf & vbCrLf & "Compilation date: " & Format(Now(), "yyyy-MM-dd hh:mm:ss")
    
    targetDocument.TrackFormatting = True
    targetDocument.TrackMoves = True
    targetDocument.TrackRevisions = True
End Sub

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
    
    Dim documentParentPath As String 'The Document Parent Path is in fact the Story Data path.
    documentParentPath = Mid(ActiveDocument.Path, 1, InStrRev(ActiveDocument.Path, "\") - 1)
    
    Dim newFileName As String
    newFileName = documentParentPath + "\" + documentNameWithoutExtension + ".stseg"
    
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
    
    Dim documentParentPath As String 'The Document Parent Path is in fact the Story Data path.
    documentParentPath = Mid(ActiveDocument.Path, 1, InStrRev(ActiveDocument.Path, "\") - 1)
    
    Dim newFileName As String
    newFileName = documentParentPath + "\" + documentNameWithoutExtension + ".stseg"
    
    'Used to return to previous location after exporting the text.
    ActiveDocument.Bookmarks.Add "OSLTMPRESTORECURSOR"
    
    'Save this document and only after that delete all comments & accept revisions.
    'We don't actually want to tamper with those, we only want the document to be "clean" before saving.
    On Error GoTo RetrySave
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
        
        'Save all bolded locations.
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
        
        'Line endings are only vbCr, so making it windows-friendly.
        processedLine = Replace(processedLine, vbCr, vbCrLf)
        
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
    'So it doesn't annoy us with save prompts.
    ActiveDocument.Save

    Exit Sub

'Sometimes the save fails, probably due to DropBox file sync. Retrying save if it failed.
RetrySave:

    Sleep 2000
    ActiveDocument.Save
    Resume Next
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

'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
'@@@@@@@@@@@@@@ UTILITY FUNCTIONS
'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

'Allows the user to open a file from the parent folder.
Function showOpenFileDialogParentFolder() As String

    Dim dialogResult As Integer
    
    Dim documentParentPath As String
    documentParentPath = Mid(ActiveDocument.Path, 1, InStrRev(ActiveDocument.Path, "\") - 1)

    Application.FileDialog(msoFileDialogOpen).AllowMultiSelect = False
    Application.FileDialog(msoFileDialogOpen).InitialFileName = documentParentPath + "\"

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



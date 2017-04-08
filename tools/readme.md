# 0. Introduction

This folder contains various tools useful in the process of writing or managing stories in the project.

Summary of tools:

1. Microsoft Word Macros
2. Microsoft Word Tracking HTML Template

# 1. Microsoft Word Macros

Most software developers cringe when they hear the words "Visual Basic". Still, this is the ancient technology used when coding macros for Microsoft Word. But ancient or not, it does its job. Even more people might cringe at the word "Microsoft".

Despite it necessitating a license, Microsoft Word is a powerful text editor that has the very important feature of tracking changes in a document while also keeping them visible until necessary. There is also the useful feature of adding comments in the document. All this is also available when working with documents in an open format such as HTML, which was an important aspect when I decided that I can keep using Word for some of my editing needs. LibreOffice is a free alternative but I'm not sure if it allows for tracking changes in HTML files.

Macros can apparently be coded using LibreOffice too, but I had stability issues the last time when using that software so for now I'm going to stick to Microsoft Word and perhaps somebody offers to port the macros to LibreOffice.

There are 2 macros provided for the time being. 

ExportStorySegment exports the contents of a document as a text file, into the parent folder of the current folder because that's where the story segments are usually located. The exported data is a snapshot of the text in the document, stripped of all formatting and with all changes accepted (even if the changes weren't accepted yet).

ImportStorySegment Imports the chosen story segment into this file. This is usually done when the template.html is opened. The macro will show the Open File dialog for the parent folder of the current folder because that's where the story segments are usually located. This will also automatically rename the template with the same name as the opened story segment (but using the `.htm` extension).

### 1.1 Known issues

If there are comments in a Word HTML document, these will actually be exported along with the text. I'll probably modify the export macro soon so that it is stripping comments away before export and adding them back after the export.

# 2. Microsoft Word Tracking HTML Template

When there is a need to track changes while editing a segment, use the above macros in order to work with story segments and Microsoft Word. The template is to be placed inside a `'/tracked'` folder inside the `'/data'` folder of any story. If the folder doesn't already exist, create it.

Once the template is there and once you imported the macros provided here, you will be able to load any story segment into the template. The template will immediately save itself with the new story segment file name and you can commence modifications. You can, at any point, export the modifications back into story segments using the provided macro.

The template uses a black background. You can of course change that in your own branch, as well as any other settings such as font.
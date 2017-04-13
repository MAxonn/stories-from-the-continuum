# 0. Introduction

This folder contains various tools useful in the process of writing or managing stories in the project.

Summary of tools:

1. The Static Content Generator
2. Microsoft Word Tracking HTML Template
3. Microsoft Word Macros

# 1. The Static Content Generator

The script for Windows is available here: `'/static-content-generator/storyBuilder.bat'`. It is important to note that it **cannot** be run from here. This is just the script and the data it uses (HTML header and footer). The script must be run by being called by a `buildStory.bat` file located inside a story's folder.

The script file is currently provided only in Windows Batch but a Bash version will eventually be avaialble.

This is a script that can be used to generate HTML files that contain all the Segments of a story. It is easy to distribute such a file, but it will need to be re-generated if changes are done to the Segments of the story. It is recommended for an author to try and regenerate these files at important commits for a certain story.

These files are also meant for use when the Story Teller cannot be used. Especially when using the Story Teller locally, there are security restrictions by web browsers. Even though there currently are workarounds for that, some people might not want to apply them or perhaps in the future the workarounds will not work :). Therefore, all stories have a "launcher" script file that will use the script file in the `'/static-content-generator'` folder in order to generate a "static" HTML page.

# 2. Microsoft Word Tracking HTML Template

Some authors require tracking of changes while editing a text due to the advantage of having immediate visual feedback for changes. Microsoft Word can be used for this, as it provides a way to save documents as HTML (thus, keeping an open format).

To this end, a generic document editing template is provided. It is an HTML file that has tracking enabled. The template uses a black background. You can of course change that in your own branch, as well as any other settings such as font.

For your convenience, there are some VBA macros provided (see below) in order to make work easier with Story Segments and Microsoft Word. These macros automate most of the manual tasks of importing and exporting data from and to files that have the `.stseg` Story Segment extension (which is a plain Unicode text file).

The template is to be placed inside a `'/tracked'` folder inside the `'/data'` folder of any story. If the folder doesn't already exist, create it.

Once the template is there and once you imported the macros provided here into your Microsoft Word installation, you will be able to (more) easily load any Story Segment into the template and export it once you've done your work.

# 3. Microsoft Word Macros

Most software developers cringe when they hear the words "Visual Basic". Still, this is the ancient technology used when coding macros for Microsoft Word. But ancient or not, it does its job. Even more people might cringe at the word "Microsoft".

Despite it necessitating a license, Microsoft Word is a powerful text editor that has the very important feature of offering visual tracking of changes done to a document. There is also the useful feature of adding comments in the document. All this is also available when working with documents in an open format such as HTML, which was an important aspect when I decided that I can keep using Word for some of my editing needs. LibreOffice is a free alternative but I'm not sure if it allows for tracking changes in HTML files.

Macros can apparently be coded using LibreOffice too, but I had stability issues the last time when using that software so for now I'm going to stick to Microsoft Word and perhaps somebody offers to port the macros to LibreOffice.

There are 2 macros provided for the time being. You will find them in `'/microsoft-word/WordMacros.vba'`. You can open this file with any text editor and then import the Macros into Word by going to the `View tab` of the `Ribbon UI` and choosing `Macros -> View Macros`. If you have any macros already, go ahead and edit any one of them. If you do not see any macros in the list, then you must type some random name for a Macro such as `Test` and press on the `Create` button. You can then delete the newly created empty `Test` macro and paste in the text in `WordMacros.vba`.

Now you have added the Macros to your Word installation. It is recommended that you create buttons for the Macros on your Ribbon UI and, optionally, add keyboard shortcuts for these. You can do this by right clicking the Ribbon UI and select `Customize the Ribbon`.

Go ahead and create a `new Tab` and a `new Group` inside it (or a `New Group` inside any existing tab). Then, direct the listbox on the left (`Choose commands from`) to show you `macros` (instead of the default which is `Popular Commands`). Then you can move the macros into the `new Group` that you created. 

You can click on the `Rename` button to customize Macro name and icon.

Here is a description of the two macros currently provided.

### 3.1 ImportStorySegment

Imports the chosen Story Segment into the current Word Document. This is usually done when the template.html is opened. The macro will show the Open File dialog for the parent folder of the current folder because that's where the Story Segments are usually located. This will also automatically rename the template with the same name as the opened Story Segment (but using the `.htm` extension).

### 3.2 ExportStorySegment

Exports the contents of the currently edited Word document as a text file, into the parent folder of the current folder because that's where the Story Segments are usually located (because the Word files should be in the "tracked" folder or some other subfolder of `'/data'`. The exported data is a snapshot of the text in the document, stripped of all formatting and with all changes accepted (even if the changes weren't accepted yet). Comments will NOT be exported.

As part of the export process, the document will flicker and scroll position might change because the document is reopened after being "saved-as" (since apparently it can't be saved as a new file without switching to that file).
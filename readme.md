# 1. Introduction

If you're here just for the literature aspect of the project (**you just want to read the stories**), then skip to **number 4** below.

Otherwise, welcome to a ReadMe.md file written by a Dual Class (Writer / Software Engineer) character.

# 2. Why Open Source Literature?

The purpose of Open Source Literature is for anybody to easily contribute to a certain text or to submit corrections to it using a public platform that features **branching** and **versioning**. Especially branching is important, because it offers the possibility of exploding a work into myriad variants.

The intent of Open Source Literature is to create a living, evolving body of work. We are long past the time when a published text should forever be locked into a certain shape.

It's true that a work of literature is much less modular than a software program. Changes can have much more serious repercussions upon the overall result, especially because a text leads to the creation of an imaginary projection. But Open Source is all about unlocking the potential of experimentation. It is that spirit which brought these words here.

# 3. Stories from the Continuum

Stories from the Continuum is a perpetually changing creature of thought. There won't be any "final version" for any text. Instead, this project embraces the software definition of a "release". There will be releases (especially when I publish a story), but the work is always subject to change.

Because the balance of a story is a delicate affair, even though this repository is public, as the author of these stories, I will maintain a rather strict control over what it contains. However, since this is on GitHub, anybody can fork the repository and create completely independent stories should the desire ever arise.

This is also an experiment of how Open Source Literature could work and what would be a good way for it to be implemented by other authors.

Stories from the Continuum is well suited for Open Source because it consists of a very large and diverse Universe. As it will soon be apparent, there will be a lot of room for contribution here.

# 4. Read The Stories, Plain and Simple

The fastest way to read the stories here is to simply download the HTML files marked with `-OFFLINE` inside each story's folder. You can also download or clone this entire repository and open the `-OFFLINE` files in your browser.

If changes are made to a story, the `-OFFLINE` files are usually re-generated. If they are not, you can use a script located inside the story folder to re-generate the HTML `-OFFLINE` file. Use `buildHTML.bat` on Windows. A Linux/Mac bash script will eventually be available.

In all fairness, you could read the stories even without a web browser. You just need a program that can read text :). The stories are split into segments that are available inside each story's `'/data'` folder. Even though they have the `.stseg` extension (chosen so that you can associate a particular text editor with them), these segments are plain text files that can be opened by any program that can interpret text (and all operating systems have at least one such program).

# 5. Too Technical for Literature?

A question like this may inevitably arise at one point: some writers aren't technical people, how will they use a version control system? I think most writers today use a computer. Using a version control system is as easy as installing a word processor. Cloning a repository is as easy as downloading a program. Perhaps there are a few more commands involved, but they are well documented and I believe, easy enough to understand by somebody that is writing literature.

A similar question is: **why** would a writer work with a version control system? I believe many writers already do that in one way or another. A full-fledged version control system such as GIT allows **me** as a writer to keep my experiments in branches, to version them, to freely toy around with all my creation **without** having to delete anything. There is also an advantage in being able to visualize all these. There is a lot of software for exploring and viewing the branches and history of versioned repositories.

I don't think version control is too technical. It **is** technical, yes, but the benefits are great and the learning curve isn't that steep. Some reading on what version control is might be required by some, but it's worth it.

Why GitHub? Because it's clean, reliable, well-known, well-supported and because GIT is one of the best version control systems.

# 6. Structure

In order to facilitate contribution, there is a system in place that allows all texts to be split into arbitrary segments (not necesarily chapters). In the same time, it is important that the texts are easily readble or compilable into different formats. Everything is based on open standards. The stories are written in plain Unicode text files and can be read using the provided HTML files. The work-in-progress name of the system is **Story Teller**.

The stories are usually split into segments. These segments are files that are located inside the `'/data'` folder of each story and have the .stseg extension (Story Teller Segment). Naturally, thanks to GIT, all segments will have their own separate history. Feel free to associate the .stseg extension with your favorite text editor, as these are nothing more but plain text files using the Unicode standard.

Each story has an HTML file in its folder. The file will list all the segments in the story. Information about the segments is found in the `'/data'` folder, inside a JavaScript file with the same name as the story and suffixed with .stdata  (Story Teller Data). The file describes the segments that make up the story as well as some other story metadata.

There are also HTML files that offer access to multiple stories.

The `'storyteller'` folder contains the JavaScripts that handle loading story data, segments and displaying the stories in a unitary way (not segmented).

The `'.idea'` folder as well as the `stories-from-the-continuum.iml` file in the repository are there because I use IntelliJ to work on the Story Teller.

#### 6.1 Internal Document Tracking (AKA Cross-Commit Change Tracking)

A common feature of advanced text processors is to keep track of changes in a document or to leave comments in a document. This feature is quite important to me when I'm editing drafts. Binary formats are not good friends with versioning control, but fortunately at least one decent text processors can perform all this work in an open format. (perhaps) Unfortunately, that program is Microsoft Word, not exactly cheap software.

Since I have no time now to investigate LibreOffice capabilities (also considering I had poor experience running it under Windows), for now I've only integrated the use of Microsoft Word into this Open Source Literature workflow. By integration I mean that there are some macros and a template provided that can be used to easily transfer work to and from story segments.

Since this document tracking feature is not directly related to the Story Teller, the files pertaining to tracking for a story should be located in the story's `'/data/tracked'` folder. This disconnection should be seen as an advantage, since it doesn't pollute the simplicity of text files while in the same time allowing users to work in formats that are widely accepted by publishers. Word `HTML` files for example can easily be saved back to `Doc` or `DocX` (a format many publishers use).

Why use document tracking if GIT already provides this from commit to commit? Because it's an advantage to have immediate visual feedback of changes done while editing a draft and return to them later, without necessarily losing them after a commit has been made. By decoupling document tracking from the actual committed story segments, there are practically two complementary versioning systems available.

Regarding the "exotic" `.stseg` extension that story segments have: don't panic. Any such file can be loaded in Word as a Unicode text file.

**IMPORTANT**: please go and read the readme.md inside the `'/tools'` folder in order to learn more about Internal Document Tracking via Microsoft Word.

# 7. How to Use the Story Teller to Read

The Story Teller is the preferred way to navigate content in this repository. It presents a story by loading the actual segments and will soon be able to do much more than that.

First of all, clone this repository or download a zip containing it. For the less technical, downloading the zip should be enough. Cloning the repo requires you to install GIT but provides you with a connection to the repository, meaning you can easily update to the latest version and perform all the wonderful stuff a verision control system allows you to.

The Story Teller comes in the form of HTML files that you can open in your web browser in order to easily read any story. For the time being, however, there are some security workarounds that you might have to perform (unless you use Firefox which works fine even with this early version of the Story Teller).

NOTE: I'm working on getting the Story Teller available online somehow, but I haven't yet figured how to use GitHub in combination with my own hosting provider in order to achieve this.

### 7.2.1 Use only a web browser and local files

* Firefox: at the time of this writing (29th of March 2017), the latest version of Firefox **can** browse through the content with only a few complaints (visible only if you look in the developer console and that do not affect functionality).
* Chrome & Opera (both based on Chromium) will **refuse** to load any story segment (.stseg) file **unless you start the browser with this command line argument**: --allow-file-access-from-files
  * On Windows:
    chrome.exe --allow-file-access-from-files
		or
		opera.exe --allow-file-access-from-files
  * On Mac:
    open /Applications/Google\ Chrome.app/ --args --allow-file-access-from-files

### 7.2.2 Serve your local story files using a light-weight web server

For now, the cleanest way to use the Story Teller locally is to install a light-weight web server.

I recommend nginx @ http://nginx.org/en/download.html

##### Instructions for using Story Teller with nginx

After installing nginx, go into **nginx.conf**, go to the server block, into the location / block and set up the root. Here's, for example, my server block for running Story Teller locally on a Windows machine:

location / {
root   "d:\writing\stories-from-the-continuum";
index  index.html index.htm;
}

As you can see, I am serving the entire GIT repo for Stories from the Continuum. You can serve a parent folder if you'd like or if you already have a web server you can simply clone this repo somewhere in your static content.

### 7.2.3 Instruct the Story Teller to load remote files

Open **/storyteller/config/st-offline.js**

Change KST_REMOTE_URL to "http://michaelaxonn.com/st" (the line should already be there, uncomment it).

This will make the Story Teller attempt to load all files from the web-based mirror I'm currently running on my official website. This may or may not be available for you. It is also possibly a bit behind compared to the repo as I haven't made any steps towards mirroring repo files towards my website.

# 8. How to Contribute

Contributions are always welcome and will be treated fairly. Make a pull request and perhaps we'll talk about it. Or go wild and fork the thing - we can still talk about it :).

# 9. Suggested Software

I'm stuck on Windows due to software reasons so all the programs I'll recommend are Windows based.

To use the repository: TortoiseGit is a user-friendly GIT front-end.

To write: I fell in love with WriteMonkey, a wonderful zenware text editor.

# 10. About Michael Axonn

I'm the author that has published the first stories in this repository. For the time being, I'm the sole curator of Stories from the Continuum. However, for me, this project is more than an author's imaginary Universe. Only time will tell what this will evolve into. The history of this readme.md file will be fun to watch.

And yes, I'm a software developer as well. But the writer in me is the one who wrote this readme :).
# 1. Open Source Literature

As the name says, this repository contains stories from the Continuum. The purpose of having this in GIT is so that anybody can easily contribute to the texts or submit corrections. The intent is to create a living, evolving body of work. We are long past the time when a published text is forever locked into a certain shape.

Stories from the Continuum is a perpetually changing creature of thought. There won't be any "final version" for any text. Instead, this art embraces the software definition of a "release". There will be releases, but the work is always subject to change.

# 2. Structure

In order to facilitate contribution, there is a system in place that allows all texts to be split into arbitrary modules (not necesarily chapters). In the same time, it is important that the texts are  easily readble or compilable into different formats. The name of this sytem is **Story Teller**.

The stories are usually split into segments. These segments are files that are located inside the '/data' folder of each story and have the .stseg.txt extension (Story Teller Segment). Naturally, thanks to GIT, all segments will have their own separate history.

Each story has a .sttoc.html (Story Teller Table of Contents) file that lists the Story Teller Segments that make up the story. When the Story Teller reads the Table of Contents, it loads all segments and produces an easily readable HTML.

# 3. How to Read

First of all, clone the repo.

### 3.1 Read the stories segment by segment

The Table of Contents of each story (the .sttoc.html file located in each story folder) is the easiest way for a story to be read. Simply open the HTML file and load the different segments listed in the Table of Contents. This file is the "stand-alone light-weight" version of the Story Teller.

### 3.2 Use the Story Teller

The full version of the Story Teller provides a more "book" feel to a given story. It loads all the segments of a given story in the order specified by the Table of Contents.

NOTE: I'm working on getting the Story Teller available online somehow, but I haven't yet figured how to use GitHub in combination with my own host in order to achieve this.

The Story Teller itself can be launched by opening the **continuum.html** file (all work), or the **present.html** (stories in-development) file. However, due to security sandboxing in most browsers, there are various workarounds that you may have to do in order to get the Story Teller working on your machine.

#### 3.2.1 Use local files (requires working around security issues)

* Firefox: at the time of this writing (29th of March 2017), the latest version of Firefox **can** browse through the content with only a few complaints (visible only if you look in the developer console and that do not affect functionality).
* Chrome & Opera (both based on Chromium) will refuse to load the story segment (.stseg.txt) files unless you start the browser with this command line argument: --allow-file-access-from-files
  * On Windows:
    chrome.exe --allow-file-access-from-files
  * On Mac:
    open /Applications/Google\ Chrome.app/ --args --allow-file-access-from-files

#### 3.2.2 Use local files with a light-weight web server

The cleanest way to use the Story Teller locally is to install a light-weight web server.

I recommend nginx @ http://nginx.org/en/download.html

###### Instructions for using Story Teller with nginx

After installing nginx, go into **nginx.conf**, go to the server block, into the location / block and set up the root. Here's, for example, my server block for running Story Teller locally on a Windows machine:

location / {
root   "d:\writing\stories-from-the-continuum";
index  index.html index.htm;
}

As you can see, I am serving the entire GIT repo for Stories from the Continuum. You can serve a parent folder if you'd like or if you already have a web server you can simply clone this repo somewhere in your static content.

#### 3.2.3 Use remote files

Open **/storyteller/config/st.js**

Change KST_REMOTE_URL to "http://michaelaxonn.com/st".

This will make the Story Teller attempt to load all files from the web-based mirror I'm currently running on my official website.

# How to Contribute

Make a pull request, let's talk about it.

# Suggested Software

I'm stuck on Windows due to legacy reasons so all the software I'll recommend is Windows based.

I fell in love with WriteMonkey, a wonderful zenware text editor.

# About Michael Axonn

I'm the curator of this repository and the author that has published the first stories.
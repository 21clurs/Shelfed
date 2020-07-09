# Shelfed - README

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
An iOS application that will allow users to keep track of books/movies that they have read/watched and those they would like to see in the future. Users will be able to upload photos of their favorite quotes and moments as they progress through the book/movie and save these to their account, for easy personal reference.

### App Evaluation
- **Category:** Lifestyle
- **Mobile:** Ease of updating lists, uses camera
- **Story:** Allows users to keep track of their reading lists and goals and upload their own related media to keep track of their favorite memories.
- **Market:** Avid consumers of media: books/movies/shows.
- **Habit:** Users can update their to-read or to-watch lists whenever they see/hear about a book/movie/show that piques their interest. Users can also reference the app when trying to recall favorite quotes/moments.
- **Scope:** Shelfed will start with a narrower focus, just for books, and will expand to have similar functionalities for movies/shows. May exapnd to have additional features like recommendations and more categories to save media to.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Users can create a new account
* Users can login to their account
* Users can add and remove books to a 'have read' list
* Users can add and remove books to a 'to read' list
* Users can search for books within the app to add to these lists
    * Users will be able to add books to the lists and have relevant information added automatically without needing to input the data themselves (author, synopsis, etc.)
* Users can mark books as 'favorites'
* Users can upload photos and save them in association to the book they are related to
* Users can sort the view of their lists (e.g. by date added)

**Optional Nice-to-have Stories**

* Users can have all of the Must-have Story functionalities with movies and TV shows, in addition to books
* Users can rate titles (potentially also sort by these ratings)
* Users can see related books/movies/shows when accessing a certain entry
* Users can make custom lists and save content to these lists
    * Similar concept to a 'playlist' for music
* Users can see recommendations based on their preferences
* Users can edit photos before uploading them in-app (cropping, rotating)
* Users can browse genres

### 2. Screen Archetypes

* Login Screen
   * User can login if they have an account
   * User can be taken to the registration screen if they do not have an account
* Registration Screen
   * Users can create a new account
* Search
    * Users can search for titles to add to their list(s)
* Detail
    * Users can see details of a title when they click on it sucha as official cover art, author/director, synopsis
* Creation
    * Users can upload photos to associate with titles in their lists
* Profile
    * Users can see their profile information (username, name)
    * Users can see their uploaded content
    * Users can see their statistics -- how many titles have they seen this year, etc.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Search title
* To read list
* Have read list
* Profile

**Flow Navigation** (Screen to Screen)

* Login Screen
    * => Profile
* Registration Screen
    * => Profile
* Search
    * => Detail Screen
* Detail
    * => Creation (i.e. add a photo to this book)
* Creation
    * => Detail (with created content uploaded)
* Profile
    * => Creation (still attach it to the book that goes along with it)

## Wireframes
<img src="https://i.imgur.com/NUAmMzk.jpg" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
### Models
User (in addition to the automatically included properties)
 | Property        | Type     | Description |
 | -------------   | -------- | ------------|
 | toReadArray     | Array    | array of Books the user has added to their to-read list |
 | readingArray    | Array    | array of Books the user has added to their currently reading list |
 | haveReadArray   | Array    | array of Books the user has read |
 | profileImage    | File     | image that user has uploaded as their profile picture |
 | uploadedContent | Array    | array of Uploads that the user has uploaded to the app |
 
 Book
 | Property        | Type     | Description |
 | ------------    | -------- | ----------- |
 | title           | String   | title of the book |
 | author          | String   | author of the book |
 | coverArt        | File     | the cover art information of a book, if aplicable |
 | synopsis        | String   | synopsis of the book |
 | isbn            | String   | unique identifier for the book, potentially useful for retrieving information about it |
 
 Upload
 | Property        | Type     | Description |
 | ------------    | -------- | ----------- |
 | uploadedBy      | Pointer to User | user who uploaded the content
 | uploadImage     | File     | image that has been uploaded |
 | bookAssociated  | Pointer to Book | the book that the user has uploaded the content in relation to |
 | createdAt       | DateTime | date when the upload was created |
 | pageNum         | Number   | page number that the upload is associated with (optional) |
 | comment         | String   | any comments by the user regarding the upload (optional) |
 
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]

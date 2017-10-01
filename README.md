# memme-app
iOS Swift app "MemeMe": allows user to select image from camera or photo album, add text, and share as a meme.           

## Description:
User selects image from camera or photo album, adds text, then can share as a meme via the "usual" Apple sharing methods.

Images are saved for the current session only (closing the app removes the images from memory). However, via sharing, users can save the images to their photo album or other locations.

During the current session, users can see their created memes in a table view or a collection view, via a tab bar controller.

## Interesting Twists:
- Uses unwind segue to return from editor to either the table or collection view from which the user tapped Edit.
- Uses attributed text for meme creation.

<p align="center"><img src="https://raw.githubusercontent.com/pdt1806/DisLife/main/assets/images/icons/curved.png" width="20%"></img></p>
<h1 align="center">DisLife</h1>

<p align="center">Transform your Discord Rich Presence into a Locket-like experience: instantly share your moments with friends and peers!</p>

## The inspiration?

Showing people what you are doing at the moment is one of the features that can be seen in modern-day social media platforms, such as Stories on Instagram/Facebook or Locket. People can decide if they want to see the image or not, and it is also their choice to message you if they are interested. The absence of you texting others about what you are doing is what makes this feature the top choice of teenagers right now. Seeing this, I wondered if I could also do the same thing on Discord, allowing people to know what I am doing without me direct messaging them first. Rich Presence is a suitable place to implement something like this. Not to mention, before this project, I had no experience in developing mobile/cross-platform apps; DisLife was a chance for me to develop one.

## How to Setup and Use?

### 1. Set up the back-end server

Please refer to [this README](https://github.com/pdt1806/DisLife-backend/blob/main/README.md) in the back-end's repo on how to set up the back-end server.

### 2. Install

[To be written later]

### 3. Connect to the back-end

- Go to Settings -> API Endpoint
- Enter your API Endpoint (a valid HTTP/HTTPS URL) and API Key (the 'password' you put in the .env file)
- A message will let you know if a connection to the back-end is established successfully or not.

## Guides on each function of the app

### 1. Create new post

- This is where you create your new post.
- You are allowed to take a photo from your camera, or choose an image from your gallery.
- Messages are optional. But if you choose to have them, make sure they are at least 2 characters in length.
- By default, displaying elapsed time is not enabled, while allowing people to view the image in full size is enabled.

### 2. Clear current post

- A modal will show up and prompt you if you really want to clear the current post or not.

### 3. View current post

- This is where you see your current post.
- If there is no current post, it will say so on your screen.
- You can view your image (in square), see your message(s), time elapsed, and check if people can view your image in full size or not.
<!-- - You can view your image (in square), see your message(s), time elapsed, and view your full image. Basically what people see in your RPC. -->
- You may not be able to change the information of your post from here or from anywhere on this app.

### 4. Settings

- You can change the API Endpoint here.
<!-- - Changing the default values of your post can also be done here. -->

## Contributions

Contributions are welcomed in both this repo and [the back-end's repo](https://github.com/pdt1806/DisLife-backend).
Feel free to submit pull requests or open issues to contribute to the development of the project.

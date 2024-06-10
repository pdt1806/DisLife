<p align="center"><img src="https://raw.githubusercontent.com/pdt1806/DisLife/main/assets/images/icons/curved.png" width="20%"></img></p>
<h1 align="center">DisLife</h1>
<p align="center">Transform your Discord Rich Presence into a Locket-like experience: instantly share your moments with friends and peers!</p>

<p align="center"><img src="https://raw.githubusercontent.com/pdt1806/DisLife/main/assets/images/dislife-readme.png" width="100%"></img></p>

## 💡 The inspiration

Showing people what you are doing at the moment is one of the features that can be seen in modern-day social media platforms, such as Stories on Instagram/Facebook or Locket. People can decide if they want to see the image or not, and it is also their choice to message you if they are interested. The absence of you texting others about what you are doing is what makes this feature the top choice of teenagers right now. Seeing this, I wondered if I could also do the same thing on Discord, allowing people to know what I am doing without me direct messaging them first. Rich Presence is a suitable place to implement something like this. Not to mention, before this project, I had no experience in developing mobile/cross-platform apps; DisLife was a chance for me to develop one.

## 🎯 Target Audience

DisLife is designed for Discord users who are comfortable with self-hosting and customizing their app experience. This includes users who:

- Want to share quick updates and moments with their Discord friends without needing to directly message them.
- Appreciate the ephemeral nature of stories found on platforms like Instagram and Locket.
- Possess a basic understanding of running a back-end server and API connections.
- Enjoy tinkering and contributing to open-source projects.

## 🛠️ How to Setup and Use?

### 1. Set up the back-end server

Please refer to [this README](https://github.com/pdt1806/DisLife-backend/blob/main/README.md) in the back-end's repo on how to set up the back-end server.

⚠️ Make sure you have read the **Security and Considerations** section below and understand the risks involved before proceeding.

### 2. Access the app

As of today, this app can be used via [the web](https://dislife.bennynguyen.dev). If you are tech-savvy, you are welcome to clone this repo, build the .apk or even .ipa and install it on your phone.

### 3. Connect to the back-end

- Go to Settings -> API Endpoint
- Enter your API Endpoint (a valid HTTP/HTTPS URL) and your password (which you've put in the .env file)
- A message will let you know if a connection to the back-end is established successfully or not.

## ℹ️ About each page of the app

### 1. Create new post

- This is where you create your new post.
- This serves as the initial and the main page of the app (it stays in the center).
- You are allowed to take a photo from your camera, or choose an image from your gallery.
- Messages are optional. But if you choose to have them, make sure they are at least 2 characters in length.

### 2. View current post

- This is where you see your current post.
- If there is no current post, it will say so on your screen.
- You can view your image (in square), see your message(s), time elapsed, and view your full image. Basically how people see your RPC.
- You may not be able to change the information of your post from here or from anywhere on this app.
- That said, you can delete your current post here.
- To refresh this page, scroll down.

### 3. Settings

- You can change the API Endpoint here.
- Changing the default information of your post can also be done here.

## 🔒 Security and Considerations

### Password

- The password you set is only used to connect to your own server, not ours. You can change it anytime.
- Ensure that your server connection uses HTTPS to prevent exposing your password to potential attackers.

### Image Storage

- Images are stored on ImgBB, a 3rd party service. Make sure you agree to their terms.
- Concerned? DisLife's back-end is open-source! Open an issue or pull request to suggest a different storage solution on [the back-end repo](https://github.com/pdt1806/DisLife-backend).

## 🤝 Contributions

Contributions are welcome in both this repo and [the back-end repo](https://github.com/pdt1806/DisLife-backend).
Feel free to submit pull requests or open issues to contribute to the development of the project.

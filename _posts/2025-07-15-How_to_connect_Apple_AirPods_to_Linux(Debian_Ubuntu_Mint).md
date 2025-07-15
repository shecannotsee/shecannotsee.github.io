---
layout: post
categories: blog
---

# How to connect Apple AirPods to Linux (Debian/Ubuntu/Mint)

#### Step 1.

Open your terminal.

In the root directory run the command:

```
sudo nano /etc/bluetooth/main.conf
```

The terminal will ask you to input your password. Please type it :)

#### Step 2.

After that a file with configurations will be opened in a terminal window.

Find the next line:

```
#ControllerMode = dual
```

#### Step 3.

Change "dual" to "bredr". The final code must be:

```
ControllerMode = bredr
```

#### Step 4.

To save changes and exit nano editor do the following:

1. On your keyboard press:

```
Ctrl + x
```

2. On the bottom of nano editor you will see a qustion:

> "Save modified buffer?"

3. Press on your keyboard: y
4. Press on your keyboard: Enter

After these steps you will come back to regular terminal window on the same directory as before.

#### Step 5.

Run the next command in a terminal:

```
sudo /etc/init.d/bluetooth restart
```

After that you will see the message:

> "Restarting bluetooth (via systemctl): bluetooth.service."

#### Step 6.

Go to your computer settings and enable Bluetooth so it starts to look for bluetooth connections

#### Step 7.

The next actions should be performed exactly as described:

1. Put your airpods (both) inside the case

2. Keep the cover opened

3. With cover opened and airpods inside the case press and hold the button on the back of the airpods case.

4. Hold the button until you see the light blinking on the front side of the case, it can also make a sound signaling that it is in pairing mode

#### Step 8.

Finaly, after all these steps you should find your AirPods on Bluetooth settings section and connect it ;)

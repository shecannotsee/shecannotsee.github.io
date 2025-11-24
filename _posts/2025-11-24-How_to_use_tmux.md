---
layout: post
categories: blog
---

# How To Use Tmux

# Create

Create a new session:

```bash
$ tmux new -s session_name
```



# Close

Close a session internally:**Ctrl+D** or

```bash
$ tmux new -s session_name
...
$ exit
[exited]
```

Temporarily exit but do not close the session:**Ctrl+B** then **D/d**



# Query

Show all current sessions:

```bash
$ tmux ls
model: 1 windows (created Mon Nov 24 17:52:42 2025)
test: 1 windows (created Mon Nov 24 19:56:03 2025)
```



# Reconnect

Reconnect to session:

```bash
$ tmux attach -t session_name
```


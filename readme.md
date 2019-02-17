# icarus

Track your phone's altitude while you throw it skyward. Impress your friends with a leaderboard (if I can be bothered to make one). Reap what you sow!

## todo

- come up with data models
- plan database table structure
- follow todos in individual projects

## notes/miscellaneous/scratch space

### colors

blue "send high score button": #0055a5

### to make tracking algorithm better

- take an average for baseline (either when app is started or last xxx location check-ins)
- auto-reset height/baseline frequently to avoid running up the stairs problem
- consider creating an idea of a "toss" segment in order to have a predictable baseline and minimize interference from bad sensor data outside of desired window
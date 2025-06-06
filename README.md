# twentyfourgame

## Background

As a backend developer who had never touched mobile development before, this project was quite an adventure for me. I had zero experience with iOS development, Swift, or even Xcode when I started. The entire app was built using Cursor (an AI-powered IDE), with the only manual intervention being some tweaks to the difficulty ratings in the game's dataset.

The motivation behind building this app was pretty straightforward - I couldn't find a decent 24 game in the App Store. There used to be this perfect app that was simple, clean, and did exactly what it needed to do without any unnecessary bells and whistles. Unfortunately, it disappeared from the store last year. Rather than waiting for it to come back or settling for alternatives that didn't quite hit the mark, I decided to build my own.

This project is a testament to how modern development tools can help bridge the gap between different areas of software engineering. Even as someone who primarily works with backend systems, I was able to create a functional iOS app that serves its purpose well.

## Game Overview

The "24" game is an arithmetic puzzle where players are dealt 4 cards and must use each number exactly once to make 24 through basic arithmetic operations. The rules are simple:

- Use each number exactly once
- Use only addition, subtraction, multiplication, division, and parentheses
- The final result must equal 24

For example, if you're dealt `7`, `2`, `4`, `1`, one solution would be `(7 - 2) × 4 × 1 = 24`.

Face cards have the following values:
- Ace = 1
- Jack = 11
- Queen = 12
- King = 13

The game features multiple difficulty levels, from Easy to Hardest, indicated by stars. Every hand dealt is guaranteed to have at least one solution.

For more details about the game and its history, check out the [24 Game on Wikipedia](https://en.wikipedia.org/wiki/24_(puzzle)).

## App Features

The app offers a clean, focused interface with several key features:

- **Play Mode**: Tap "Play" to get a new hand of cards. Every hand is guaranteed to have at least one solution.
- **Solve**: Stuck on a puzzle? Hit "Solve" to see one possible solution.
- **Difficulty Filter**: Choose which difficulty levels you want to play with (Easy ★ to Hardest ★★★★). Each difficulty level is indicated by stars.
- **History**: Review your last 20 hands, complete with the cards dealt, difficulty level, and solutions.
- **Color Schemes**: Choose from 9 different color themes including Classic, Barbie, Hermes, and sports team inspired designs.
- **Language Support**: Switch between English and Chinese (简体中文) interfaces.
- **Dynamic App Icon**: Optionally have the app icon match your chosen color scheme.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/efc4cd04-63de-40b0-b39a-ce90e3fa575e" alt="Play" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/c854e756-f89c-4849-8cca-e4a3e680fabd" alt="Solve" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/6555e3fa-69b6-4fe2-97c4-a897754137e9" alt="Filter" width="200"/></td>
  </tr>
</table>

## Note

This README was also generated using Cursor, the same AI-powered IDE used to build the app. The only manual elements are the app screenshots.

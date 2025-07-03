# 🃏 Flutter Solitaire

A beautiful, smooth Solitaire game built using [Flutter](https://flutter.dev/) and the [Flame game engine](https://flame-engine.org/). Designed to be fun, fast, and surprisingly satisfying.

## 🚀 Features

- Classic Solitaire gameplay (a.k.a Klondike)
- Smooth card animations
- Custom draw modes (1-card / 3-card)
- Foundation, stock, waste, and tableau pile logic
- Touch & drag card interaction
- Restart with new or same deal
- Built using Flame's component system
- Mobile-optimized layout

🌐 Play Online
  Netlify URL: [[https://solitairee.netlify.app/](https://solitairee.netlify.app/)]

## 📸 Screenshots
<img width="300" alt="Screenshot 2025-06-17 at 12 59 36 PM" src="https://github.com/user-attachments/assets/d07cdfed-5b1f-4fe3-90c3-11547dc81484" />
<img width="300" alt="Screenshot 2025-06-17 at 12 59 13 PM" src="https://github.com/user-attachments/assets/a807b5bd-281e-4a2a-b2cc-41d9a2e6a0ce" />
<img width="300" alt="Screenshot 2025-06-17 at 12 55 23 PM" src="https://github.com/user-attachments/assets/5e91a8bb-e66b-4394-acc1-2e3e4742cf4b" />
<img width="300" alt="Screenshot 2025-06-17 at 12 52 11 PM" src="https://github.com/user-attachments/assets/d2894ca8-105b-49e8-bbdc-2b3f8737a6e0" />
<img width="300" alt="Screenshot 2025-06-17 at 12 44 32 PM" src="https://github.com/user-attachments/assets/ecbeadcc-2ada-44c6-bf75-f5cc79d68090" />
<img width="300" alt="Screenshot 2025-06-17 at 12 59 32 PM" src="https://github.com/user-attachments/assets/47d068af-cec2-4294-b90b-f64f9b369911" />
<img width="300" alt="Screenshot 2025-06-17 at 12 59 28 PM" src="https://github.com/user-attachments/assets/eaab34a6-8af7-45e4-be2f-a3ee5e71203a" />
<img width="300" alt="Screenshot 2025-06-17 at 1 26 50 PM" src="https://github.com/user-attachments/assets/0dc47697-4ac5-4871-b706-4723677e5c4b" />
<img width="300" alt="Screenshot 2025-06-17 at 1 31 21 PM" src="https://github.com/user-attachments/assets/176d176e-325a-4e61-97d1-e26293d2d4b6" />

## 🛠️ Built With

- **Flutter** – for cross-platform UI
- **Flame** – for game loop & rendering
- **Dart** – for logic and structure

## 🎮 Controls

| Action           | Input                       |
|------------------|-----------------------------|
| Move cards       | Drag & drop                 |
| Draw new cards   | Tap stock pile              |
| Flip top cards   | Automatic after move        |
| Restart game     | Tap one of the top buttons  |

## 🎯 Roadmap Ideas

- [ ] Victory celebration 🎉  
- [ ] Card sound effects  
- [ ] Custom themes (dark mode, retro, etc.)  
- [ ] Undo button  
- [ ] Timer & score system  

## 🧠 Dev Notes

Cards are dynamically generated and shuffled using a consistent seed when needed. Button interactions are built using Flame’s `AdvancedButtonComponent` with custom skins.

You can find all the core logic in:

- `solitaire_world.dart`
- `components/card.dart`
- `components/foundation_pile.dart`
- `components/stock_pile.dart`
- `components/waste_pile.dart`
- `components/tableau_pile.dart`

## 🏗️ How to Run

Make sure you have [Flutter installed](https://docs.flutter.dev/get-started/install).

```bash
git clone https://github.com/gracemakai/solitaire.git
cd solitaire
flutter pub get
flutter run

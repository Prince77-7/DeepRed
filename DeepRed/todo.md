# DeepRed iOS Development - TODO

## Instagram-Like Header Animation Implementation

### ✅ Completed Tasks
- [x] Analyze current HomeFeedView structure and scroll behavior
- [x] Implement sophisticated scroll direction detection (up/down/idle)
- [x] Add velocity-based scroll tracking for responsive animations
- [x] Create smooth header slide-away animation when scrolling down
- [x] Implement quick header reveal animation when scrolling up
- [x] Add spring animations for natural, responsive feel
- [x] Implement header opacity fade based on scroll position
- [x] Add background blur effects for polished look
- [x] Remove old scroll preference key system
- [x] Test and optimize animation parameters for Instagram-like feel

### 🔄 In Progress
- [ ] None

### 📋 Pending Tasks
- [ ] None

### 🎯 Next Steps
- [ ] Test on device for performance optimization
- [ ] Consider adding header shadow effects during scroll
- [ ] Implement header animation for other feed views if needed

## Minimal Video Cards with Upvote/Downvote System

### ✅ Completed Tasks
- [x] Replace heart/like button with unique upvote arrow
- [x] Add downvote arrow button for dislikes
- [x] Remove caption text and hashtags from video cards
- [x] Create minimal, distraction-free design
- [x] Maintain existing smooth animations and interactions
- [x] Add premium visual effects (glassmorphism, gradients)
- [x] Implement mutual exclusivity for upvote/downvote
- [x] Create design better than Luma and competitors

### 🔄 In Progress
- [ ] None

### 📋 Pending Tasks
- [ ] None

## Native Header Animation Simplification

### ✅ Completed Tasks
- [x] Simplify header animation to native Safari-like behavior
- [x] Remove complex calculations causing lag
- [x] Implement simple up-slide when scrolling down
- [x] Use only necessary code for smooth performance
- [x] Eliminate performance issues and stuttering
- [x] Create intuitive, native scroll behavior
- [x] Maintain 60fps performance

### 🔄 In Progress
- [ ] None

### 📋 Pending Tasks
- [ ] None

## Enhanced Vote Display & Minimal Design

### ✅ Completed Tasks
- [x] Add vote count under downvote arrow like upvote
- [x] Implement proportional circle fills based on vote ratios
- [x] Remove background card from view counter for minimal design
- [x] Calculate and display vote ratios visually in circles
- [x] Fix vote counting logic with proper mutual exclusivity
- [x] Create smooth animations for circle fill changes
- [x] Maintain minimal, clean aesthetic

### 🔄 In Progress
- [ ] None

### 📋 Pending Tasks
- [ ] None

## Technical Implementation Details

### Key Features Implemented:
1. **Scroll Direction Detection**: Real-time tracking of up/down scroll direction
2. **Velocity-Based Animations**: Header responds faster to quick scrolls
3. **Smooth Slide Animation**: Header slides completely out of view when scrolling down
4. **Quick Reveal**: Header comes back instantly when scrolling up
5. **Opacity Fade**: Elements fade gracefully during transitions
6. **Background Blur**: Adds depth and polish to the header
7. **Spring Animations**: Natural, responsive feel matching iOS design language

### Animation Parameters:
- Header slide sensitivity: 0.5x for down, 1.2x for up
- Velocity multipliers: 2.0x max for down, 3.0x max for up
- Spring response: 0.4s with 80% damping
- Interpolating spring: 300 stiffness, 30 damping

### Following Design System:
- Uses DeepRed design tokens for colors and spacing
- Maintains 8pt grid system
- Follows SwiftUI best practices
- Implements proper accessibility considerations 
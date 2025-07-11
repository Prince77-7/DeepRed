# **DeepRed Services Marketplace: The 'Award-Winning' Development Prompt**

**Mission:** Build the Services Marketplace for DeepRed. This is not just a feature; it is our "app-within-an-app." The goal is to create the most intuitive, fluid, and visually stunning platform for connecting businesses with creators, far surpassing the user experience of competitors like Upwork and Fiverr. Every animation, every transition, and every pixel must be perfect. This is the module that will win us design awards.  
**Core Philosophy:** Professionalism meets creative energy. The UI must feel as trustworthy and robust as a financial app, yet as engaging and fluid as a social media platform. We are designing for two distinct but connected users: the **Creator** (influencer) and the **Business**. The experience must be tailored and flawless for both.  
**Mandatory Foundation:**

* **Framework:** SwiftUI 6.2 exclusively.  
* **Design System:** Strict adherence to the deepred\_design\_system is non-negotiable. All colors, typography, and spacing must conform.  
* **Component Architecture:** Build with extreme modularity. Every element—from a gig card to a project milestone tracker—must be a reusable, self-contained SwiftUI View.  
* **Data:** Use the sample data structures outlined in the main deepred\_dev\_prompt for all content.

### **Part 1: The Dual-Entry Experience**

The user's first interaction sets the tone. It must be seamless.

* **Screen: Marketplace Hub (Screen 32\)**  
  * **Layout:** A clean, welcoming screen. At the top, a prominent, beautifully styled Search Bar with the placeholder "Search gigs or creators...".  
  * **The Segmented Control:** This is a key interaction. It's not a standard iOS picker. Design a custom, fluidly animated control with two states: "Find Gigs" and "Find Talent." When tapped, the control should animate smoothly, and the entire view below should transition with a subtle, non-jarring fade or slide animation to the corresponding feed.  
  * **Haptic Feedback:** Use gentle haptics when switching between modes to make the interaction feel tactile and satisfying.

### **Part 2: The Creator Flow — "My Next Opportunity"**

This flow must feel empowering and simple. The creator should feel like a valued talent, not a commodity.

* **Screen: Gig Feed & Discovery (Screen 35\)**  
  * **Layout:** A vertical ScrollView of Service Cards. The layout should be impeccably spaced according to the 8pt grid.  
  * **Micro-interaction:** As the user scrolls, cards should animate into view with a gentle fade and upward slide, creating a sense of lightness and discovery.  
  * **The "Gig Card":** This is a masterpiece of information design. It must contain the business name, gig title, budget, and key tags without feeling cluttered. Use typography hierarchy from the design system to guide the user's eye.  
* **Screen: Gig Detail View (Screen 36\)**  
  * **Animation:** When a user taps a Gig Card, it should perform a "shared element transition." The card itself should fluidly expand into the detail view's header. This is a critical, award-worthy animation.  
  * **Layout:** The view is broken into clear, digestible sections:  
    1. **Header:** The expanded card view.  
    2. **Description:** Rich text section.  
    3. **Deliverables:** A checklist-style view of what's required.  
    4. **About the Business:** A mini-card showing the company's profile.  
  * **The "Apply" Button:** A floating Primary CTA that is always accessible at the bottom of the screen, ensuring the primary action is never out of view.  
* **Screen: The Application Process (Screen 38\)**  
  * **Experience:** This should not feel like a form. It's a "pitch." Presented as a modal sheet, it allows the creator to write a brief proposal and, crucially, attach one of their existing DeepRed videos as a portfolio piece. This direct integration is a key differentiator.  
* **Screen: Application Dashboard (Screen 40\)**  
  * **Clarity is Key:** A clean list of applications with clear, color-coded status tags (Pending, Viewed, Accepted, Declined). This removes all anxiety and ambiguity for the creator.

### **Part 3: The Business Flow — "Finding the Perfect Voice"**

This flow must feel professional, efficient, and reliable.

* **Screen: Talent Feed (Screen 42\)**  
  * **The "Talent Card":** Similar to the gig card, this is a showcase. It features the creator's profile picture, username, key stats (e.g., followers, engagement rate), and specialty tags. It must look premium.  
* **Screen: Post a Gig Flow (Screens 46-50)**  
  * **A Conversational Form:** Break the complex task of posting a job into a multi-step, conversational flow presented in a modal sheet. Each step (Title, Description, Budget) is a single screen, making the process feel less daunting. A progress bar at the top shows the user where they are in the process.  
* **Screen: Applicant Review (Screen 53\)**  
  * **The "Digital Casting Room":** This is the core of the business experience. When viewing applicants for a gig, present them as a horizontal, swipeable stack of profiles. This allows the business to quickly flip through candidates.  
  * **Interaction:** Tapping a profile expands it to show their full proposal and attached video. Swiping left or right could potentially be used for quick sorting (e.g., "shortlist" vs. "pass"). The animations here must be incredibly smooth.  
* **Screen: Project Management (Screen 56\)**  
  * **The "Mission Control" Dashboard:** Once a creator is hired, this screen manages the entire project. It must clearly display:  
    1. A timeline of milestones.  
    2. A communication thread.  
    3. A secure payment/escrow status section.  
  * The design should inspire confidence and control.

### **Final Polish: The "Award-Winning" Details**

* **Empty States:** Design beautiful, helpful empty states for every list (e.g., "You haven't applied to any gigs yet. Let's find one\!").  
* **Loading States:** Use shimmering, skeleton-style loaders that mimic the layout of the content they are loading. No spinners.  
* **Haptics & Sound:** Use subtle haptics and non-intrusive sound effects for key actions like sending a proposal, accepting an offer, or completing a payment. This makes the app feel alive and responsive.  
* **Fluid Transitions:** Every navigation push, modal presentation, and tab switch must be interruptible and buttery smooth. Profile this heavily to eliminate any stutter.

Your mission is to build this module as if it were the only thing that matters. Infuse it with thoughtful interactions and a level of polish that makes users *want* to engage with it. Make it perfect.
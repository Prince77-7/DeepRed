# **DeepRed: iOS Design Reference & System**

**Version 1.0**

### **1\. Design Philosophy**

Our design is clean, intentional, and empowering. We connect businesses and creators with a platform that feels both professional and deeply engaging. Every interaction, from a simple scroll to posting a video, is designed to be fluid, intuitive, and visually satisfying. We prioritize clarity over clutter, and speed over complexity. The DeepRed aesthetic is minimalist yet bold, building trust and encouraging creativity.

### **2\. Core Principles**

* **Clarity First:** The UI must be immediately understandable. We use clear copywriting, logical hierarchy, and recognizable patterns to eliminate ambiguity.  
* **8pt Grid System:** All layouts, components, and spacing are based on a strict 8pt grid. This ensures rhythmic, consistent spacing across the entire application.  
* **60/30/10 Color Rule:** A disciplined approach to color creates a clean and focused experience.  
  * **60%** White (for space and clarity)  
  * **30%** Black (for content and hierarchy)  
  * **10%** Brand Red (for primary actions and identity)  
* **Motion with Purpose:** Animations are used to provide feedback, guide the user, and add a layer of polish. They are subtle, fast, and never obstructive.  
* **Accessibility as Standard:** We design for everyone. This includes sufficient color contrast, dynamic type support, and VoiceOver compatibility.

### **3\. Visual Identity**

#### **3.1. Color Palette**

The color palette is minimal to maintain a high-end, focused aesthetic.

| Role | Name | Hex | Usage |
| :---- | :---- | :---- | :---- |
| **Accent (10%)** | DeepRed | \#850101 | Primary CTAs, active states, record button, key brand moments. |
| **Text (30%)** | Onyx | \#1C1C1E | Primary text, headlines, body copy. The standard iOS dark text. |
| **Text Secondary** | Graphite | \#8E8E93 | Secondary text, captions, disabled states, placeholder text. |
| **Background (60%)** | Snow | \#FFFFFF | Main app background, cards, sheets. |
| **System Gray** | Ash | \#F2F2F7 | Separators, secondary backgrounds, input fields. |
| **System Green** | Success | \#34C759 | Confirmation messages, success states (e.g., "Paid"). |
| **System Orange** | Warning | \#FF9500 | Non-critical warnings. |
| **System Red** | Error | \#FF3B30 | Error messages, destructive actions (e.g., "Delete Post"). |

#### **3.2. Typography**

We will exclusively use **SF Pro**, Apple's native font, to ensure optimal legibility, performance, and seamless integration with iOS features like Dynamic Type. All sizes and line heights are multiples of the 8pt grid.

| Style Name | Font Weight | Size | Line Height | Usage |
| :---- | :---- | :---- | :---- | :---- |
| **Display Title** | Bold | 32pt | 40pt | Major screen titles, onboarding headlines. |
| **Title 1** | Bold | 24pt | 32pt | Section headers, card titles. |
| **Title 2** | Semibold | 20pt | 24pt | Sub-section headers. |
| **Body** | Regular | 16pt | 24pt | Primary text for posts, descriptions, inputs. |
| **Body (Bold)** | Bold | 16pt | 24pt | Emphasized body text. |
| **Caption** | Regular | 14pt | 24pt | Metadata, timestamps, helper text. |
| **Button** | Semibold | 16pt | \- | All button labels. |
| **Micro** | Semibold | 12pt | 16pt | Tags, labels. |

#### **3.3. Iconography**

We will use **SF Symbols** exclusively. This native icon set is designed to work alongside the SF Pro font, ensuring visual consistency in weight and alignment.

* **Style:** Use the Regular weight for all icons.  
* **State:** Use filled variants for active states (e.g., the active tab bar icon).  
* **Color:** Icons should use the Onyx or Graphite colors, except for special cases like the red record button.

### **4\. Layout & Spacing**

* **Base Unit:** 1x \= 8pt  
* **Standard Margins:** All screens have 16pt (2x) horizontal margins. Key content blocks have 24pt (3x) vertical margins.  
* **Gutters:** Spacing between elements should be a multiple of 8pt.  
  * 8pt (1x): Between tight elements like an icon and its label.  
  * 16pt (2x): Standard spacing between list items or cards.  
  * 24pt (3x): Between distinct sections on a page.  
  * 32pt (4x): Major separation between large content blocks.  
* **Corner Radius:**  
  * **Buttons & Inputs:** 12pt  
  * **Cards:** 16pt  
  * **Modals & Sheets:** 24pt

### **5\. Component Library**

This is the atomic foundation of the app's UI.

#### **5.1. Buttons**

* **Primary CTA:** DeepRed background, Snow text. Used for the most important action on a screen (e.g., "Apply for Gig," "Post Video").  
* **Secondary Button:** Onyx outline (1pt), Onyx text. Used for secondary actions (e.g., "View Profile," "Save Draft").  
* **Tertiary/Text Button:** Onyx text, no background or border. For low-emphasis actions.  
* **States:** All buttons must have clear default, pressed (slight scale down and darken), and disabled (Graphite text/border, Ash fill) states.

#### **5.2. Tab Bar**

The tab bar is a core element of the DeepRed identity.

* **Structure:** A standard iOS tab bar with 5 items.  
* **Icons (Left to Right):**  
  1. Home (house)  
  2. Services (briefcase)  
  3. **Record (Center/Floating)**  
  4. Inbox (message)  
  5. Profile (person.crop.circle)  
* **The Record Button:**  
  * It is circular and slightly larger than the other tab items.  
  * It is elevated, casting a soft shadow on the tab bar.  
  * It uses the DeepRed color.  
  * The icon is a simple circle or record symbol.  
  * **Interaction:** A single tap opens the recording screen. A long-press (Haptic Touch) could potentially open a menu with other creation options in the future.

#### **5.3. Cards**

Cards are used for video posts and service listings.

* **Video Card:** Full-bleed video content. UI elements (username, caption, like/comment buttons) are overlaid on the video with a subtle gradient behind them to ensure text legibility.  
* **Service Card:**  
  * 16pt internal padding.  
  * **Structure:** Business Logo/Name at the top, followed by Title 1 for the gig title, Micro tags for skills needed, and Body for the compensation (e.g., "$500").  
  * **Shadow:** A soft, diffused shadow to create depth. (x: 0, y: 4, blur: 16, color: black @ 8% opacity)

### **6\. Screen Blueprints**

#### **6.1. Home Feed**

* **Layout:** A full-screen, edge-to-edge, vertically scrolling feed of video cards.  
* **UI:** Minimal UI overlays. Username, caption, and engagement stats are at the bottom. A "Follow" button appears next to the username for accounts you don't follow.  
* **Interaction:** Swipe up/down to navigate between videos.

#### **6.2. Video Recording Screen**

* **Layout:** Full-screen camera view.  
* **UI Elements:**  
  * A large DeepRed record button at the bottom center.  
  * As the user holds the button, a progress ring animates around it, indicating the 30-second limit.  
  * Controls for flash, flip camera, etc., are minimal icons at the top right.  
  * Upon completion, the user is taken to a preview/posting screen where they can write a caption.

#### **6.3. Services Marketplace**

* **Layout:** A vertically scrolling feed of Service Cards.  
* **Header:** A sticky header containing a search bar (Search for gigs or talent...) and filter buttons (e.g., Category, Budget).  
* **Tabs:** Two tabs at the top: Find Gigs (for creators) and Find Talent (for businesses). The UI adapts slightly for each view.

### **7\. Technical & Future-Proofing**

* **SwiftUI First:** The entire UI will be built declaratively using SwiftUI. This aligns with modern iOS development, ensures high performance, and makes the app "future-proof" for upcoming iOS versions.  
* **Component-Driven Development:** Each component defined in this document (Button, Card, etc.) will be a reusable SwiftUI View. This maps the design system directly to the codebase, ensuring consistency and rapid development.  
* **Performance:**  
  * **Asynchronous Operations:** All network requests and data processing will be done asynchronously to keep the UI responsive.  
  * **Image/Video Optimization:** Use efficient formats and lazy loading for all media assets to ensure smooth scrolling.  
  * **Native Animations:** Leverage SwiftUI's built-in animation engine, which is highly optimized for the platform. Avoid custom, heavy animation libraries.

This document serves as the foundational guide for building DeepRed. By adhering to these principles and components, we will create an application that is not only powerful in its functionality but also exceptional in its design and user experience.
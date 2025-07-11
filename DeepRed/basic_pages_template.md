# **DeepRed: AI Development & Coding Prompt (Expanded)**

**Objective:** To build a high-fidelity, interactive iOS application prototype for "DeepRed" using SwiftUI. The primary goal is to translate the established deepred\_design\_system into a pixel-perfect, beautifully animated, and highly performant user interface. The final output should feel like a top-tier application, taking inspiration from the fluidity of Luma, the clarity of Airbnb, and the polish of Revolut.  
**Core Technical Requirements:**

* **Framework:** SwiftUI 6.2 exclusively.  
* **Architecture:** Hyper-Component-driven. Due to the extensive scope, every view, sub-view, and interactive element must be a reusable component to manage complexity.  
* **Data:** Use lightweight, hardcoded sample data for all dynamic content. No backend integration is required.  
* **Design System Adherence:** Strictly follow the deepred\_design\_system for all colors, typography, spacing (8pt grid), corner radii, and iconography (SF Symbols).  
* **Performance:** All interactions and animations must be smooth and responsive, running at 60fps.

### **Part 1: Core App Structure & Global Components**

#### **1.1. Global Component: Custom Tab Bar**

* **Description:** The persistent navigation element. Build this first.  
* **Layout:** Five tabs: Home, Services, Record, Inbox, Profile. The central "Record" button must be a distinct, circular, DeepRed button that is elevated and slightly larger, casting a soft shadow.  
* **States:** Inactive icons use Graphite color. Active icons use Onyx and the filled SF Symbol variant.  
* **Interaction:** Tapping an icon navigates to the root view of that tab. The Record button has a subtle "bouncy" animation on tap.

#### **1.2. Navigation & Modals**

* **Navigation:** Use NavigationStack for all push navigation within each tab.  
* **Sheets:** All modal views (e.g., Comments, Filters, Settings sub-menus) should be presented as sheets with the standard 24pt corner radius.

### **Part 2: Onboarding & Authentication Flow (\~15 Screens)**

#### **2.1. Initial Launch**

* **Screen 1: Onboarding Carousel:** A TabView with PageTabViewStyle.  
  * **Page 1:** "Create & Connect." (Icon: sparkles)  
  * **Page 2:** "Find Your Opportunity." (Icon: briefcase.fill)  
  * **Page 3:** "Showcase Your Talent." (Icon: mic.fill). Includes a "Get Started" Primary CTA.

#### **2.2. Authentication Hub**

* **Screen 2: Auth Entry Point:** A clean screen with the DeepRed logo.  
  * Buttons: "Continue with Email", "Sign in with Apple", "Sign in with Google".  
  * Footer text: "By continuing, you agree to our Terms of Service and Privacy Policy."

#### **2.3. Email Sign Up Flow**

* **Screen 3: Enter Email & Password:** Two styled text fields. Real-time validation checks (e.g., valid email format, password strength).  
* **Screen 4: Create Profile:** Fields for Full Name and @username. Real-time check for username availability.  
* **Screen 5: Profile Picture:** Option to upload a photo or take one. A skip button is available.  
* **Screen 6: Write Bio:** A simple multi-line text field for the user's bio.  
* **Screen 7: Interest Selection:** A grid of selectable tags (e.g., "Marketing", "Gaming", "Fashion") to personalize the feed. Requires a minimum of 3 selections.

#### **2.4. Login Flow**

* **Screen 8: Email Login:** Standard email and password fields.  
* **Screen 9: Forgot Password:** Input field for email.  
* **Screen 10: Reset Password Confirmation:** "Check your email for a link to reset your password."  
* **Screen 11: Reset Password View:** (Accessed via deep link) Fields for new password and confirm password.

#### **2.5. Permissions**

* **Screen 12: Notification Permission:** A pre-prompt explaining why notifications are useful, with a button to trigger the native iOS prompt.  
* **Screen 13: Camera/Mic Permission:** Pre-prompt for content creation.  
* **Screen 14: Contacts Permission:** Pre-prompt explaining how this helps find friends.

### **Part 3: Home Feed & Content Creation (\~25 Screens)**

* **Screen 15: Home Feed:** The main vertically scrolling, full-screen video feed.  
* **Screen 16: Comments Sheet:** Modal sheet displaying a list of comments. Includes a text field at the bottom to add a new comment.  
* **Screen 17: Sharer Sheet:** The native iOS share sheet, possibly with a top row of DeepRed-specific users to share with.  
* **Screen 18: Liker's List:** A list view showing all users who liked a video.  
* **Screen 19: Report Flow \- Step 1 (Reason):** A list of reasons for reporting (e.g., "Spam," "Harassment").  
* **Screen 20: Report Flow \- Step 2 (Details):** Optional text field for more information.  
* **Screen 21: Report Flow \- Step 3 (Confirmation):** "Thank you for your report."  
* **Screen 22: Video Recording Screen:** Full-screen camera view with the hold-to-record button.  
* **Screen 23: Recording Progress UI:** A circular progress bar animates around the record button for 30 seconds.  
* **Screen 24: Video Editor Screen:** Post-recording view.  
  * UI Elements: Timeline for trimming, buttons for "Sound," "Text," "Filters."  
* **Screen 25: Sound Library:** A searchable list of sample audio tracks.  
* **Screen 26: Text Tool:** Interface to add colored/styled text overlays.  
* **Screen 27: Filter Browser:** A horizontal scroll view of filter previews.  
* **Screen 28: Post Preview & Caption Screen:** Final step before posting.  
  * UI Elements: Video preview, caption text field, buttons to "Tag People" and "Add Location."  
* **Screen 29: Tag People Screen:** A searchable list of the user's followers.  
* **Screen 30: Add Location Screen:** A searchable list of locations.  
* **Screen 31: Drafts Screen:** A grid view of saved, unpublished video drafts.

### **Part 4: Services Marketplace (\~40 Screens)**

#### **4.1. Common**

* **Screen 32: Marketplace Hub:** Root view of the Services tab. Contains a search bar and a segmented control for "Find Gigs" / "Find Talent".  
* **Screen 33: Search Results Page:** Shows results for gigs or talent based on the active tab.  
* **Screen 34: Filter Sheet:** A modal sheet with options to filter by Category, Budget Range, Location, etc.

#### **4.2. Creator Flow (Finding Gigs)**

* **Screen 35: Gig Feed:** A list of Service Cards for available gigs.  
* **Screen 36: Gig Detail View:** Full details of a gig: description, deliverables, company info, budget.  
* **Screen 37: Company Profile View:** A profile page specifically for a business, showing their details and past gigs.  
* **Screen 38: Apply to Gig Screen:** A modal where a creator can write a proposal and attach a relevant video from their profile.  
* **Screen 39: Application Sent Confirmation:** A success screen after applying.  
* **Screen 40: My Applications List:** A list of all gigs the user has applied to, with statuses (Pending, Viewed, Accepted, Declined).  
* **Screen 41: Application Status Detail:** A view showing the submitted proposal and current status.

#### **4.3. Business Flow (Finding Talent & Posting Gigs)**

* **Screen 42: Talent Feed:** A list of Talent Cards showcasing creators.  
* **Screen 43: Talent Profile View:** A detailed view of a creator's profile from a business perspective, highlighting key stats and portfolio.  
* **Screen 44: Creator Portfolio View:** A dedicated view of a creator's best work.  
* **Screen 45: Invite to Gig Screen:** A modal to send a specific gig invitation to a creator.  
* **Screen 46: Post a Gig \- Step 1 (Title & Category):**  
* **Screen 47: Post a Gig \- Step 2 (Description & Deliverables):**  
* **Screen 48: Post a Gig \- Step 3 (Budget & Timeline):**  
* **Screen 49: Post a Gig \- Step 4 (Preview):** Review the gig posting before it goes live.  
* **Screen 50: Gig Posted Confirmation:**  
* **Screen 51: My Gig Postings List:** A list of all gigs a business has posted.  
* **Screen 52: View Applicants Screen:** A list of all creators who have applied to a specific gig.  
* **Screen 53: Applicant Review Screen:** View a creator's proposal and profile. Buttons to "Accept" or "Decline."  
* **Screen 54: Contract Creation Screen:** A simple form to outline terms and payment milestones.  
* **Screen 55: Contract Sent Confirmation:**  
* **Screen 56: Active Project Dashboard:** A view to manage an ongoing project, track milestones, and communicate.  
* **Screen 57: Milestone Approval Screen:**  
* **Screen 58: Payment Release Screen:** Authorize payment from escrow upon milestone completion.  
* **Screen 59: Rate Creator Screen:** A modal to leave a rating and review after a project is complete.

### **Part 5: Inbox & Messaging (\~15 Screens)**

* **Screen 60: Inbox Hub:** A view with two tabs: "Messages" and "Notifications."  
* **Screen 61: Conversation List:** The main list of active chats.  
* **Screen 62: Chat View:** The main messaging interface.  
* **Screen 63: Chat Info Screen:** View details about the other user, with options to block/report.  
* **Screen 64: Contract Offer in Chat:** A special message bubble type for viewing and accepting/declining a contract.  
* **Screen 65: System Notifications List:** A list of automated notifications (e.g., "Your application was viewed," "You have a new follower").

### **Part 6: Profile, Settings & More (\~60+ Screens)**

#### **6.1. Profile Hub**

* **Screen 66: My Profile View:** The user's own profile.  
* **Screen 67: Public Profile View:** How another user sees the profile.  
* **Screen 68: Followers List:**  
* **Screen 69: Following List:**  
* **Screen 70: My Content Tab:** A grid of the user's posted videos.  
* **Screen 71: My Services Tab:** A list of services the creator offers (if any).  
* **Screen 72: Saved/Bookmarked Tab:** A private tab with saved videos and gigs.

#### **6.2. Edit Profile**

* **Screen 73: Edit Profile Screen:** Change picture, name, bio, etc.  
* **Screen 74: Add/Edit Social Links Screen:**

#### **6.3. Wallet & Earnings**

* **Screen 75: Wallet Dashboard:** Shows current balance, recent transactions.  
* **Screen 76: Payout History:** A detailed list of all past payouts.  
* **Screen 77: Add Payout Method:** Securely add a bank account or PayPal.  
* **Screen 78: Withdraw Funds Screen:**

#### **6.4. Analytics (Pro Accounts)**

* **Screen 79: Analytics Dashboard:** Overview of views, engagement, follower growth.  
* **Screen 80: Audience Demographics View:**

#### **6.5. Settings (Root)**

* **Screen 81: Settings Root List:** A list linking to all sub-settings screens.  
  * Items: Account, Notifications, Privacy, Wallet, Help Center, About.

#### **6.6. Settings (Sub-Screens)**

* **Screen 82: Account Settings:** Change email, phone, password.  
* **Screen 83: Change Password Screen:**  
* **Screen 84: Notification Settings:** Granular toggles for all notification types.  
* **Screen 85: Privacy Settings:** Private account toggle, etc.  
* **Screen 86: Blocked Users List:**  
* **Screen 87: Help Center:** A searchable list of FAQ articles.  
* **Screen 88: FAQ Article Detail View:**  
* **Screen 89: Contact Support Screen:** A form to submit a help ticket.  
* **Screen 90: About Screen:** Links to ToS, Privacy Policy.  
* **Screen 91: Deactivate Account Flow:** A multi-step process to confirm account deactivation.  
* ... and so on, for every conceivable sub-page and state, easily exceeding 150 total screens/states when all interactions are considered.
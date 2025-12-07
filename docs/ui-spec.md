# UI Design Specification

## Overview

This document defines the UI/UX patterns, design system, and component specifications for the Flutter web application.
The design follows modern web application standards with a focus on responsiveness, accessibility, and delightful user
interactions.

---

## Design System

### Color Palette

#### Primary Colors

```dart
// Purple-Blue Gradient Theme
static const primaryPurple = Color(0xFF6366F1);  // Indigo
static const primaryBlue = Color(0xFF3B82F6);    // Blue

// Accent Colors
static const accentPink = Color(0xFFEC4899);     // Pink
static const accentOrange = Color(0xFFF59E0B);   // Amber

// Neutral Colors
static const darkBackground = Color(0xFF0F172A);  // Slate 900
static const darkSurface = Color(0xFF1E293B);     // Slate 800
static const lightBackground = Color(0xFFF8FAFC); // Slate 50
static const lightSurface = Color(0xFFFFFFFF);    // White
```

#### Gradients

```dart
// Primary Gradient (Purple → Blue)
static const primaryGradient = LinearGradient(
  colors: [Color(0xFF6366F1), Color(0xFF3B82F6)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Accent Gradient (Pink → Orange)
static const accentGradient = LinearGradient(
  colors: [Color(0xFFEC4899), Color(0xFFF59E0B)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Light Background Gradient (3-stop)
static const lightBackgroundGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFEEF2FF),  // Indigo 50
    Color(0xFFFDF2F8),  // Pink 50
    Color(0xFFEFF6FF),  // Blue 50
  ],
);

// Dark Background Gradient (3-stop)
static const darkBackgroundGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF0F172A),  // Slate 900
    Color(0xFF1E1B4B),  // Indigo 950
    Color(0xFF0C4A6E),  // Sky 950
  ],
);
```

### Typography

#### Font Family

- **Primary Font:** Google Fonts - Inter (clean, modern sans-serif)
- **Fallback:** System default

#### Type Scale

```dart
// Headlines
headlineLarge: 48px, weight: 700  // Hero titles
headlineMedium: 32px, weight: 700 // Section titles
headlineSmall: 24px, weight: 600  // Card titles

// Body Text
bodyLarge: 18px, weight: 400      // Large body text
bodyMedium: 16px, weight: 400     // Default body text
bodySmall: 14px, weight: 400      // Supporting text

// Labels
labelLarge: 16px, weight: 600     // Button text
labelMedium: 14px, weight: 500    // Form labels
labelSmall: 12px, weight: 500     // Captions
```

### Spacing System

```dart
// Base spacing unit: 4px
static const spacing = {
  'xs': 4.0,     // Tight spacing
  'sm': 8.0,     // Small gaps
  'md': 16.0,    // Default spacing
  'lg': 24.0,    // Large spacing
  'xl': 32.0,    // Extra large spacing
  '2xl': 48.0,   // Section spacing
  '3xl': 64.0,   // Hero spacing
};
```

### Border Radius

```dart
static const borderRadius = {
  'sm': 8.0,     // Buttons, inputs
  'md': 12.0,    // Cards, menu items
  'lg': 16.0,    // Modals, panels
  'xl': 20.0,    // Large cards
  '2xl': 24.0,   // Hero cards
  'full': 9999.0 // Pills, avatars
};
```

### Shadows & Elevation

```dart
// Soft shadows for cards and elevated elements
static final softShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 10,
    offset: Offset(0, 4),
  ),
];

static final mediumShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 20,
    offset: Offset(0, 8),
  ),
];

static final largeShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 30,
    offset: Offset(0, 12),
  ),
];
```

---

## Component Specifications

### 1. Glassmorphic Card

**Purpose:** Container with frosted glass effect for modern UI

**Properties:**

- Background: Semi-transparent white (light) or dark (dark mode)
- Backdrop filter: Blur(10px)
- Border: 1px solid with opacity 0.2
- Border radius: 16-24px
- Padding: 20-24px

**Implementation:**

```dart
class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  // Dark mode adaptive colors
  backgroundColor: isDark
    ? Color(0xFF1E293B).withOpacity(0.8)
    : Colors.white.withOpacity(0.7);

  // Backdrop blur for frosted glass effect
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(...),
  );
}
```

### 2. Gradient Background

**Purpose:** Full-screen animated gradient background

**Properties:**

- Adaptive to dark/light theme
- 3-color gradient with diagonal direction
- Optional animated floating orbs overlay
- Child widget rendered on top

**Variants:**

- Light mode: Soft pastels (indigo, pink, blue)
- Dark mode: Deep blues and purples

### 3. Animated Gradient Button

**Purpose:** Primary CTA button with gradient and animations

**Properties:**

- Gradient background (primaryGradient)
- Height: 56px
- Border radius: 12px
- Font size: 16px, weight: 600
- Loading state with spinner
- Disabled state (opacity 0.5)

**Animations:**

- Hover: Scale 1.0 → 1.02, shadow increase
- Press: Scale 1.0 → 0.98
- Transition: 200ms ease-in-out

**States:**

- Default
- Hover
- Pressed
- Loading (spinner replaces text)
- Disabled

### 4. Stat Card

**Purpose:** Display key metrics with visual appeal

**Properties:**

- GlassmorphicCard background
- Gradient icon container (circular)
- Title, value, optional trend indicator
- Hover animation: Scale 1.0 → 1.02

**Layout:**

```
┌─────────────────────────┐
│ [Icon]  Title           │
│         Value (large)   │
│         ↑ 12.5% trend   │
└─────────────────────────┘
```

**Example:**

- Icon: People icon with gradient background
- Title: "Total Students"
- Value: "247"
- Trend: +12.5% (green)

### 5. Navigation Menu Item

**Purpose:** Sidebar/menu navigation item with active state

**Properties:**

- Icon + label layout
- Active state: Gradient background
- Hover state: Subtle background color
- Click: Navigate + update active state
- Nested items: Indented 16px

**Animations:**

- Hover: Background fade-in (200ms)
- Click: Ripple effect
- Active: Gradient fade-in (300ms)

**States:**

- Default: Transparent background, gray icon/text
- Hover: Light background, icon/text brightens
- Active: Gradient background, white icon/text

### 6. Dashboard App Bar

**Purpose:** Top navigation bar for dashboard

**Properties:**

- Height: 70px
- GlassmorphicCard background
- Gradient border bottom (1px)

**Desktop Layout:**

```
[Dashboard Title] [Search Bar] [Spacer] [Notifications] [Profile]
```

**Mobile Layout:**

```
[Logo] [Spacer] [Notifications] [Profile]
```

**Components:**

- Search bar (300px width, desktop only)
- Notification bell with badge
- Profile avatar with dropdown

### 7. Notification Bell

**Purpose:** Display notifications with dropdown

**Properties:**

- Bell icon with badge (unread count)
- Badge: Circular, pink background, white text
- Dropdown: Recent 5 notifications
- Mark as read functionality
- Timestamp with timeago formatting

**Dropdown Item:**

- Width: 300px
- Border left (3px) for unread items
- Title, description, timestamp
- Click to mark as read

### 8. Profile Dropdown

**Purpose:** User profile menu

**Properties:**

- Avatar: Circular gradient background with initials
- Size: 40x40px
- Dropdown menu with 3 sections:
  1. User info (name, email)
  2. Menu items (Profile, Settings)
  3. Logout (red text)

**Dropdown Layout:**

```
┌────────────────────┐
│ John Doe           │
│ john@example.com   │
├────────────────────┤
│ 👤 Profile         │
│ ⚙️  Settings       │
├────────────────────┤
│ 🚪 Logout (red)    │
└────────────────────┘
```

### 9. Bottom Navigation Bar (Mobile)

**Purpose:** Mobile navigation with 5 items

**Properties:**

- Height: 70px
- SafeArea padding
- 5 items: Overview, Students, Coaches, Classes, Settings
- Selected: Gradient icon + purple label
- Unselected: Gray icon only

**Animations:**

- Selection: Scale 1.0 → 1.1 (icon), color fade (300ms)
- Item layout: Vertical (icon above label)

### 10. Desktop Sidebar

**Purpose:** Collapsible navigation sidebar

**Properties:**

- Width: 280px (expanded) ↔ 80px (collapsed)
- Transition: 300ms ease-in-out
- GlassmorphicCard background
- Toggle button at top

**Menu Structure:**

- Overview
- Students (collapsible)
  - Active Students
  - Inactive Students
- Coaches
- Classes
- Schedule
- Settings
- Logout (at bottom, red icon)

**Collapsed State:**

- Icons only (no labels)
- Nested menus hidden
- Tooltip on hover

---

## Layout Patterns

### 1. Authentication Pages (Split-Screen)

#### Desktop (≥768px)

```
┌─────────────────────────────────────────────┐
│ Hero Section (60%)  │  Form Section (40%)   │
│                     │                       │
│ [Logo]              │  [Form Card]          │
│ Welcome Back        │  - Email input        │
│ Description         │  - Password input     │
│                     │  - Remember me        │
│ ✓ Feature 1         │  - Submit button      │
│ ✓ Feature 2         │  - Social logins      │
│ ✓ Feature 3         │  - Sign up link       │
│                     │                       │
└─────────────────────────────────────────────┘
```

#### Mobile (<768px)

```
┌──────────────────┐
│                  │
│ [Logo]           │
│                  │
│ [Form Card]      │
│ - Email          │
│ - Password       │
│ - Submit         │
│ - Social logins  │
│ - Sign up link   │
│                  │
└──────────────────┘
```

### 2. Dashboard Layout

#### Desktop (≥768px)

```
┌────────────────────────────────────────────┐
│ [Sidebar]  │  [AppBar]                     │
│            ├───────────────────────────────┤
│ [Menu]     │                               │
│ • Overview │  [Page Content]               │
│ • Students │                               │
│ • Coaches  │                               │
│ • Classes  │                               │
│ • Schedule │                               │
│ • Settings │                               │
│            │                               │
│ [Logout]   │                               │
└────────────────────────────────────────────┘
   280/80px        Full width - sidebar
```

#### Mobile (<768px)

```
┌──────────────────┐
│ [AppBar]         │
├──────────────────┤
│                  │
│ [Page Content]   │
│                  │
│                  │
├──────────────────┤
│ [Bottom Nav Bar] │
│ [•] [•] [•] [•]  │
└──────────────────┘
```

### 3. Responsive Breakpoints

```dart
static const mobileBreakpoint = 768.0;   // Mobile → Tablet
static const tabletBreakpoint = 1024.0;  // Tablet → Desktop
static const desktopBreakpoint = 1440.0; // Desktop → Wide
```

---

## Micro-interactions & Animations

### Button Interactions

```dart
// Hover animation
AnimatedContainer(
  duration: Duration(milliseconds: 200),
  transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
  // Shadow increase on hover
  boxShadow: _isHovered ? mediumShadow : softShadow,
);

// Press animation
onTapDown: (_) => setState(() => _isPressed = true),
onTapUp: (_) => setState(() => _isPressed = false),
transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
```

### Input Field Interactions

```dart
// Focus state
InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryPurple, width: 2),
    // Optional glow effect
    boxShadow: [
      BoxShadow(
        color: primaryPurple.withOpacity(0.2),
        blurRadius: 8,
      ),
    ],
  ),
);
```

### Page Transitions

```dart
// Slide transition
PageRouteBuilder(
  transitionDuration: Duration(milliseconds: 300),
  pageBuilder: (context, animation, secondaryAnimation) => page,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return SlideTransition(
      position: animation.drive(
        Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeInOut)),
      ),
      child: child,
    );
  },
);
```

### Loading States

```dart
// Spinner in button
if (isLoading)
  SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    ),
  )
else
  Text('Sign In'),
```

### Success Animations

```dart
// Checkmark animation on successful login
AnimatedIcon(
  icon: AnimatedIcons.check,
  progress: _animationController,
  size: 48,
  color: Colors.green,
);
```

### Error Animations

```dart
// Shake animation for validation errors
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  curve: Curves.elasticOut,
  transform: Matrix4.translationValues(_shakeOffset, 0, 0),
);
```

---

## Accessibility Guidelines

### Contrast Ratios

- **WCAG AA Compliance:** Minimum 4.5:1 for normal text, 3:1 for large text
- **Dark mode:** Ensure sufficient contrast between text and background
- **Light mode:** Test contrast with online tools (e.g., WebAIM)

### Focus Indicators

```dart
// Keyboard navigation focus ring
FocusableActionDetector(
  onShowFocusHighlight: (focused) {
    setState(() => _isFocused = focused);
  },
  child: Container(
    decoration: BoxDecoration(
      border: _isFocused
        ? Border.all(color: primaryPurple, width: 2)
        : null,
    ),
  ),
);
```

### Semantic Labels

```dart
// Screen reader labels
Semantics(
  label: 'Sign in button',
  button: true,
  enabled: !isLoading,
  child: ElevatedButton(...),
);
```

### Touch Targets

- **Minimum size:** 44x44px (iOS) / 48x48dp (Android)
- **Spacing:** Minimum 8px between interactive elements

---

## Form Validation & Error Handling

### Input Field States

1. **Default:** Gray border, placeholder text
2. **Focus:** Purple border, label floats up
3. **Filled Valid:** Green subtle indicator (optional)
4. **Error:** Red border + error message below
5. **Disabled:** Gray background, reduced opacity

### Error Display Pattern

```dart
TextFormField(
  decoration: InputDecoration(
    errorText: _email.isNotValid ? 'Please enter a valid email' : null,
    errorStyle: TextStyle(color: Colors.red),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
  ),
);
```

### Password Strength Indicator

```dart
LinearProgressIndicator(
  value: _passwordStrength, // 0.0 to 1.0
  backgroundColor: Colors.grey.shade300,
  valueColor: AlwaysStoppedAnimation(
    _passwordStrength < 0.5
      ? Colors.red
      : _passwordStrength < 0.8
        ? Colors.orange
        : Colors.green,
  ),
);
```

---

## Social Login Buttons

### Design Specifications

- **Height:** 48px
- **Border radius:** 8px
- **Border:** 1px solid gray (light mode), dark gray (dark mode)
- **Icon:** 24x24px, left-aligned with 12px padding
- **Text:** "Continue with [Provider]", centered
- **Hover:** Background lightens, border color intensifies

### Supported Providers

1. **Google:** White background, multicolor logo
2. **Apple:** Black background (light), white (dark), white Apple logo
3. **GitHub:** Black background, white Octocat logo
4. **Facebook:** Blue (#1877F2) background, white 'f' logo

---

## Dark/Light Mode Implementation

### Theme Toggle

```dart
// System preference detection
final brightness = MediaQuery.of(context).platformBrightness;
final isDark = brightness == Brightness.dark;

// Manual toggle (for future Task 5.3.8)
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
      ? ThemeMode.dark
      : ThemeMode.light;
    notifyListeners();
  }
}
```

### Adaptive Colors

```dart
// Example: Adaptive text color
final textColor = isDark ? Colors.white : Color(0xFF1E293B);

// Example: Adaptive background
final backgroundColor = isDark
  ? Color(0xFF0F172A)
  : Color(0xFFF8FAFC);
```

---

## Performance Optimizations

### Image Assets

- Use SVG for icons (vector graphics)
- Compress PNG/JPG assets
- Lazy load images

### Animations

- Use `AnimatedContainer` for simple animations
- Use `Transform` instead of `Margin` for better performance
- Limit simultaneous animations

### List Performance

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    // Only build visible items
    return ListTile(...);
  },
);
```

---

## Mobile-Specific Considerations

### Safe Area Handling

```dart
SafeArea(
  child: Scaffold(...),
);
```

### Keyboard Handling

```dart
// Auto-scroll to focused input
Scaffold(
  resizeToAvoidBottomInset: true,
  body: SingleChildScrollView(
    child: Form(...),
  ),
);
```

### Touch Gestures

- Swipe to navigate back
- Pull to refresh
- Long press for context menu

---

## Figma Design Inspiration

### Reference: login-figma-inspire.jpg

The design draws inspiration from modern SaaS applications with:

- Split-screen layouts with hero imagery
- Glassmorphic UI elements
- Gradient accents and backgrounds
- Clean, minimal form designs
- Social login prioritization
- Micro-interactions on all interactive elements

### Key Takeaways Applied:

1. **Visual Hierarchy:** Large headlines, clear CTAs
2. **White Space:** Generous padding and spacing
3. **Color Psychology:** Calming blues/purples for trust
4. **Progressive Disclosure:** Simple initial forms, expand as needed
5. **Feedback Loops:** Immediate validation, loading states, success confirmations

---

## Future Enhancements

### Planned Features (Epic 5+)

- [ ] Skeleton loaders for data fetching
- [ ] Chart components with dark mode support (fl_chart)
- [ ] Data tables with sorting/filtering
- [ ] Toast notification system
- [ ] Modal dialog system
- [ ] File upload component
- [ ] Date/time picker with calendar
- [ ] Rich text editor
- [ ] Drag-and-drop functionality
- [ ] Print/PDF export styling

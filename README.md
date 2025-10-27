# 🎄 Shopify Christmas Theme Demo

A beautiful, modern Christmas-themed Shopify Hydrogen storefront built with React Router v7, TypeScript, and Tailwind CSS. This project showcases a festive holiday shopping experience with clean component architecture and responsive design.

![Christmas Theme Demo](https://via.placeholder.com/800x400/1f683e/ffffff?text=Christmas+Magic+Store+Demo)

## ✨ Features

- **🎁 Festive Christmas Design** - Beautiful holiday-themed UI with warm colors and festive typography
- **⚡ Modern Tech Stack** - Built with Shopify Hydrogen, React Router v7, and TypeScript
- **📱 Responsive Design** - Fully responsive layout that works on all devices
- **🛍️ Real Shopify Integration** - Connects to actual Shopify storefront API
- **🎨 Component Architecture** - Clean, reusable React components
- **🎯 Performance Optimized** - Fast loading with modern web technologies

## 🚀 Quick Start

### Prerequisites

- Node.js 18.0.0 or higher
- npm or yarn
- Shopify CLI

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/scottsdevelopment/shopify-christmas-theme-demo.git
   cd shopify-christmas-theme-demo
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your Shopify store details
   ```

4. **Start development server**
   ```bash
   npm run dev
   ```

5. **Open your browser**
   Navigate to `http://localhost:3000` to see your Christmas storefront!

## 🏗️ Project Structure

```
app/
├── components/           # Reusable React components
│   ├── HeroSection.tsx
│   ├── FeaturedProducts.tsx
│   ├── FeaturesSection.tsx
│   ├── TestimonialsSection.tsx
│   └── FooterCTA.tsx
├── routes/              # React Router pages
│   └── _index.tsx      # Homepage
├── styles/              # CSS and styling
│   └── app.css         # Main stylesheet
└── lib/                 # Utilities and helpers
```

## 🎨 Design System

### Color Palette
- **Holiday Red**: `#a4171f` - Primary brand color
- **Holiday Green**: `#1f683e` - Secondary accent color
- **Holiday Cream**: `#fcf6f0` - Background accent
- **Holiday White**: `#ffffff` - Clean backgrounds
- **Holiday Yellow**: `#fef7a5` - Accent highlights

### Typography
- **Playful Font**: Mountains of Christmas (headings)
- **Elegant Script**: Decorative text
- **Clean Sans**: Body text and UI elements

## 🛠️ Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint
- `npm run typecheck` - Run TypeScript checks

## 📱 Responsive Design

The theme is fully responsive with breakpoints optimized for:
- **Desktop**: Full-width layouts with multi-column grids
- **Tablet**: Adjusted spacing and single-column layouts
- **Mobile**: Optimized touch targets and stacked layouts

## 🎯 Key Components

### HeroSection
- Eye-catching Christmas messaging
- Call-to-action buttons
- Hero image with festive decorations

### FeaturedProducts
- Dynamic product grid from Shopify API
- Product images, titles, and pricing
- Hover effects and smooth animations

### FeaturesSection
- "Your One-Stop Christmas Shop" benefits
- Icon-based feature cards
- Trust-building messaging

### TestimonialsSection
- Customer testimonials
- Trust logos from major brands
- Social proof elements

### FooterCTA
- Final call-to-action
- Multiple action buttons
- Festive background styling

## 🔧 Customization

### Adding New Products
Products are automatically fetched from your Shopify store. To customize which products appear:

1. Edit the GraphQL query in `app/routes/_index.tsx`
2. Modify the `FEATURED_PRODUCTS_QUERY` to change sorting or filtering
3. Update the `first` parameter to show more/fewer products

### Styling Changes
All styles are in `app/styles/app.css` using Tailwind CSS classes and custom CSS variables.

### Component Modifications
Each component is in its own file in `app/components/` for easy modification and reuse.

## 🚀 Deployment

### Deploy to Shopify Oxygen
```bash
npm run build
shopify hydrogen deploy
```

### Deploy to Vercel/Netlify
```bash
npm run build
# Deploy the dist/ folder to your preferred platform
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Shopify Hydrogen](https://shopify.dev/custom-storefronts/hydrogen)
- Powered by [React Router v7](https://reactrouter.com/)
- Styled with [Tailwind CSS](https://tailwindcss.com/)
- Icons and images from the public domain

## 📞 Support

If you have any questions or need help with this project, please:
- Open an issue on GitHub
- Contact [Scott's Development](https://github.com/scottsdevelopment)

---

**Made with ❤️ and ☕ by Scott's Development**

*Happy Holidays! 🎄🎁*
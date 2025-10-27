export function FeaturesSection() {
  return (
    <section className="holiday-features">
      <div className="holiday-features-content">
        <h2 className="holiday-section-title">
          ✨ Your One-Stop Christmas Shop
        </h2>
        <p className="holiday-section-subtitle">
          From sparkling decorations to perfect gift bundles, we've got everything to make the season bright.
        </p>
        <div className="holiday-features-grid">
          <div className="holiday-feature-card">
            <div className="holiday-feature-icon">
              <div className="holiday-icon gift-icon"></div>
            </div>
            <h3 className="holiday-feature-title">Handpicked Holiday Gifts</h3>
            <p className="holiday-feature-description">Unique toys, décor, and treats for everyone on your list.</p>
          </div>
          <div className="holiday-feature-card">
            <div className="holiday-feature-icon">
              <div className="holiday-icon tree-icon"></div>
            </div>
            <h3 className="holiday-feature-title">Exclusive Seasonal Deals</h3>
            <p className="holiday-feature-description">Special offers and limited-time bundles to spread holiday cheer.</p>
          </div>
          <div className="holiday-feature-card">
            <div className="holiday-feature-icon">
              <div className="holiday-icon envelope-icon"></div>
            </div>
            <h3 className="holiday-feature-title">Fast & Secure Checkout</h3>
            <p className="holiday-feature-description">Shop with confidence this festive season.</p>
          </div>
        </div>
      </div>
    </section>
  );
}

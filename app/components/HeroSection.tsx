export function HeroSection() {
  return (
    <section className="holiday-hero">
      <div className="holiday-hero-content">
        <div className="holiday-hero-text">
          <h1 className="holiday-hero-title">
            🎄 Make This Christmas Unforgettable! 🎁
          </h1>
          <p className="holiday-hero-subtitle">
            Bring the magic of the holidays directly to your customers with our festive products.
          </p>
          <div className="holiday-hero-buttons">
            <button className="holiday-btn holiday-btn-primary">
              Shop Christmas Magic Today
            </button>
            <button className="holiday-btn holiday-btn-secondary">
              Bundle & Save
            </button>
          </div>
        </div>
        <div className="holiday-hero-illustration">
          <img 
            src="/images/hero-image.png" 
            alt="Festive holiday storefront with Christmas decorations" 
            className="holiday-hero-image"
          />
        </div>
      </div>
    </section>
  );
}

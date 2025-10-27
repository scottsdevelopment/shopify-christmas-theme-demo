export function TestimonialsSection() {
  return (
    <section className="holiday-testimonials">
      <div className="holiday-testimonials-content">
        <h2 className="holiday-section-title">
          🎅 Customer Favorites
        </h2>
        <div className="holiday-testimonial">
          <blockquote className="holiday-testimonial-quote">
            "We found the perfect gifts for the whole family!"
          </blockquote>
          <cite className="holiday-testimonial-author">– Jane D., Happy Shopper</cite>
        </div>
        <div className="holiday-trust-logos">
          <img 
            src="/images/allbirds_logo.png" 
            alt="Allbirds" 
            className="brand-logo"
          />
          <img 
            src="/images/gymshark_logo.png" 
            alt="Gymshark" 
            className="brand-logo"
          />
          <img 
            src="/images/tovala_logo.png" 
            alt="Tovala" 
            className="brand-logo"
          />
        </div>
      </div>
    </section>
  );
}

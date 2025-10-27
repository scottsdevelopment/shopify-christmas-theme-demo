interface FeaturedProductsProps {
  products: Array<{
    id: string;
    title: string;
    featuredImage?: {
      url: string;
      altText?: string;
    };
    priceRange: {
      minVariantPrice: {
        amount: string;
        currencyCode: string;
      };
    };
  }>;
}

export function FeaturedProducts({products}: FeaturedProductsProps) {
  return (
    <section className="holiday-featured-products">
      <div className="holiday-featured-content">
        <h2 className="holiday-section-title">
          ✨ Featured Products
        </h2>
        <div className="holiday-products-grid">
          {products.map((product) => (
            <div key={product.id} className="holiday-product-card">
              <div className="holiday-product-image">
                {product.featuredImage && (
                  <img 
                    src={product.featuredImage.url} 
                    alt={product.featuredImage.altText || product.title}
                    className="holiday-product-img"
                  />
                )}
              </div>
              <h3 className="holiday-product-title">{product.title}</h3>
              <div className="holiday-product-price">
                {product.priceRange.minVariantPrice.amount} {product.priceRange.minVariantPrice.currencyCode}
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

import {useLoaderData} from 'react-router';
import type {Route} from './+types/_index';
import {HeroSection} from '~/components/HeroSection';
import {FeaturedProducts} from '~/components/FeaturedProducts';
import {FeaturesSection} from '~/components/FeaturesSection';
import {TestimonialsSection} from '~/components/TestimonialsSection';
import {FooterCTA} from '~/components/FooterCTA';

export const meta: Route.MetaFunction = () => {
  return [
    {title: 'Christmas Magic Store | Make This Christmas Unforgettable'},
    {name: 'description', content: 'Bring the magic of the holidays directly to your customers with our festive products. Your one-stop Christmas shop with handpicked gifts and exclusive seasonal deals.'},
  ];
};

export async function loader({context}: Route.LoaderArgs) {
  const {storefront} = context;
  
  // Fetch featured products for the homepage
  const {products} = await storefront.query(FEATURED_PRODUCTS_QUERY, {
    variables: {first: 3},
  });

  return {
    featuredProducts: products.nodes,
  };
}

export default function HolidayLanding() {
  const {featuredProducts} = useLoaderData<typeof loader>();
  return (
    <div className="holiday-landing holiday-fullscreen">
      <HeroSection />
      <FeaturedProducts products={featuredProducts} />
      <FeaturesSection />
      <TestimonialsSection />
      <FooterCTA />
    </div>
  );
}

const FEATURED_PRODUCT_FRAGMENT = `#graphql
  fragment MoneyProductItem on MoneyV2 {
    amount
    currencyCode
  }
  fragment FeaturedProduct on Product {
    id
    handle
    title
    featuredImage {
      id
      altText
      url
      width
      height
    }
    priceRange {
      minVariantPrice {
        ...MoneyProductItem
      }
      maxVariantPrice {
        ...MoneyProductItem
      }
    }
  }
` as const;

const FEATURED_PRODUCTS_QUERY = `#graphql
  ${FEATURED_PRODUCT_FRAGMENT}
  query FeaturedProducts(
    $country: CountryCode
    $language: LanguageCode
    $first: Int!
  ) @inContext(country: $country, language: $language) {
    products(first: $first, sortKey: CREATED_AT, reverse: true) {
      nodes {
        ...FeaturedProduct
      }
    }
  }
` as const;

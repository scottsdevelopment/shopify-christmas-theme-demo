import {
  createContext,
  type ReactNode,
  useContext,
  useEffect,
  useState,
} from 'react';

type AsideType = 'search' | 'cart' | 'mobile' | 'closed';
type AsideContextValue = {
  type: AsideType;
  open: (mode: AsideType) => void;
  close: () => void;
};

/**
 * A side bar component with Overlay
 * @example
 * ```jsx
 * <Aside type="search" heading="SEARCH">
 *  <input type="search" />
 *  ...
 * </Aside>
 * ```
 */
export function Aside({
  children,
  heading,
  type,
}: {
  children?: React.ReactNode;
  type: AsideType;
  heading: React.ReactNode;
}) {
  const {type: activeType, close} = useAside();
  const expanded = type === activeType;

  useEffect(() => {
    const abortController = new AbortController();

    if (expanded) {
      document.addEventListener(
        'keydown',
        function handler(event: KeyboardEvent) {
          if (event.key === 'Escape') {
            close();
          }
        },
        {signal: abortController.signal},
      );
    }
    return () => abortController.abort();
  }, [close, expanded]);

  return (
    <div
      aria-modal
      className={`bg-black/20 bottom-0 left-0 opacity-0 pointer-events-none fixed right-0 top-0 transition-opacity duration-400 ease-in-out invisible z-10 ${expanded ? 'opacity-100 pointer-events-auto visible' : ''}`}
      role="dialog"
    >
      <button className="bg-transparent border-0 text-transparent h-full left-0 absolute top-0" style={{width: 'calc(100% - 400px)'}} onClick={close} />
      <aside className="bg-white shadow-[0_0_50px_rgba(0,0,0,0.3)] h-screen w-[min(400px,100vw)] fixed right-[-400px] top-0 transition-transform duration-200 ease-in-out" style={expanded ? {transform: 'translateX(-400px)'} : {}}>
        <header className="items-center border-b border-black flex h-16 justify-between px-5">
          <h3 className="m-0">{heading}</h3>
          <button className="font-bold opacity-80 no-underline transition-all duration-200 w-5 hover:opacity-100 border-0 bg-inherit text-base" onClick={close} aria-label="Close">
            &times;
          </button>
        </header>
        <main className="m-4">{children}</main>
      </aside>
    </div>
  );
}

const AsideContext = createContext<AsideContextValue | null>(null);

Aside.Provider = function AsideProvider({children}: {children: ReactNode}) {
  const [type, setType] = useState<AsideType>('closed');

  return (
    <AsideContext.Provider
      value={{
        type,
        open: setType,
        close: () => setType('closed'),
      }}
    >
      {children}
    </AsideContext.Provider>
  );
};

export function useAside() {
  const aside = useContext(AsideContext);
  if (!aside) {
    throw new Error('useAside must be used within an AsideProvider');
  }
  return aside;
}

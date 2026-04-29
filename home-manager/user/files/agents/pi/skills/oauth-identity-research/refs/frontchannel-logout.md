# OpenID Connect Front-Channel Logout

## openid-connect-frontchannel-1_0

**Problem:** Same as Back-Channel Logout: RP sessions persist after OP logout. Front-Channel uses the browser instead of server-to-server calls.

**Mechanism:** OP renders hidden iframes pointing to each RP's `frontchannel_logout_uri` during logout. Browser loads the iframe URLs, which clear RP sessions via cookies.

Optionally includes `iss` and `sid` query parameters so the RP knows which session to terminate.

**When to use:** SPAs or apps without a backend that can receive Back-Channel Logout. When you need browser-based session clearing.

**Tradeoffs:** Depends on third-party cookies (browsers blocking these). Unreliable: browser may block iframes, user may close browser mid-logout. Less reliable than Back-Channel Logout. Being phased out in favor of Back-Channel Logout.

**Contrast with Back-Channel Logout:** Front-Channel goes through the browser (fragile, cookie-dependent). Back-Channel goes server-to-server (reliable, but needs reachable endpoint).

**Link:** [Spec](https://openid.net/specs/openid-connect-frontchannel-1_0.html)

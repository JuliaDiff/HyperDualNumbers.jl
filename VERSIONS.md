### Versions

#### v4.0.0

A complete rewrite of the implementation by Benoit Pasquier.

##### Notes:

1. v4.0.0 redefined abs in such a way that the 2nd derivative of abs(-x^2) is correct. (Additionally, the previous abs(x) = sqrt(x^2) was quite slower — compare e.g., with Base.abs.)

2. v4.0.0 did not include some functions (sometimes on purpose, sometimes because I did not know what to do with them). But I thought I should raise the issue that some functions should not be available for differentiation in ℂ because they are differentiable nowhere. Namely functions that inject into ℝ, like abs or angle, but also some quite common functions like conj. (The functions that are ℂ-differentiable should be in the code though.)

3. I chose to write my own list of first and second derivatives (using sagemath) to use for overloading most of the functions (like cos, sin, etc.). This was to match DualNumbers.jl's approach (which uses a list in Calculus.jl. (I saw that ForwardDiff.jl uses DiffRules.jl instead — so maybe this is were this list should go to be used by all other packages?)

4. I renamed a few things to match the DualNumbers.jl nomenclature (e.g., realpart) and tried to keep aliases to older definitions (e.g., eps1eps2 is replaced by a clearer ε₁ε₂part to match the realpart construct, but eps1eps2 still available for backward compatibility)

5. I changed a few tests from a == b to isequal(a, b) on purpose because == only compared the real part (h/h == 1 would give true even if the non-real parts are wrong for example).

##### Outstanding questions/remarks:

1. (Unsure, but) no `abs`, `real`, `conj`, `angle` or `imag`for hyperdual complex because differentiable nowhere in ℂ (these functions don't satisfy the Cauchy–Riemann equations). I guess it might be usable for printing or other checking purposes, but then I guess the user should define his own functions, at its own risk, rather than having this package suggest a value that does not make mathematical sense, right? (I may be completely wrong about this)

2. No flipsign so far but maybe I should make it like the `abs` above and then have `abs(x) = flipsign(x, x)`?

3. No `conjhyper`, `abshyper`, or `abs2hyper` because I don't understand their purpose in DualNumbers

4. TODO: sinpi and cospi (erased here) should be generated in Calculus

using Symata, Test

println()
@sym begin
  f(x_) := Sin(x)^Cos(x)
  yi = [1, 5, 10]
  f1(x_) := Simplify( D(f(x), x, 1) )
  f2(x_) := Simplify( D(f(x), x, 2) )
  SetJ(q, ToString(f1(x)))
  SetJ(u, ToString(f2(x)))
end

@sym Print("f1(x) = ", f1(x))
println()
@sym Print("f2(x) = ", f2(x))
println()

println()
q = @sym ToString(f1(x));
q |> display
println()
u = @sym ToString(f2(x));
u |> display
println()

@eval f1(x) = $(Meta.parse(q))
@eval f2(x) = $(Meta.parse(u))

f1(Complex(4.5)) |> display
f2(Complex(4.5)) |> display

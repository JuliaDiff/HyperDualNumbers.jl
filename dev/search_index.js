var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "HyperDualNumbers",
    "title": "HyperDualNumbers",
    "category": "page",
    "text": ""
},

{
    "location": "#HyperDualNumbers-1",
    "page": "HyperDualNumbers",
    "title": "HyperDualNumbers",
    "category": "section",
    "text": "Hyper-dual numbers can be used to compute first and second derivatives numerically without the cancellation errors of finite-differencing schemes.The initial Julia implementation (and up to v3.0.1) is directly based on the C++ implementation by Jeffrey Fike and Juan J Alonso, both of Stanford University, department of Aeronautics and Astronautics and is described in the paper:The Development of Hyper-Dual Numbers for Exact Second Derivative CalculationsThe early versions have been derived/written by Rob J Goedman (goedman@icloud.com).HyperDualNumbers.jl v4.0.0 has been completely redone by Benoit Pasquier and follows the structure of the JuliaDiff/DualNumbers package.]CurrentModule = HyperDualNumbers"
},

{
    "location": "#HyperDualNumbers.Hyper-Tuple{}",
    "page": "HyperDualNumbers",
    "title": "HyperDualNumbers.Hyper",
    "category": "method",
    "text": "Creation of a HyperDualNumber\n\nhn = Hyper(2.0, 1.0, 1.0, 0.0)\n\n\n\n\n\n"
},

{
    "location": "#Creation-of-a-HyperDualNumber-1",
    "page": "HyperDualNumbers",
    "title": "Creation of a HyperDualNumber",
    "category": "section",
    "text": "HyperDualNumbers.Hyper()"
},

{
    "location": "#HyperDualNumbers.symbolic_derivative_list",
    "page": "HyperDualNumbers",
    "title": "HyperDualNumbers.symbolic_derivative_list",
    "category": "constant",
    "text": "Symbolic derivative list\n\nThe format is a list of (Symbol,Expr,Expr) tuples.\n\nEntries in each tuple:\n\n* `:f `     : Function symbol\n* `:df`    : Symbolic expression for first derivative\n* `:d²f`   : Symbolic expression for second derivative\n\nThe symbol :x is used within deriv_expr for the point at which the derivative should be evaluated.\n\nExample of a tuple in the list\n\n(:sqrt, :(1/2/sqrt(x)), :(-1/4/x^(3/2)))\n\n\n\n\n\n"
},

{
    "location": "#Symbolic-derivative-list-1",
    "page": "HyperDualNumbers",
    "title": "Symbolic derivative list",
    "category": "section",
    "text": "HyperDualNumbers.symbolic_derivative_list"
},

{
    "location": "#HyperDualNumbers.ε₁",
    "page": "HyperDualNumbers",
    "title": "HyperDualNumbers.ε₁",
    "category": "constant",
    "text": "ɛ₁ contains the first derivative after the evaluation\n\n\n\n\n\n"
},

{
    "location": "#HyperDualNumbers.ε₂",
    "page": "HyperDualNumbers",
    "title": "HyperDualNumbers.ε₂",
    "category": "constant",
    "text": "ɛ₂ contains the first derivative after the evaluation\n\n\n\n\n\n"
},

{
    "location": "#HyperDualNumbers.ε₁ε₂",
    "page": "HyperDualNumbers",
    "title": "HyperDualNumbers.ε₁ε₂",
    "category": "constant",
    "text": "ɛ₁ɛ₂ contains the second derivative after the evaluation\n\n\n\n\n\n"
},

{
    "location": "#Fields-of-a-HyperDualNumber-1",
    "page": "HyperDualNumbers",
    "title": "Fields of a HyperDualNumber",
    "category": "section",
    "text": "HyperDualNumbers.ɛ₁\nHyperDualNumbers.ɛ₂\nHyperDualNumbers.ε₁ɛ₂"
},

{
    "location": "#Index-1",
    "page": "HyperDualNumbers",
    "title": "Index",
    "category": "section",
    "text": ""
},

]}

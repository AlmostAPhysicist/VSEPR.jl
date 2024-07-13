
module MyParticle
export Particle2D, UnitSphere

include("./MyColors.jl")
using GeometryBasics, .MyColors, Observables



# import StaticArrays.SVector

const UnitSphere = normal_mesh(Tesselation(Sphere(Point3f(0), 1), 50))
function Base.show(io::IO, mime::MIME"text/plain", unitsphere::typeof(UnitSphere))
    show(io, mime, "UnitSphere (alias for Tesselated normal Mesh of Sphere)")
end

#You can also use Sphere() as a marker but I like this.
#mesh() would plot a mesh in Makie. GeometryBasics.mesh creates some non-colorable version of the object. normal_mesh is the way to go then.

"""
>    `Particle`

a custom `mutable struct` to encorporate properties of a particle like it's Kinetics and Intrinsic mass, charge, shape, etc.
    
All properties that affect render are `Observables` by default

---

# Fields

    #Kinetics
  -  `pos` :: A `Point2` or `Point3` or `Tuple`
  -  `vel` :: A `Point2` or `Point3` or `Tuple`
  -  `acc` :: A `Point2` or `Point3` or `Tuple`

    #Intrinsic Properties
  -  `mass` :: `Real`
  -  `charge` :: `Real`
  -  `color` :: `String` (Hex value)
  -  `shape` :: `Circle`/`Sphere` by default
  -  `size` :: `Real`
  -  `alpha` :: `Real` (input between 0 and 1)

---

# Example Usage:
```julia
julia> using GLMakie
julia> s = Scene(camera=cam2d!)
julia> p = Particle()

> Particle(Observable(Float32[0.0, 0.0]), Float32[0.0, 0.0], Float32[0.0, 0.0], 1, 1, Observable("#f2baaf"), Observable(Circle), Observable(10), Observable(1))

julia> scatter!(s, p.pos, marker=p.shape, color=p.color, markersize=p.size)

> Scatter{Tuple{Vector{Point{2, Float32}}}}

#This creates a particle at origin but since by default, 2d scenes have markerspace=:pixel, not scalable

julia> scatter!(s, p.pos, markersize=to_value(p.size).*(0.045,0.060), markerspace=:data) #For scalable particle render

> Scatter{Tuple{Vector{Point{2, Float32}}}}

#Note how markersize can be set as a tuple. This was done here to nullify the screen ratio since now markerspace deals with that.

#3D
julia> s = Scene(camera=cam3d!)
julia> p = Particle(Point3f(0,1,0), color=RED)

> Particle(Observable(Float32[0.0, 1.0, 0.0]), Float32[0.0, 0.0, 0.0], Float32[0.0, 0.0, 0.0], 1, 1, Observable("#f03e50"), VALUE_OF_UNITSPHERE_NORMAL_MESH, Observable(5), Observable(1))

julia> meshscatter!(s, p.pos, marker=p.shape, color=p.color)

> MeshScatter{Tuple{Vector{Point{3, Float32}}}}


```

===

"""


struct Particle2D{T<:Real}
    pos::Observable{Point{2,T}}
    vel::Observable{Point{2,T}}
    acc::Observable{Point{2,T}}
    mass::T
    charge::T
    color::Observable{String}
    shape::Observable
    size::Observable{T}
    alpha::Observable{T}

    function Particle2D(
        pos::Union{Tuple{Real, Real}, Vector{<:Real}, Vec{2, <:Real}}=(0., 0.);
        vel::Union{Tuple{Real, Real}, Vector{<:Real}, Vec{2, <:Real}}=(0., 0.),
        acc::Union{Tuple{Real, Real}, Vector{<:Real}, Vec{2, <:Real}}=(0., 0.),
        mass::Real=1,
        charge::Real=1,
        color::String=RED,
        shape=GeometryBasics.Circle,
        size::Real=10,
        alpha::Real=1
        )
        super_T = promote_type(
            eltype(pos),
            eltype(vel),
            eltype(acc),
            typeof(mass),
            typeof(charge),
            typeof(size),
            typeof(alpha)
            )
            
        new{super_T}(
            Observable(convert(Point{2,super_T}, pos)),
            Observable(convert(Point{2,super_T}, vel)),
            Observable(convert(Point{2,super_T}, acc)),
            convert(super_T, mass),
            convert(super_T, charge),
            Observable(color),
            Observable(shape),
            Observable(convert(super_T, size)),
            Observable(convert(super_T, alpha))
            )
    end
    
    function Particle2D(
        pos::Point{2,<:Real}=Point{2, Float64}(0, 0);
        vel::Point{2,<:Real}=Point{2, Float64}(0, 0),
        acc::Point{2,<:Real}=Point{2, Float64}(0, 0),
        mass::Real=1,
        charge::Real=1,
        color::String=RED,
        shape=GeometryBasics.Circle,
        size::Real=10,
        alpha::Real=1
        )
        super_T = promote_type(
            eltype(pos),
            eltype(vel),
            eltype(acc),
            typeof(mass),
            typeof(charge),
            typeof(size),
            typeof(alpha)
            )
            
        new{super_T}(
            Observable(convert(Point{2,super_T}, pos)),
            Observable(convert(Point{2,super_T}, vel)),
            Observable(convert(Point{2,super_T}, acc)),
            convert(super_T, mass),
            convert(super_T, charge),
            Observable(color),
            Observable(shape),
            Observable(convert(super_T, size)),
            Observable(convert(super_T, alpha))
            )
        end
        
    function Particle2D(T::Type=Float64)
        new{T}(Observable(Point{2,T}(0, 0)), Observable(Point{2,T}(0, 0)), Observable(Point{2,T}(0, 0)), T(0), T(0), Observable(RED), Observable(GeometryBasics.Circle), Observable(T(10)), Observable(T(1)))
    end
end
        

struct Particle3D{T<:Real}
    pos::Observable{Point{3,T}}
    vel::Observable{Point{3,T}}
    acc::Observable{Point{3,T}}
    mass::T
    charge::T
    color::Observable{String}
    shape::Observable
    size::Observable{T}
    alpha::Observable{T}
    
    function Particle3D(
        pos::Point{3,<:Real}=Point{3, Float64}(0, 0, 0);
        vel::Point{3,<:Real}=Point{3, Float64}(0, 0, 0),
        acc::Point{3,<:Real}=Point{3, Float64}(0, 0, 0),
        mass::Real=1,
        charge::Real=1,
        color::String=RED,
        shape=UnitSphere,
        size::Real=10,
        alpha::Real=1
        )
        super_T = promote_type(
            eltype(pos),
            eltype(vel),
            eltype(acc),
            typeof(mass),
            typeof(charge),
            typeof(size),
            typeof(alpha)
            )
            
        new{super_T}(
            Observable(convert(Point{3,super_T}, pos)),
            Observable(convert(Point{3,super_T}, vel)),
            Observable(convert(Point{3,super_T}, acc)),
            convert(super_T, mass),
            convert(super_T, charge),
            Observable(color),
            Observable(shape),
            Observable(convert(super_T, size)),
            Observable(convert(super_T, alpha))
            )
        end
        
    function Particle3D(T::Type=Float64)
        new{T}(Observable(Point{3,T}(0, 0, 0)), Observable(Point{3,T}(0, 0, 0)), Observable(Point{3,T}(0, 0, 0)), T(0), T(0), Observable(RED), Observable(UnitSphere), Observable(T(10)), Observable(T(1)))
    end
end
        #Note: If Alpha != 1, set transparency = true else things dont really work as expected
        
        
        
        """
        julia> Particle2D()
        Particle2D{Int64}(Observable([0, 0]), Observable([0, 0]), Observable([0, 0]), 1, 1, Observable(Circle), Observable(10), Observable(1))
        
        julia> Particle2D(Point(1,2))
        Particle2D{Int64}(Observable([1, 2]), Observable([0, 0]), Observable([0, 0]), 1, 1, Observable(Circle), Observable(10), Observable(1))
        
        julia> @benchmark Particle2D()
        BenchmarkTools.Trial: 10000 samples with 168 evaluations.
 Range (min … max):  644.048 ns … 23.988 μs  ┊ GC (min … max): 0.00% … 95.21%
 Time  (median):     676.786 ns              ┊ GC (median):    0.00%
 Time  (mean ± σ):   768.488 ns ±  1.027 μs  ┊ GC (mean ± σ):  9.29% ±  6.68%

  ▄▇█▆▇▇▅▃▂▁▂▃▂▂▂▂▂▃▂▂▂▁▁▁▂▁▁▁▁                                ▂
  █████████████████████████████████▇▆▆▅▆▆▆▄▆▅▅▆▅▄▅▁▅▃▄▃▃▁▃▁▅▅▄ █
  644 ns        Histogram: log(frequency) by time       1.1 μs <

 Memory estimate: 1.36 KiB, allocs estimate: 27.

julia> @benchmark Particle2D()
BenchmarkTools.Trial: 10000 samples with 165 evaluations.
 Range (min … max):  643.636 ns … 37.964 μs  ┊ GC (min … max):  0.00% … 97.59%
 Time  (median):     679.394 ns              ┊ GC (median):     0.00%
 Time  (mean ± σ):   816.632 ns ±  1.514 μs  ┊ GC (mean ± σ):  12.77% ±  6.72%

  ▆█▇▇▄▃▃▃▃▃▃▂▂▂▁▁▁                                            ▂
  ███████████████████▇▇▇▆▇▆▆▆▅▅▅▅▄▅▃▄▄▄▅▃▅▆▅▆▄▂▄▃▄▂▄▃▃▄▃▄▄▃▂▂▄ █
  644 ns        Histogram: log(frequency) by time      1.44 μs <

 Memory estimate: 1.36 KiB, allocs estimate: 27.

julia> @benchmark Particle2D()
BenchmarkTools.Trial: 10000 samples with 165 evaluations.
 Range (min … max):  643.030 ns … 25.619 μs  ┊ GC (min … max):  0.00% … 94.46%
 Time  (median):     676.970 ns              ┊ GC (median):     0.00%
 Time  (mean ± σ):   805.912 ns ±  1.457 μs  ┊ GC (mean ± σ):  12.55% ±  6.72%

   █▅▄▂
  ▆████▄▃▃▃▃▃▃▃▃▃▃▃▃▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▁▂▂▂▂▂▂▂▂▂▂▂▂▂▁▂▂ ▃
  643 ns          Histogram: frequency by time         1.27 μs <

 Memory estimate: 1.36 KiB, allocs estimate: 27.


---


julia> @benchmark Particle2D().pos[] += [1,2]
BenchmarkTools.Trial: 10000 samples with 98 evaluations.
 Range (min … max):  793.878 ns … 61.263 μs  ┊ GC (min … max):  0.00% … 97.09%
 Time  (median):     905.102 ns              ┊ GC (median):     0.00%
 Time  (mean ± σ):     1.095 μs ±  2.381 μs  ┊ GC (mean ± σ):  12.22% ±  5.54%

  ▆█▆▆▄▇▆▆▆▅▄▄▄▄▃▃▂▁▁                           ▁ ▁ ▁          ▂
  █████████████████████▇█▆▆▅▆▆▅▅▄▅▅▆▅▅▅▆▆▆▆▆▇▇█████████▇▇▇▇▅▆▆ █
  794 ns        Histogram: log(frequency) by time      1.92 μs <

 Memory estimate: 1.56 KiB, allocs estimate: 32.

julia> @benchmark Particle2D().pos[] += [1,2]
BenchmarkTools.Trial: 10000 samples with 100 evaluations.
 Range (min … max):  797.000 ns … 54.180 μs  ┊ GC (min … max):  0.00% … 91.88%
 Time  (median):     829.000 ns              ┊ GC (median):     0.00%
 Time  (mean ± σ):     1.002 μs ±  2.255 μs  ┊ GC (mean ± σ):  12.82% ±  5.60%

  ▇█▆▆▄▃▃▃▃▂▂▂▂▁▁▁                                             ▂
  ███████████████████▇▆▆▆▆▆▅▅▇▆▆▆▆▆▅▅▅▅▄▄▄▆▄▄▄▃▃▄▃▅▄▄▁▁▄▃▃▁▄▄▅ █
  797 ns        Histogram: log(frequency) by time      1.91 μs <

 Memory estimate: 1.56 KiB, allocs estimate: 32.

julia> @benchmark Particle2D().pos[] += [1,2]
BenchmarkTools.Trial: 10000 samples with 92 evaluations.
 Range (min … max):  797.826 ns … 53.449 μs  ┊ GC (min … max):  0.00% … 97.26%
 Time  (median):     829.348 ns              ┊ GC (median):     0.00%
 Time  (mean ± σ):   990.110 ns ±  2.300 μs  ┊ GC (mean ± σ):  12.74% ±  5.38%

  ▄██▇▅▆▆▆▄▃▂▃▃▁▂▂▂▂▁▁▁▁▁▁▁▁▁ ▁                                ▂
  ██████████████████████████████▇██▇█▇▇▇▇▆▇▇▆▆▇▅▅▁▅▅▃▃▄▃▅▅▄▅▄▄ █
  798 ns        Histogram: log(frequency) by time      1.36 μs <

 Memory estimate: 1.56 KiB, allocs estimate: 32.
"""

#END OF MODULE
end


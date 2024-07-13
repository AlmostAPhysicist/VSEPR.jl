
module MyParticles

#My Constants, Functions and Structs
export UnitSphere
export Particle2D, Particle3D, Particle


include("./MyColors.jl")
using GeometryBasics, .MyColors, Observables

abstract type Particle end

# import StaticArrays.SVector

const UnitSphere = normal_mesh(Tesselation(Sphere(Point3f(0), 1), 50))
function Base.show(io::IO, mime::MIME"text/plain", unitsphere::typeof(UnitSphere))
    show(io, mime, "UnitSphere (alias for Tesselated normal Mesh of Sphere)")
end

#You can also use Sphere() as a marker but I like this.
#mesh() would plot a mesh in Makie. GeometryBasics.mesh creates some non-colorable version of the object. normal_mesh is the way to go then.

"""
   Particle2D

`struct Particle2D{T<:Real} <: Particle`

A Particle2D represents a particle in a 2D space with observable properties. It can be used in GLMakie scenes for visualization.

---

# Fields
    - pos::Observable{Point{2,T}}
    - vel::Observable{Point{2,T}}
    - acc::Observable{Point{2,T}}
    - mass::T
    - charge::T
    - color::Observable{String}
    - shape::Observable
    - size::Observable{T}
    - alpha::Observable{T}

# Examples
```jldoctest
julia> Particle2D()
Particle2D{Float64}(Observable([0.0, 0.0]), Observable([0.0, 0.0]), Observable([0.0, 0.0]), 1.0, 1.0, Observable("#f03e50"), Observable(GeometryBasics.Circle), Observable(1.0), Observable(1.0))

julia> Particle2D(size=10, vel=(1,2))
Particle2D{Float64}(Observable([0.0, 0.0]), Observable([1.0, 2.0]), Observable([0.0, 0.0]), 1.0, 1.0, Observable("#f03e50"), Observable(GeometryBasics.Circle), Observable(10.0), Observable(1.0))

julia> using GeometryBasics

julia> Particle2D(Point(3,7))
Particle2D{Float64}(Observable([3.0, 7.0]), Observable([0.0, 0.0]), Observable([0.0, 0.0]), 1.0, 1.0, Observable("#f03e50"), Observable(Circle), Observable(1.0), Observable(1.0))

julia> p = Particle2D(Int64)
Particle2D{Int64}(Observable([0, 0]), Observable([0, 0]), Observable([0, 0]), 1, 1, Observable("#f03e50"), Observable(Circle), Observable(1), Observable(1))

julia> using GLMakie

julia> s = Scene(camera=cam2d!, size=(600,600))

julia> scatter!(s, p.pos, marker=p.shape, markersize=p.size, color=p.color, markerspace=:data) #Renders Particle into Scene. Use markersize=(reverse(size(s)).*(p.size[]/1000)) for irregular scene)
Scatter{Tuple{Vector{Point{2, Float64}}}}

julia> p.vel[] = (1,0) #Sets Particle Velocity field
(1, 0)

julia> p.pos[] += p.vel[] #Moves the position of particle render within Scene
2-element Point{2, Int64} with indices SOneTo(2):
 1
 0
```

# Constructors

## General input

    -pos::Union{Point{2,<:Real}, Tuple{Real, Real}, Vector{<:Real}, Vec{2, <:Real}}=Point{2, Float64}(0);
    -vel::Union{Point{2,<:Real}, Tuple{Real, Real}, Vector{<:Real}, Vec{2, <:Real}}=Point{2, Float64}(0),
    -acc::Union{Point{2,<:Real}, Tuple{Real, Real}, Vector{<:Real}, Vec{2, <:Real}}=Point{2, Float64}(0),
    -mass::Real=1,
    -charge::Real=1,
    -color::String=RED,
    -shape=GeometryBasics.Circle,
    -size::Real=1,
    -alpha::Real=1

## Type input
    -T::Type=Float64

> ---
"""
struct Particle2D{T<:Real} <: Particle
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
        pos::Union{Point{2,<:Real}, Tuple{Real, Real}, Vector{<:Real}, Vec{2, <:Real}}=Point{2, Float64}(0);
        vel::Union{Point{2,<:Real}, Tuple{Real, Real}, Vector{<:Real}, Vec{2, <:Real}}=Point{2, Float64}(0),
        acc::Union{Point{2,<:Real}, Tuple{Real, Real}, Vector{<:Real}, Vec{2, <:Real}}=Point{2, Float64}(0),
        mass::Real=1,
        charge::Real=1,
        color::String=RED,
        shape=GeometryBasics.Circle,
        size::Real=1,
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
        new{T}(Observable(Point{2,T}(0)), Observable(Point{2,T}(0)), Observable(Point{2,T}(0)), T(1), T(1), Observable(RED), Observable(GeometryBasics.Circle), Observable(T(1)), Observable(T(1)))
    end
end


"""    
    Particle3D

`struct Particle3D{T<:Real} <: Particle`

A Particle3D represents a particle in a 3D space with observable properties. It can be used in GLMakie scenes for visualization.

---

# Fields
    - pos::Observable{Point{3,T}}
    - vel::Observable{Point{3,T}}
    - acc::Observable{Point{3,T}}
    - mass::T
    - charge::T
    - color::Observable{String}
    - shape::Observable
    - size::Observable{T}
    - alpha::Observable{T}

# Examples
```jldoctest
julia> Particle3D()
Particle3D{Float64}(Observable([0.0, 0.0, 0.0]), Observable([0.0, 0.0, 0.0]), Observable([0.0, 0.0, 0.0]), 1.0, 1.0, Observable("#f03e50"), Observable(UnitSphere), Observable(1.0), Observable(1.0))

julia> Particle3D(size=10, vel=(1,2,3))
Particle3D{Float64}(Observable([0.0, 0.0, 0.0]), Observable([1.0, 2.0, 3.0]), Observable([0.0, 0.0, 0.0]), 1.0, 1.0, Observable("#f03e50"), Observable(UnitSphere), Observable(10.0), Observable(1.0))

julia> using GeometryBasics

julia> Particle3D(Point(3,7,1))
Particle3D{Float64}(Observable([3.0, 7.0, 1.0]), Observable([0.0, 0.0, 0.0]), Observable([0.0, 0.0, 0.0]), 1.0, 1.0, Observable("#f03e50"), Observable(UnitSphere), Observable(1.0), Observable(1.0))

julia> p = Particle3D(Int64)
Particle3D{Int64}(Observable([0, 0, 0]), Observable([0, 0, 0]), Observable([0, 0, 0]), 1, 1, Observable("#f03e50"), Observable(UnitSphere), Observable(1), Observable(1))

julia> using GLMakie

julia> s = Scene(camera=cam3d!, size=(600,600))

julia> meshscatter!(s, p.pos, marker=p.shape, markersize=p.size, color=p.color) # Renders Particle into Scene
MeshScatter{Tuple{Vector{Point{3, Float64}}}}

julia> p.vel[] = (1,0,0) # Sets Particle Velocity field
(1, 0, 0)

julia> p.pos[] += p.vel[] # Moves the position of particle render within Scene
3-element Point{3, Int64} with indices SOneTo(3):
    1
    0
    0
```

# Constructors

## General input

    -pos::Union{Point{3,<:Real}, Tuple{Real, Real, Real}, Vector{<:Real}, Vec{3, <:Real}}=Point{3, Float64}(0);
    -vel::Union{Point{3,<:Real}, Tuple{Real, Real, Real}, Vector{<:Real}, Vec{3, <:Real}}=Point{3, Float64}(0),
    -acc::Union{Point{3,<:Real}, Tuple{Real, Real, Real}, Vector{<:Real}, Vec{3, <:Real}}=Point{3, Float64}(0),
    -mass::Real=1,
    -charge::Real=1,
    -color::String=RED,
    -shape=UnitSphere,
    -size::Real=1,
    -alpha::Real=1

## Type input
    -T::Type=Float64

> ---
"""
struct Particle3D{T<:Real} <: Particle
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
        pos::Union{Point{3,<:Real}, Tuple{Real, Real, Real}, Vector{<:Real}, Vec{3, <:Real}}=Point{3, Float64}(0);
        vel::Union{Point{3,<:Real}, Tuple{Real, Real, Real}, Vector{<:Real}, Vec{3, <:Real}}=Point{3, Float64}(0),
        acc::Union{Point{3,<:Real}, Tuple{Real, Real, Real}, Vector{<:Real}, Vec{3, <:Real}}=Point{3, Float64}(0),
        mass::Real=1,
        charge::Real=1,
        color::String=RED,
        shape=UnitSphere,
        size::Real=1,
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
        new{T}(Observable(Point{3,T}(0)), Observable(Point{3,T}(0)), Observable(Point{3,T}(0)), T(1), T(1), Observable(RED), Observable(UnitSphere), Observable(T(1)), Observable(T(1)))
    end
end


"""
    Particle

`Abstract Type`

    - Particle2D <: Particle <: Any
    - Particle3D <: Particle <: Any

>---

    Particle

A convenience function to create either a `Particle2D` or `Particle3D` based on the provided arguments.

if arg `pos` or kwargs `vel` and `acc` are 3 Dimentional, creates a `Particle3D`, else creates `Particle2D` unless there is an error

>---

# Fields
    - pos::Observable{Point{T}}
    - vel::Observable{Point{T}}
    - acc::Observable{Point{T}}
    - mass::T
    - charge::T
    - color::Observable{String}
    - shape::Observable
    - size::Observable{T}
    - alpha::Observable{T}

>---

see ```Particle2D``` and/or ```Particle3D``` for details

>---

"""
function Particle(args...; kwargs...)
    try
        return Particle2D(args...; kwargs...)
    catch
        try
            return Particle3D(args...; kwargs...)
        catch
            error(TypeError)
        end
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


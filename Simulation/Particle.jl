module MyParticle
export Particle, UnitSphere



include("./MyColors.jl")
using GeometryBasics, .MyColors, Observables

const UnitSphere = normal_mesh(Tesselation(Sphere(Point3f(0), 1), 50))
#You can also use Sphere() as a marker but I like this.
#mesh() would plot a mesh in Makie. GeometryBasics.mesh creates some non-colorable version of the object. normal_mesh is the way to go then.

"""
>    `Particle`

a custom `mutable struct` to encorporate properties of a particle like it's Kinetics and Intrinsic mass, charge, shape, etc.
    
All properties that affect render are `Observables` by default

---

# Fields

    #Kinetics
  -  `position` :: A `Point2` or `Point3` or `Tuple`
  -  `velocity` :: A `Point2` or `Point3` or `Tuple`
  -  `acceleration` :: A `Point2` or `Point3` or `Tuple`

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

julia> scatter!(s, p.position, marker=p.shape, color=p.color, markersize=p.size)

> Scatter{Tuple{Vector{Point{2, Float32}}}}

#This creates a particle at origin but since by default, 2d scenes have markerspace=:pixel, not scalable

julia> scatter!(s, p.position, markersize=to_value(p.size).*(0.045,0.060), markerspace=:data) #For scalable particle render

> Scatter{Tuple{Vector{Point{2, Float32}}}}

#Note how markersize can be set as a tuple. This was done here to nullify the screen ratio since now markerspace deals with that.

#3D
julia> s = Scene(camera=cam3d!)
julia> p = Particle(Point3f(0,1,0), color=RED)

> Particle(Observable(Float32[0.0, 1.0, 0.0]), Float32[0.0, 0.0, 0.0], Float32[0.0, 0.0, 0.0], 1, 1, Observable("#f03e50"), VALUE_OF_UNITSPHERE_NORMAL_MESH, Observable(5), Observable(1))

julia> meshscatter!(s, p.position, marker=p.shape, color=p.color)

> MeshScatter{Tuple{Vector{Point{3, Float32}}}}


```

===

"""
mutable struct Particle
    #Kinetics (arguments)
    position
    velocity
    acceleration

    #Intrinsic Properties (keyword arguments)
    mass
    charge
    color
    shape
    size
    alpha
    #Observable{<:Point3{<:Real}} might add this as well
    function Particle(
        position::Union{Point3{<:Real},Tuple{Real,Real,Real}}=Point3f(0),
        velocity::Union{Point3{<:Real},Tuple{Real,Real,Real}}=Point3f(0),
        acceleration::Union{Point3{<:Real},Tuple{Real,Real,Real}}=Point3f(0);
        mass::Real=1, charge::Real=1, color::String=rand(BASE_COLORS),
        shape=UnitSphere,
        size::Real=1, alpha::Real=1
    )
        new(
            Observable(Point(position)), Point(velocity), Point(acceleration),
            mass, charge, Observable(color), Observable(shape), Observable(size), Observable(alpha)
        )
    end

    function Particle(
        position::Union{Point2{<:Real},Tuple{Real,Real}}=Point2f(0),
        velocity::Union{Point2{<:Real},Tuple{Real,Real}}=Point2f(0),
        acceleration::Union{Point2{<:Real},Tuple{Real,Real}}=Point2f(0);
        mass::Real=1, charge::Real=1, color::String=rand(BASE_COLORS),
        shape=GeometryBasics.Circle, size::Real=10, alpha::Real=1
    )
        new(
            Observable(Point(position)), Point(velocity), Point(acceleration),
            mass, charge, Observable(color), Observable(shape), Observable(size), Observable(alpha)
        )
    end
end

#Note: If Alpha != 1, set transparency = true else things dont really work as expected




#END OF MODULE
end
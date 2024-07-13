include("./MyColors.jl")
using GeometryBasics, .MyColors, Observables

struct Particle2D
    pos::Observable{Point{2,Float64}} #Point{2, Float64}(0.0, 0.0)
    vel::Observable{Point{2,Float64}} #Point{2, Float64}(0.0, 0.0)
    acc::Observable{Point{2,Float64}} #Point{2, Float64}(0.0, 0.0)
    mass::Float64 #1.0
    charge::Float64 #1.0
    color::Observable{String} #RED
    shape::Observable #GeometryBasics.Circle
    size::Observable{Float64} #10.0
    alpha::Observable{Float64} #1.0
end

function Particle2D(    
    pos::Point{2,Float64}=Point{2, Float64}(0.0, 0.0),
    vel::Point{2,Float64}=Point{2, Float64}(0.0, 0.0),
    acc::Point{2,Float64}=Point{2, Float64}(0.0, 0.0);
    mass::Float64=1.0,
    charge::Float64=1.0,
    color::String=RED,
    shape=GeometryBasics.Circle,
    size::Float64=10.0,
    alpha::Float64=1.0
    )
    return Particle2D(Observable(pos), Observable(vel), Observable(acc), mass, charge, Observable(color), Observable(shape), Observable(size), Observable(alpha))
end
    # function Particle2D(
    #     pos::Point2=Point{2, Float64}(0.0, 0.0),
    #     vel::Point2=Point{2, Float64}(0.0, 0.0),
    #     acc::Point2=Point{2, Float64}(0.0, 0.0),
    #     mass::Float64=1.0,
    #     charge::Float64=1.0,
    #     color::String=1.0,
    #     shape=GeometryBasics.Circle,
    #     size::Float64
    #     alpha::Float64
    # )
# end

😄




include("./MyColors.jl")
using GeometryBasics, .MyColors, Observables

struct Particle2D
  pos::Observable{Point{2,Float64}}  # Point{2, Float64}(0.0, 0.0)
  vel::Observable{Point{2,Float64}}  # Point{2, Float64}(0.0, 0.0)
  acc::Observable{Point{2,Float64}}  # Point{2, Float64}(0.0, 0.0)
  mass::Float64                      # 1.0
  charge::Float64                     # 1.0
  color::Observable{String}           # RED
  shape::Observable  # Shape of the particle (e.g., Circle)
  size::Observable{Float64}             # Size of the particle
  alpha::Observable{Float64}            # Transparency of the particle (0.0 to 1.0)
end

function Particle2D(
  pos::Point{2,Float64} = Point{2, Float64}(0.0, 0.0);
  vel::Point{2,Float64} = Point{2, Float64}(0.0, 0.0),
  acc::Point{2,Float64} = Point{2, Float64}(0.0, 0.0),
  mass::Float64 = 1.0,
  charge::Float64 = 1.0,
  color::String = RED,
  shape = GeometryBasics.Circle,
  size::Float64 = 10.0,
  alpha::Float64 = 1.0,
)
  return Particle2D(
      Observable(pos), Observable(vel), Observable(acc), mass, charge,
      Observable(color), Observable(shape), Observable(size), Observable(alpha),
  )
end

function Particle2D()
    return Particle2D(
        Observable(Point{2, Float64}(0.0,0.0)), Observable(Point{2, Float64}(0.0,0.0)), Observable(Point{2, Float64}(0.0,0.0)), 1.0, 1.0,
        Observable(RED), Observable(GeometryBasics.Circle), Observable(1.0), Observable(1.0),
    )
end

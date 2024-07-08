using GeometryBasics

@kwdef mutable struct Particle
    position::Point = Point3f(0)
    velocity::Point = Point3f(0)
    acceleration::Point = Point3f(0)

    velocity::Point

end


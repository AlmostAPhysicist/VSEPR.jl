
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
        new{T}(Observable(Point{3,T}(0, 0, 0)), Observable(Point{3,T}(0, 0, 0)), Observable(Point{3,T}(0, 0, 0)), T(0), T(0), Observable(RED), Observable(GeometryBasics.Circle), Observable(T(10)), Observable(T(1)))
    end
end
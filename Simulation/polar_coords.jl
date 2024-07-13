module PolarCoords

export c2p, p2c


#Coords Conversion
"""
    c2p(x::Real=0, y::Real=0, z::Real=0; convention=:math)
    
Converts Cartesian-coordinates (x, y, z) to Polar coordinates (r, θ, ϕ)

# Convention (takes a Keyword Argument)

- The azimuthal angle (`θ` in `:math`; `ϕ` in `:physics`) is measured between the orthogonal projection of the radial line r onto the reference x-y-plane

- The polar angle (`ϕ` in `:math`; `θ` in `:physics`) is measured between the z-axis and the radial line r. 

## I use the Geographical Convention (`convention=:math`) by default:

- (radial distance, azimuthal angle, polar angle) -> `(r, θ, ϕ)`

## In order to use the ISO convention, set `convention=:physics` for:
    
- (radial distance, polar angle, azimuthal angle)  -> `(r, θ, ϕ)`

>---

# Example
```jldoctest
julia> c2p(1, 2, 1)
3-element Vector{Float64}:
 2.449489742783178
 1.1071487177940904
 1.1502619915109316
```

>---

Resources: 

https://en.wikipedia.org/wiki/Spherical_coordinate_system

https://youtube.com/watch?v=sT8JIn7Q_Fo

>---
"""
function c2p(x::Real=0, y::Real=0, z::Real=0; convention=:math)

    r = round(sqrt(x^2 + y^2 + z^2), digits=10)

    if r == 0
        return [0, 0, 0]
    else
        θ = round(atan(y, x), digits=10) 
        ϕ = round(atan(sqrt(x^2+y^2), z), digits=10)

        if convention == :physics
            θ, ϕ = ϕ, θ
        end

        return [r, θ, ϕ]
    end
end

function c2p(point::Union{Tuple, AbstractVector}; convention=:math)
    c2p(point..., convention=convention)
end

"""
    p2c(r::Real=0, θ::Real=0, ϕ::Real=pi/2; convention=:math)

Converts Polar coordinates (r, θ, ϕ) to Cartesian-coordinates (x, y, z) 

# Convention (takes a Keyword Argument)
- The azimuthal angle (`θ` in `:math`; `ϕ` in `:physics`) is measured between the orthogonal projection of the radial line r onto the reference x-y-plane"

- The polar angle (`ϕ` in `:math`; `θ` in `:physics`) is measured between the z-axis and the radial line r. 

## I use the Geographical Convention (`convention=:math`) by default:

- (radial distance, azimuthal angle, polar angle) -> `(r, θ, ϕ)`


## In order to use the ISO convention, set `convention=:physics` for:
    
- (radial distance, polar angle, azimuthal angle)  -> `(r, θ, ϕ)`

"""
function p2c(r::Real=0, θ::Real=0, ϕ::Real=pi/2; convention=:math)
    if convention == :physics
        θ, ϕ = ϕ, θ
    end
    x = round(r * sin(ϕ) * cos(θ), digits=10)
    y = round(r * sin(ϕ) * sin(θ), digits=10)
    z = round(r * cos(ϕ), digits=10)

    return [x, y, z]
end
function p2c(point::Union{Tuple, AbstractVector}; convention=:math)
    p2c(point..., convention=convention)
end




end
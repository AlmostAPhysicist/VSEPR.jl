#COMPUTATIONAL FUNCTIONS


#Generating Points

"""
generate_points_on_sphere1(n::Int=1, radius::Real=1)

Outputs `n` random points on a sphere of certain `radius` that is centered at the origin

# Example
```jldoctest
julia> generate_points_on_sphere1(3)
3-element Vector{Vector{Float64}}:
[0.5148809325450439, -0.8074825329340483, 0.28787077709965564]
[-0.1843532405984674, -0.965501387767987, -0.1839047386527461]
[-0.800382696606448, 0.3023385844384595, 0.5176668033906936]
```

"""
function generate_points_on_sphere1(n::Int=1, radius::Real=1)
    
    theta = 2π * rand(n)
    phi = 2π * rand(n)
    # x = cos.(theta) .* sin.(phi)
    # y = sin.(theta) .* sin.(phi)
    # z = cos.(phi)
    return [p2c(radius, theta[i], phi[i]) for i in 1:n]
end

#Coords Conversion
"""
    c2p(x::Real=0, y::Real=0, z::Real=0; convention=:math)
    
Converts Cartesian-coordinates (x, y, z) to Polar coordinates (r, θ, ϕ)

# Convention (takes a Keyword Argument)
- The azimuthal angle (`θ` in `:math`; `ϕ` in `:physics`) is measured between the orthogonal projection of the radial line r onto the reference x-y-plane"

- The polar angle (`ϕ` in `:math`; `θ` in `:physics`) is measured between the z-axis and the radial line r. 

** I use the Geographical Convention (`convention=:math`) by default:

- (radial distance, azimuthal angle, polar angle) -> `(r, θ, ϕ)`


** In order to use the ISO convention, set `convention=:physics` for:
    
- (radial distance, polar angle, azimuthal angle)  -> `(r, θ, ϕ)`



# Example
```jldoctest
julia> c2p(1, 2, 1)
3-element Vector{Float64}:
 2.449489742783178
 1.1071487177940904
 1.1502619915109316
```

Resources: 

https://en.wikipedia.org/wiki/Spherical_coordinate_system

https://youtube.com/watch?v=sT8JIn7Q_Fo
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

** I use the Geographical Convention (`convention=:math`) by default:

- (radial distance, azimuthal angle, polar angle) -> `(r, θ, ϕ)`


** In order to use the ISO convention, set `convention=:physics` for:
    
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

#--Maximizing istance between points--

#Calculating force
function magnitude_sq(vect::Vector{<:Real})
    return sum(i*i for i in vect)
end

function force_on_1_d2_2(
    p1::Vector{<:Real}, 
    p2::Vector{<:Real}, 
    force_factor::Real
    )
    return (p1 .- p2).*(force_factor/max(magnitude_sq(p1-p2), 1e-6)) #krr̂/d^2    max(magnitude_sq(p2-p1), 1e-6) is to avoid division by zero
end

function calculate_net_force_on_point(
    points::Vector{<:Vector{<:Real}}, 
    point_index::Int, 
    force_factor::Real
    )
    net_force = zeros(3)
    for i in 1:length(points)
        if i != point_index
            net_force += force_on_1_d2_2(points[point_index], points[i], force_factor)
        end
    end
    return net_force
end

function apply_net_force!(
    points::Vector{<:Vector{<:Real}}, 
    point_index::Int,
    net_force::Vector{<:Real}, 
    radius::Real
    )
    # points[point_index] = p2c(radius, c2p((points[point_index] .+ net_force)...)[2:3]...)
    points[point_index] = radius .* normalize!(points[point_index] .+ net_force)
    return nothing
end

function update_all_points!(
    points::Vector{<:Vector{<:Real}},
    force_factor::Real,
    radius::Real
    )

    # net_forces = Vector{Vector{Real}}()
    # for point_index in 1:length(points)
    #     push!(net_forces, calculate_net_force_on_point(points, point_index, force_factor))
    # end
    # for point_index in 1:length(points)
    #     apply_net_force!(points, point_index, net_forces[point_index], radius)
    # end

    points_copy = copy(points)
    for point_index in 1:length(points)
        apply_net_force!(points, point_index, calculate_net_force_on_point(points_copy, point_index, force_factor), radius)
    end
    return nothing

        
end

function evolve_space!(
    points::Vector{<:Vector{<:Real}},
    iterations::Int,
    force_factor::Real, 
    radius::Real,
    show_evolution::Bool=true,
    min_time::Real=10
    )
    for iteration in 1:iterations
        update_all_points!(points, force_factor, radius)

        if show_evolution == true
            # println("Iteration : $(iteration)")

            plot3d() #Create an Empty setting
            plot_sphere!(radius)

            plot_points!(points)
            display(plot!())
            yield()
            sleep(min_time/iterations)

        end

    end

    println("Evolution Complete")
    return nothing
end



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



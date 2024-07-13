#COMPUTATIONAL FUNCTIONS
include("./polar_coords.jl")
include("./Particles.jl")
include("./MyColors.jl")

using .PolarCoords, .MyColors, .MyParticles, GLMakie, LinearAlgebra
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
function random_pt_on_sphere(radius::Real=1)
    theta = 2π * rand()
    phi = acos(2rand()-1)
    return p2c(radius, theta, phi)
end
function generate_points_on_sphere(n::Int64=1, radius::Real=1)
    #https://mathworld.wolfram.com/SpherePointPicking.html
    
    # x = cos.(theta) .* sin.(phi)
    # y = sin.(theta) .* sin.(phi)
    # z = cos.(phi)
    return [random_pt_on_sphere(radius) for _ in 1:n]
end


#--Maximizing istance between points--

#Calculating force
# function magnitude_sq(vect::Vector{<:Real})
#     return sum(i*i for i in vect)
# end

function force_on_1_d2_2(
    p1::Particle3D, 
    p2::Particle3D, 
    force_factor::Real
    )
    return (p1.pos[] .- p2.pos[]).*(force_factor*p1.charge[]*p2.charge[]/max((norm(p1.pos[]-p2.pos[]))^3, 1e-6)) #krr̂/d^2    max((norm(p2-p1))^2, 1e-6) is to avoid division by zero
end

function calculate_net_force_on_particle(
    particles::Vector{Particle3D{Float64}}, 
    index::Int64, 
    force_factor::Real
    )
    net_force = Point{3, Float64}(0)
    for i in 1:length(particles)
        if i != index
            net_force += force_on_1_d2_2(particles[index], particles[i], force_factor)
        end
    end
    return net_force
end

function apply_net_force!(
    particles::Vector{Particle3D{Float64}}, 
    index::Int64,
    net_force::Point{3, Float64}, 
    radius::Real
    )
    # points[point_index] = p2c(radius, c2p((points[point_index] .+ net_force)...)[2:3]...)
    particles[index].pos[] = radius .* normalize(particles[index].pos[] .+ net_force)
    return nothing
end

function update_all_particles!(
    particles::Vector{Particle3D{Float64}},
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

    particles_copy = copy(particles)
    for index in 1:length(particles)
        apply_net_force!(particles, index, calculate_net_force_on_particle(particles_copy, index, force_factor), radius)
    end
    return nothing
end


function main(Nparticles::Int64=3, iterations::Int64=100, force_factor::Real=1, show_evolution::Bool=true, min_time::Real=10, radius::Real=1)
    particles = [Particle3D(i, size=0.3/sqrt(Nparticles), color=OCEAN_BLUE) for i in generate_points_on_sphere(Nparticles)]
    s = Scene(camera=cam3d!, size=(600,600), backgroundcolor=BLACK)
    display(s)
    central_atom = Particle3D(alpha=0.9)
    meshscatter!(s, central_atom.pos, marker=central_atom.shape, markersize=central_atom.size, color=central_atom.color, alpha=central_atom.alpha, transparency=true)
    for p in particles
        meshscatter!(s, p.pos, marker=p.shape, markersize=p.size, color=p.color)
    end
    return particles

end


function evolve_space!(
    particles::Vector{Particle3D{Float64}},
    iterations::Int64=1000,
    force_factor::Real=0.075, 
    radius::Real=1;
    show_evolution::Bool=true,
    time::Real=10
    )
    for iteration in 1:iterations
        update_all_particles!(particles, force_factor, radius)

        if show_evolution == true
            # println("Iteration : $(iteration)")

            # yield()
            sleep(1/sqrt(length(particles))*time/iterations)
        end

    end

    println("Evolution Complete")
    return nothing
end



particles = main(5)
evolve_space!(particles, time=10)

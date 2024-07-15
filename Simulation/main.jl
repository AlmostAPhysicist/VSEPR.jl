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
    phi = acos(2rand() - 1)
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
    # return (p1.pos[] .- p2.pos[]).*(force_factor*p1.charge[]*p2.charge[]/max((norm(p1.pos[]-p2.pos[]))^3, 1e-10)) #krr̂/d^2    max((norm(p2-p1))^2, 1e-6) is to avoid division by zero
    return (p1.pos[] .- p2.pos[]) .* (force_factor * p1.charge[] * p2.charge[] / ((norm(p1.pos[] - p2.pos[]))^3))
end

function calculate_net_force_on_particle(
    particles::Vector{Particle3D{Float64}},
    index::Int64,
    force_factor::Real
)
    net_force = Point{3,Float64}(0)
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
    net_force::Point{3,Float64},
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



#Creating the Scene and Simulation 

import REPL.Terminals
function overprint(terminal::Terminals.TTYTerminal, content...; up::Int64=0)
    if up > 0
        Terminals.cmove_line_up(terminal, up)
    end
    Terminals.clear_line(terminal)
    print(content...)
    if up > 0
        Terminals.cmove_line_down(terminal, up)
        yield()
    end
end

calc_sleep_time(Nparticles::Int64, time::Real, iterations::Int64) = (time / iterations) * (1 - (1 / (time + 1))) * ((1 - (1 / (Nparticles + 1))))

function evolve_space!(
    particles::Vector{Particle3D{Float64}};
    iterations::Int64=1000,
    force_factor::Real=3 * 10^(-1 - log10(length(particles))),
    radius::Real=1,
    show_evolution::Bool=true,
    time::Real=10
)
    terminal = Terminals.TTYTerminal("", stdin, stdout, stderr)
    Nparticles = length(particles)
    for iteration in 1:iterations
        update_all_particles!(particles, force_factor, radius)

        if show_evolution == true
            #if sleep function is used for all iterations, 15 seconds is the minimum time taken for 1000 iterations.
            #sqrt(additional time)/sqrt(total iterations) ≈ 0.15
            overprint(terminal, "Iteration : $(iteration)")
            sleep(calc_sleep_time(Nparticles, time, iterations))
        else
            yield()
        end

    end

    println("\nEvolution Complete")
    return nothing
end

function main(Nparticles::Int64=3, central_atom_color::String=OFFWHITE, ligand_color::String=LIGHT_GREEN; radius::Real=1)
    particles = [Particle3D(i, size=0.3 / cbrt(Nparticles), color=ligand_color) for i in generate_points_on_sphere(Nparticles, radius)]
    s = Scene(camera=cam3d!, size=(600, 600), backgroundcolor=BLACK)
    display(s)
    central_atom = Particle3D(alpha=0.9, size=radius, color=central_atom_color)
    meshscatter!(s, central_atom.pos, marker=central_atom.shape, markersize=central_atom.size, color=central_atom.color, alpha=central_atom.alpha, transparency=true)
    for p in particles
        meshscatter!(s, p.pos, marker=p.shape, markersize=p.size, color=p.color)
    end
    return s, particles
end








# s, particles = main(5)
# evolve_space!(particles)

# include("../SimData/SaveLoad.jl")
# using .SaveLoad
# record(s, "VSEPR_simulaiton_sample.mp4"; framerate=60) do io
#     for i in 1:60 #1 second of wait time in start
#         recordframe!(io)
#         sleep(1 / 60)
#     end

#     evolve_task = @async evolve_space!(particles, iterations=500, force_factor=0.003, time=30)
#     while !istaskdone(evolve_task)
#         recordframe!(io)
#     end
# end


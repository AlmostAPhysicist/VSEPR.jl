include("./Particle.jl")
include("./MyColors.jl")
using GLMakie, .MyParticle, .MyColors, LinearAlgebra, GeometryBasics

const UnitSphere = normal_mesh(Tesselation(Sphere(Point3f(0), 1), 50))
function Base.show(io::IO, mime::MIME"text/plain", unitsphere::typeof(UnitSphere))
    show(io, mime, "UnitSphere (alias for Tesselated normal Mesh of Sphere)")
end
#System Variables
n=15
init_radius = 0.75
f_strength = 0.01
#//
iterations = 1000
dt=1/100

R = [0.0  1.0;
     -1.0 0.0]

function pt_on_circle(r)
    θ = rand(0:0.001:2pi)
    return r.*(cos(θ), sin(θ))
end

particles = [Particle2D(pt_on_circle(init_radius), color=rand(BASE_COLORS), size=rand()*0.2, shape=UnitSphere) for i in 1:n]

center_pt = Particle2D(size=0.5, color=OFFWHITE, shape=UnitSphere)

function update_p(particles, center_pt, f_strength, dt)
    for p in particles
        radial_vec = center_pt.pos[]-p.pos[]
        p.acc[] += radial_vec .* (f_strength / norm(radial_vec)^3)
        p.vel[] += p.acc[] .* dt
        p.pos[] += p.vel[] .* dt
    end
end


s = Scene(camera=cam3d!, backgroundcolor=BLACK, size=(600,600))
for p in particles
    meshscatter!(s, p.pos, marker=p.shape, markersize=p.size, color=p.color, transparency=true)
    p.vel[] = R*p.pos[]
end
meshscatter!(s, center_pt.pos, marker=center_pt.shape, markersize=center_pt.size, color=center_pt.color)
#markerspace=:data


record(s, "my_vid3d1_fullscreen.mp4"; framerate = 60) do io
for i in 1:iterations
    update_p(particles, center_pt, f_strength, dt)
    sleep(1/100)
    recordframe!(io)
end
end

function update_cp(pt)
    
end


center_pt.pos[]
for i in 1:10000
center_pt.pos[] += Point(1,1)
yield()
end
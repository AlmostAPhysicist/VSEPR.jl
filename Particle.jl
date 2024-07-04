include("./MyColors.jl")
using GeometryBasics, .MyColors, Observables

const UnitSphere = normal_mesh(Tesselation(Sphere(Point3f(0), 1), 50)) 
#You can also use Sphere() as a marker but I like this.
#mesh() would plot a mesh in Makie. GeometryBasics.mesh creates some non-colorable version of the object. normal_mesh is the way to go then.



mutable struct Particle
    #Kinetics
    position
    velocity
    acceleration

    #Intrinsic Properties
    mass
    charge
    color
    shape
    size
    transparency

    function Particle(position::Point3f=Point3f(0), velocity::Point3f=Point3f(0), acceleration::Point3f=Point3f(0);
        mass::Real=1, charge::Real=1, color::String=rand(BASE_COLORS),
        shape=UnitSphere,
        size::Real=10, transparency::Real=0)
        new(Observable(position), Observable(velocity), Observable(acceleration), Observable(mass), Observable(charge), Observable(color), Observable(shape), Observable(size), Observable(transparency))
    end

    function Particle(position::Point2f=Point2f(0), velocity::Point2f=Point2f(0), acceleration::Point2f=Point2f(0);
        mass::Real=1, charge::Real=1, color::String=rand(BASE_COLORS),
        shape=GeometryBasics.Circle, size::Real=10, transparency::Real=0)
        new(Observable(position), Observable(velocity), Observable(acceleration), Observable(mass), Observable(charge), Observable(color), Observable(shape), Observable(size), Observable(transparency))
    end
end

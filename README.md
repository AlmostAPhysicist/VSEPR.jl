
# VSEPR Simulation

This project is a Valence Shell Electron Pair Repulsion (VSEPR) model visualisation in 3D space using `GLMakie` in Julia. The particles representing atoms or electron pairs are positioned on a sphere and then repelled from each other to achieve an equilibrium configuration.

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/VSEPR-simulation.git
    cd VSEPR-simulation
    ```

2. Install the required Julia packages:
    ```julia
    using Pkg
    Pkg.activate(".")
    Pkg.instantiate()
    ```

## Usage



### Main Functions

#### `main`

The `main` function initializes the simulation with a given number of particles and parameters.

```julia
function main(
    Nparticles::Int64=3, 
    iterations::Int64=100, 
    force_factor::Real=1, 
    show_evolution::Bool=true, 
    min_time::Real=10, 
    radius::Real=1
)
```

**Parameters:**
- `Nparticles`: Number of particles to simulate.
- `iterations`: Number of iterations for the simulation.
- `force_factor`: Factor for the repulsive force between particles.
- `show_evolution`: Boolean to show the evolution of the system.
- `min_time`: Minimum time for the simulation.
- `radius`: Radius of the sphere.

**Returns:**
- `particles`: Vector of `Particle3D` objects.

**Example:**
```julia
particles = main(5)
```

#### `evolve_space!`

The `evolve_space!` function evolves the simulation over a number of iterations.

```julia
function evolve_space!(
    particles::Vector{Particle3D{Float64}},
    iterations::Int64=1000,
    force_factor::Real=0.075, 
    radius::Real=1;
    show_evolution::Bool=true,
    time::Real=10
)
```

**Parameters:**
- `particles`: Vector of `Particle3D` objects.
- `iterations`: Number of iterations for the simulation.
- `force_factor`: Factor for the repulsive force between particles.
- `radius`: Radius of the sphere.
- `show_evolution`: Boolean to show the evolution of the system.
- `time`: Total time for the simulation.

**Example:**
```julia
particles = main(5)
evolve_space!(particles, time=10)
```

### Running the Simulation

To run the simulation, use the `main` and `evolve_space!` functions:

```julia
particles = main(5)
evolve_space!(particles, time=10)
```
### Particle Structs

The simulation uses custom `Particle2D` and `Particle3D` structs to represent particles in 2D and 3D space, respectively. These structs include observable properties for position, velocity, acceleration, mass, charge, color, shape, size, and transparency.

#### `Particle2D`
```julia
struct Particle2D{T<:Real} <: Particle
    pos::Observable{Point{2,T}}
    vel::Observable{Point{2,T}}
    acc::Observable{Point{2,T}}
    mass::T
    charge::T
    color::Observable{String}
    shape::Observable
    size::Observable{T}
    alpha::Observable{T}
end
```

#### `Particle3D`
```julia
struct Particle3D{T<:Real} <: Particle
    pos::Observable{Point{3,T}}
    vel::Observable{Point{3,T}}
    acc::Observable{Point{3,T}}
    mass::T
    charge::T
    color::Observable{String}
    shape::Observable
    size::Observable{T}
    alpha::Observable{T}
end
```
This will initialize the simulation with 5 particles and evolve the system over time.

## License

This project is licensed under the Apache 2.0 License.

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

## Acknowledgments

This project uses [GLMakie](https://github.com/JuliaPlots/GLMakie.jl) for visualization and [GeometryBasics](https://github.com/JuliaGeometry/GeometryBasics.jl) for geometry definitions.

---

Feel free to customize the README further according to your preferences and add any additional details or sections you find necessary.

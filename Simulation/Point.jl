using StaticArrays

struct Vec3d{T<:Real} <: FieldVector{3, T}
    x::T
    y::T
    z::T

    # Inner constructor to allow automatic type parameter inference and conversion
    function Vec3d(x::T=0, y::T=0, z::T=0) where T<:Real
        new{T}(x, y, z)
    end

    # Additional constructor to handle mixed types and convert to the same type
    function Vec3d(x::Real, y::Real, z::Real)
        T = promote_type(typeof(x), typeof(y), typeof(z))
        new{T}(convert(T, x), convert(T, y), convert(T, z))
    end
end
Vec3d{T}(x::T, y::T, z::T) where {T<:Real} = Vec3d(x, y, z)

#Terminate the Project.

#Although this is ~better than Point, makie inherently uses Point.
#The only reason to use this is to have `mutable` types and fields x,y,z  but Observables do not support mutable Fields.
#So I see no reason using my own Type only to have Point.x, Point.y, Point.z when I can have Point[1]
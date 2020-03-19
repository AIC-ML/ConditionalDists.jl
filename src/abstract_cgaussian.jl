abstract type AbstractConditionalGaussian <: AbstractConditionalDistribution end
const ACGaussian = AbstractConditionalGaussian

"""Abstract variance type"""
abstract type AbstractVar end

"""Diagonal variance represented as a vector"""
struct DiagVar <: AbstractVar end

"""Scalar variance represented as a one-element vector"""
struct ScalarVar <: AbstractVar end

function rand(p::ACGaussian, z::AbstractArray)
    (μ, σ2) = mean_var(p, z)
    r = randn!(similar(μ))
    μ .+ sqrt.(σ2) .* r 
end

function _logpdf(p::ACGaussian, x::AbstractArray, z::AbstractArray)
    (μ, σ2) = mean_var(p, z)
    d = x - μ
    y = d .* d
    y = (1 ./ σ2) .* y .+ log.(σ2) .+ eltype(p)(log(2π))
    -sum(y, dims=1) / 2
end

logpdf(p::ACGaussian, x::AbstractVector, z::AbstractVector) = _logpdf(p,x,z)
logpdf(p::ACGaussian, X::AbstractMatrix, Z::AbstractMatrix) = _logpdf(p,X,Z)

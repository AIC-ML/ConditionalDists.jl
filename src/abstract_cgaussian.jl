abstract type AbstractConditionalGaussian <: AbstractConditionalDistribution end
const ACGaussian = AbstractConditionalGaussian

"""Abstract variance type"""
abstract type AbstractVar end

"""Diagonal variance represented as a vector"""
struct DiagVar <: AbstractVar end

"""Scalar variance represented as a one-element vector"""
struct ScalarVar <: AbstractVar end

"""
    mean_var(p::Gaussian)

Returns mean and variance of a Gaussian.
"""
mean_var(p::Gaussian)

"""
    mean(p::Gaussian)

Returns mean of a Gaussian.
"""
mean(p::Gaussian)

"""
    var(p::Gaussian)

Returns variance of a Gaussian.
"""
var(p::Gaussian)

"""
    rand(p::Gaussian; batch=1)

Produce `batch` number of samples from a Gaussian.
"""
rand(p::Gaussian, batchsize::Int=1)

"""
    logpdf(p::Gaussian, x::AbstractArray)

Computes log p(x|μ,σ2).
"""
logpdf(p::Gaussian, x::AbstractArray)


"""
    mean_var(p::AbstractConditionalGaussian, z::AbstractArray)

Returns mean and variance of a conditional Gaussian.
"""
mean_var(p::AbstractConditionalGaussian, z::AbstractArray)


"""
    mean(p::AbstractConditionalGaussian, z::AbstractArray)

Returns mean of a conditional Gaussian.
"""
mean(p::AbstractConditionalGaussian, z::AbstractArray)

"""
    var(p::AbstractConditionalGaussian, z::AbstractArray)

Returns variance of a conditional Gaussian.
"""
var(p::AbstractConditionalGaussian, z::AbstractArray)

"""
    rand(p::AbstractConditionalGaussian, z::AbstractArray)

Produce `batch` number of samples from a conditional Gaussian.
"""
function rand(p::AbstractConditionalGaussian, z::AbstractArray)
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

"""
    logpdf(p::AbstractConditionalGaussian, x::AbstractArray, z::AbstractArray)

Computes log p(x|z).
"""
logpdf(p::ACGaussian, x::AbstractVector, z::AbstractVector) = _logpdf(p,x,z)
logpdf(p::ACGaussian, X::AbstractMatrix, Z::AbstractMatrix) = _logpdf(p,X,Z)

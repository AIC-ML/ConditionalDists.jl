@testset "Gaussian" begin

    T  = Float32
    p  = Gaussian(zeros(T,2), ones(T,2)) |> gpu
    μ  = mean(p)
    σ2 = var(p)
    @test mean_var(p) == (μ, σ2)
    @test size(rand(p, 10)) == (2, 10)
    @test size(logpdf(p, randn(T, 2, 10)|>gpu)) == (1, 10)
    @test size(logpdf(p, randn(T, 2)|>gpu)) == (1,)
    @test eltype(p) == T
    @test all(cov(p) * gpu(ones(T,2)) .== σ2)
    @test length(p) == 2

    q = Gaussian(zeros(2), ones(2)) |> gpu
    @test length(Flux.trainable(q)) == 2

    msg = sprint(show, p)
    @test occursin("Gaussian", msg)

    μ = NoGradArray(zeros(2))
    p = Gaussian(μ, ones(2))
    @test length(Flux.trainable(p)) == 1

    # test gradient
    p = Gaussian(μ, ones(2)) |> gpu
    x = randn(2, 10) |> gpu
    loss() = sum(logpdf(p,x))
    ps = params(p)
    gs = Flux.gradient(loss, ps)
    for _p in ps @test all(abs.(gs[_p]) .> 0) end

end

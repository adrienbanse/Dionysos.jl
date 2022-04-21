abstract type DomainType{N,T} end

# Without S, add_set! and remove_set! where not type-stable...
struct DomainList{N,T,S<:Grid{N,T}} <: DomainType{N,T}
    grid::S
    elems::Set{NTuple{N,Int}}
end

function DomainList(grid::S) where {N,S<:Grid{N}}
    return DomainList(grid, Set{NTuple{N,Int}}())
end

function add_pos!(domain::DomainList, pos)
    push!(domain.elems, pos)
end

function add_coord!(domain, x)
    add_pos!(domain, get_pos_by_coord(domain.grid, x))
end

function add_set!(domain, rect::UT.HyperRectangle, incl_mode::INCL_MODE)
    rectI = get_pos_lims(domain.grid, rect, incl_mode)
    for pos in Iterators.product(_ranges(rectI)...)
        add_pos!(domain, pos)
    end
end

function get_subset_pos(domain::DomainList,rect::UT.HyperRectangle,incl_mode::INCL_MODE)
    rectI = get_pos_lims(domain.grid, rect, incl_mode)
    pos_iter = Iterators.product(_ranges(rectI)...)
    posL = []
    for pos in pos_iter
        if pos ∈ domain
            push!(posL, pos)
        end
    end
    return posL
end

function add_subset!(domain1, domain2, rect::UT.HyperRectangle, incl_mode::INCL_MODE)
    rectI = get_pos_lims(domain1.grid, rect, incl_mode)
    pos_iter = Iterators.product(_ranges(rectI)...)
    if length(pos_iter) < get_ncells(domain2)
        for pos in pos_iter
            if pos ∈ domain2
                add_pos!(domain1, pos)
            end
        end
    else
        for pos in enum_pos(domain2)
            if pos ∈ rectI
                add_pos!(domain1, pos)
            end
        end
    end
end

function remove_pos!(domain::DomainList, pos)
    delete!(domain.elems, pos)
end

function remove_coord!(domain, x)
    remove_pos!(domain, get_pos_by_coord(domain.grid, x))
end

function remove_set!(domain, rect::UT.HyperRectangle, incl_mode::INCL_MODE)
    rectI = get_pos_lims(domain.grid, rect, incl_mode)
    pos_iter = Iterators.product(_ranges(rectI)...)
    if length(pos_iter) < get_ncells(domain)
        for pos in pos_iter
            remove_pos!(domain, pos)
        end
    else
        for pos in enum_pos(domain)
            if pos ∈ rectI
                remove_pos!(domain, pos)
            end
        end
    end
end

function Base.union!(domain1::DomainList, domain2::DomainList)
    union!(domain1.elems, domain2.elems)
end

function Base.setdiff!(domain1::DomainList, domain2::DomainList)
    setdiff!(domain1.elems, domain2.elems)
end

function Base.empty!(domain::DomainList)
    empty!(domain.elems)
end

function Base.in(pos, domain::DomainList)
    return in(pos, domain.elems)
end

function Base.isempty(domain::DomainList)
    return isempty(domain.elems)
end

function Base.issubset(domain1::DomainList, domain2::DomainList)
    return issubset(domain1.elems, domain2.elems)
end

function get_ncells(domain::DomainList)
    return length(domain.elems)
end

function get_somepos(domain::DomainList)
    return first(domain.elems)
end

function enum_pos(domain::DomainList)
    return domain.elems
end


function get_coord(domain::DomainType, pos)
    return get_coord_by_pos(domain.grid,pos)
end

function rectangle(c,r)
    Shape(c[1].-r[1] .+ [0,2*r[1],2*r[1],0], c[2].-r[2] .+ [0,0,2*r[2],2*r[2]])
end


function Plots.plot!(Xdom::DomainType{N,T};opacity=0.2,dims=[1,2], color=:yellow) where {N,T}
    grid = Xdom.grid
    dict = Dict{NTuple{2,Int}, Any}()
    for pos in enum_pos(Xdom)
        if !haskey(dict,pos[dims])
            dict[pos[dims]] = true
            plot_elem!(grid, pos; dims=dims, opacity=opacity, color=color)
        end
    end
end

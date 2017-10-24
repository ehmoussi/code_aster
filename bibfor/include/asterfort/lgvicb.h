interface
    subroutine lgvicb(ndim, nno1, nno2, npg, g,axi,r,&
                      bst, vff2, dfdi2, nddl, b)
        integer :: ndim
        integer :: nno1        
        integer :: nno2
        integer :: npg
        integer :: g        
        aster_logical :: axi
        real(kind=8) :: r   
        real(kind=8) :: bst(6,nno1*ndim)
        real(kind=8) :: vff2(nno2)
        real(kind=8) :: dfdi2(nno2*ndim)
        integer :: nddl
        real(kind=8) :: b(3*ndim+4,nddl) 
    end subroutine lgvicb
end interface


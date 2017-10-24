interface
    subroutine lggvmb(ndim, nno1, nno2, npg, g,axi,r,&
                      bst, vff2, dfdi2, nddl,&
                      neps, b, w)
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
        integer :: neps
        real(kind=8) :: b(3*ndim+2,nddl) 
        real(kind=8) :: w
    end subroutine lggvmb
end interface


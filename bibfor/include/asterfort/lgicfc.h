interface
    subroutine lgicfc(ndim, nno1, nno2, npg, nddl, axi,grand,&
                      geoi, ddlm, vff1, vff2, idfde1,idfde2, &
                      iw,sigmag,fint)
        integer :: ndim
        integer :: nno1        
        integer :: nno2
        integer :: npg      
        integer :: nddl
        aster_logical :: axi
        aster_logical :: grand
        real(kind=8) :: geoi(ndim*nno1)
        real(kind=8) :: ddlm(nddl)
        real(kind=8) :: vff1(nno1,npg)
        real(kind=8) :: vff2(nno2,npg)
        integer :: idfde1        
        integer :: idfde2
        integer :: iw       
        real(kind=8) :: sigmag(3*ndim+2,npg)
        real(kind=8) :: fint(nddl)
    end subroutine lgicfc
end interface


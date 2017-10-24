interface
    subroutine nglgic(fami,option, typmod, ndim, nno,nnob,neps,&
                      npg, nddl, iw, vff,vffb, idff,idffb,&
                      geomi, compor, mate, lgpg,&
                      crit, angmas, instm, instp, matsym,&
                      ddlm, ddld, sigmg, vim, sigpg,&
                      vip, fint,matr, codret)
        character(len=*) :: fami              
        character(len=16) :: option
        character(len=8) :: typmod(*)
        integer :: ndim     
        integer :: nno
        integer :: nnob
        integer :: neps        
        integer :: npg
        integer :: nddl
        integer :: iw
        real(kind=8) :: vff(nno, npg)
        real(kind=8) :: vffb(nnob, npg)      
        integer :: idff 
        integer :: idffb
        real(kind=8) :: geomi(ndim,nno)
        character(len=16) :: compor(*)
        integer :: mate
        integer :: lgpg
        real(kind=8) :: crit(*)
        real(kind=8) :: angmas(3)
        real(kind=8) :: instm
        real(kind=8) :: instp
        aster_logical :: matsym
        real(kind=8) :: ddlm(nddl)
        real(kind=8) :: ddld(nddl)
        real(kind=8) :: sigmg(neps,npg)
        real(kind=8) :: vim(lgpg, npg)
        real(kind=8) :: sigpg(neps,npg)
        real(kind=8) :: vip(lgpg, npg)
        real(kind=8) :: fint(nddl)
        real(kind=8) :: matr(nddl, nddl)
        integer :: codret
    end subroutine nglgic
end interface

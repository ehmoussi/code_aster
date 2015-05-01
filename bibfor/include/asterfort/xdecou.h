!
! COPYRIGHT (C) 1991 - 2015  EDF R&D                WWW.CODE-ASTER.ORG
!
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
! 1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
!
interface
    subroutine xdecou(ndim, elp, nnop, nnose, it,&
                      pintt, cnset, lsn, fisco, igeom,&
                      nfiss, ifiss, pinter, ninter, npts,&
                      ainter, lonref, nfisc)
        integer :: nfisc
        integer :: nnop
        integer :: ndim
        character(len=8) :: elp
        integer :: nnose
        integer :: it
        real(kind=8) :: pintt(*)
        integer :: cnset(*)
        real(kind=8) :: lsn(*)
        integer :: fisco(*)
        integer :: igeom
        integer :: nfiss
        integer :: ifiss
        real(kind=8) :: pinter(*)
        integer :: ninter
        integer :: npts
        real(kind=8) :: ainter(*)
        real(kind=8) :: lonref
    end subroutine xdecou
end interface

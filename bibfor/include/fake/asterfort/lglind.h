!
! COPYRIGHT (C) 1991 - 2013  EDF R&D                WWW.CODE-ASTER.ORG
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
    subroutine lglind(nbmat, mater, parame, ge, q,&
                      vecn, deps, devg, devgii, traceg,&
                      dy)
        integer :: nbmat
        real(kind=8) :: mater(nbmat, 2)
        real(kind=8) :: parame(5)
        real(kind=8) :: ge
        real(kind=8) :: q(6)
        real(kind=8) :: vecn(6)
        real(kind=8) :: deps(6)
        real(kind=8) :: devg(6)
        real(kind=8) :: devgii
        real(kind=8) :: traceg
        real(kind=8) :: dy(10)
    end subroutine lglind
end interface

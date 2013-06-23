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
    subroutine mahsms(ind1, nb1, xi, ksi3s2, intsr,&
                      xr, epais, vectn, vectg, vectt,&
                      hsfm, hss)
        integer :: ind1
        integer :: nb1
        real(kind=8) :: xi(3, *)
        real(kind=8) :: ksi3s2
        integer :: intsr
        real(kind=8) :: xr(*)
        real(kind=8) :: epais
        real(kind=8) :: vectn(9, 3)
        real(kind=8) :: vectg(2, 3)
        real(kind=8) :: vectt(3, 3)
        real(kind=8) :: hsfm(3, 9)
        real(kind=8) :: hss(2, 9)
    end subroutine mahsms
end interface
